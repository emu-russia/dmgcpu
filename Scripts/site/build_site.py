#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
build_site.py — generate the DMG-CPU research static site into ``docs/``
(GitHub Pages, issue #402).

The site is built from every ``*.md`` file of the repository (root
Readme.md, wiki/, HDL/, netlist/, logisim/) plus the images those files
reference.  Referenced images are copied into ``docs/imgstore`` (optimised
web copies), so the site works standalone from ``file://`` and on GitHub
Pages under any base path (all URLs are relative).

Usage:
    python3 build_site.py            # full build (pages + media)
    python3 build_site.py --pages-only
    python3 build_site.py --no-media-copy

Dependencies (see requirements.txt): markdown, pillow.
"""

import argparse
import html as htmlmod
import os
import posixpath
import re
import shutil
import sys
import unicodedata
import xml.etree.ElementTree as ET
from pathlib import Path

from markdown import Markdown
from markdown.inlinepatterns import InlineProcessor
from markdown.treeprocessors import Treeprocessor
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
OUT_DIR = ROOT / "docs"
HERE = Path(__file__).resolve().parent
STATIC_DIR = HERE / "static"
MEDIA_REMOTE_DIR = HERE / "media_remote"

EXCLUDE_DIRS = {".git", "temp", "docs", "Scripts", "node_modules",
                "__pycache__", ".venv"}

MAX_SIDE = 3200            # longest image side for site copies (px)
JPEG_QUALITY = 86

MEDIA_KEY_RE = re.compile(r"\.(png|jpe?g|gif|webp)$", re.I)

# remote images referenced by the markdown that we vendor locally
REMOTE_MEDIA = [
    # (url, local name under docs/imgstore/external/)
    ("https://github.com/user-attachments/assets/bc920560-4023-476e-b022-626f891a41a6",
     "sch_bank_1.png"),
    ("https://github.com/user-attachments/assets/077ad18e-26e8-4cab-b9ed-d5ad38610d31",
     "sch_bank_2.png"),
]
REMOTE_BY_URL = {u: n for u, n in REMOTE_MEDIA}

# --------------------------------------------------------------------------
# small helpers
# --------------------------------------------------------------------------

def rel_url(base_dir_rel, target_rel):
    """Relative URL from an output page directory ('' or 'wiki/sm83') to a
    target file under docs/, always a clean '../..'-style posix path."""
    if base_dir_rel == "." or base_dir_rel == "":
        return target_rel
    return posixpath.relpath(target_rel, base_dir_rel)


def page_prefix(out_dir):
    """Relative path from an output page directory up to docs/ root
    ('' for pages at the root, '../..' for docs/wiki/sm83/...)."""
    if out_dir == "." or out_dir == "":
        return ""
    return posixpath.relpath(".", out_dir)


def strip_markup(text):
    """Rough markdown-to-plain-text for titles / descriptions."""
    text = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", text)      # links
    text = re.sub(r"!\[([^\]]*)\]\([^)]*\)", r"\1", text)      # images
    text = re.sub(r"[`*_~>#]", "", text)                       # syntax chars
    text = htmlmod.unescape(text)
    return re.sub(r"\s+", " ", text).strip()


def gh_slugify(text, separator="-"):
    """GitHub-compatible heading slug (anchors written in the markdown must
    resolve to the ids we emit).  signature: (text, separator) as python-
    markdown's toc extension calls slugify(value, separator)."""
    s = unicodedata.normalize("NFC", htmlmod.unescape(text)).strip().lower()
    s = re.sub(r"[^\w\s-]", "", s, flags=re.UNICODE)   # drop punctuation
    s = re.sub(r"[\s]+", "-", s)
    s = re.sub(r"-+", "-", s)
    return s.strip("-") or "section"


EMOJI = {
    ":warning:": "⚠️",
    ":smiley:": "😄",
    ":smile:": "😄",
    ":+1:": "👍",
    ":white_check_mark:": "✅",
    ":x:": "❌",
}


def sub_emoji(text):
    for k, v in EMOJI.items():
        if k in text:
            text = text.replace(k, v)
    return text


_LIST_START = re.compile(r"^ {0,3}([-*+]|\d{1,4}[.)])\s+\S")
_HEAD_START = re.compile(r"^ {0,3}#{1,6}\s+\S")
_MARKER_START = re.compile(r"^ {0,3}([-*+]|\d{1,4}[.)])\s")
_HEAD_MARK = re.compile(r"^ {0,3}#{1,6}\s")


def fix_lazy_blocks(text):
    """Insert blank lines before list items / headings that directly follow a
    paragraph.  GitHub (CommonMark) lets a list or ATX heading interrupt a
    paragraph; python-markdown does not, so we normalise the source first."""
    out = []
    prev = ""
    in_fence = False
    for line in text.split("\n"):
        ls = line.lstrip()
        if ls.startswith("```"):
            in_fence = not in_fence
        need_break = False
        if not in_fence and prev.strip():
            pv = prev.strip()
            if (_LIST_START.match(line) and
                    not _MARKER_START.match(pv) and
                    not pv.startswith((">", "|", "#", "```", "<", "!["))):
                need_break = True
            elif (_HEAD_START.match(line) and
                  not _HEAD_MARK.match(pv) and
                  not pv.startswith((">", "|", "#", "```", "<", "!["))):
                need_break = True
        if need_break and out and out[-1].strip():
            out.append("")
        out.append(line)
        prev = line
    return "\n".join(out)


# --------------------------------------------------------------------------
# custom markdown processors
# --------------------------------------------------------------------------

class StrikeInline(InlineProcessor):
    """~~strikethrough~~"""
    def __init__(self, md):
        super().__init__(r"~~(?P<txt>.+?)~~", md)

    def handleMatch(self, m, data):
        el = ET.Element("del")
        el.text = m.group("txt")
        return el, m.start(0), m.end(0)


def et_replace_child(parent, old, new):
    """xml.etree.ElementTree has no Element.replace(); emulate it."""
    idx = list(parent).index(old)
    parent.insert(idx, new)
    parent.remove(old)


class CalloutProcessor(Treeprocessor):
    """GitHub-style alerts: > [!NOTE] / [!TIP] / [!WARNING] / [!CAUTION] /
    [!IMPORTANT] -> <div class="callout callout-<type>">."""
    marker = re.compile(r"\[!(NOTE|TIP|WARNING|IMPORTANT|CAUTION)\]\s*([^\n]*)",
                        re.I)

    def run(self, root):
        for parent in list(root.iter()):
            for bq in list(parent):
                if bq.tag != "blockquote":
                    continue
                self._convert(parent, bq)
        return None

    def _convert(self, parent, bq):
        if len(bq) == 0:
            return
        first = bq[0]
        if first.tag != "p":
            return
        head = first.text or ""
        m = self.marker.match(head.strip())
        if not m:
            return
        typ = m.group(1).lower()
        title = m.group(2).strip()
        div = ET.Element("div")
        div.set("class", "callout callout-%s" % typ)
        # strip the marker (and any newline right after it)
        lead = head.find(m.group(0)) + len(m.group(0))
        first.text = (head[lead:] or "").lstrip("\n").lstrip()
        if title:
            headp = ET.Element("p")
            headp.set("class", "callout-title")
            headp.text = title
            div.append(headp)
        if not (first.text or len(first)):
            bq.remove(first)              # empty <p> left behind
        # stdlib ElementTree.append() does NOT detach from the old parent,
        # so remove each child explicitly before moving it into the callout
        while len(bq):
            child = bq[0]
            bq.remove(child)
            div.append(child)
        et_replace_child(parent, bq, div)


class TaskListProcessor(Treeprocessor):
    """GFM task list items -> disabled checkboxes.  Handles both tight
    (<li>[ ] text</li>) and loose (<li><p>[ ] text</p></li>) items."""
    task = re.compile(r"\[([ xX])\]\s+")

    def run(self, root):
        for li in list(root.iter("li")):
            # where does the marker text live?
            host, text = None, ""
            if (li.text or "").startswith("["):
                host, text = li, li.text
            elif len(li):
                p0 = li[0]
                if p0.tag == "p" and (p0.text or "").startswith("["):
                    host, text = p0, p0.text
            if host is None:
                continue
            m = self.task.match(text)
            if not m:
                continue
            li.set("class", (li.get("class") or "") + " task-list")
            box = ET.Element("input")
            box.set("type", "checkbox")
            if m.group(1).lower() == "x":
                box.set("checked", "checked")
            box.set("disabled", "disabled")
            host.text = text[m.end():]
            host.insert(0, box)
        return None


class EmojiProcessor(Treeprocessor):
    def run(self, root):
        for el in root.iter():
            if el.tag in ("pre", "code", "script", "style"):
                continue
            if el.text and ":" in el.text:
                el.text = sub_emoji(el.text)
            if el.tail and ":" in el.tail:
                el.tail = sub_emoji(el.tail)
        return None


class TableWrapProcessor(Treeprocessor):
    """Scrollable wrapper around tables (wide decoder / cell tables)."""
    def run(self, root):
        # snapshot the tree first: mutating it during a live iter() is not
        # supported by xml.etree and can loop forever
        for parent in list(root.iter()):
            for table in list(parent):
                if table.tag != "table":
                    continue
                wrap = ET.Element("div")
                wrap.set("class", "table-wrap")
                et_replace_child(parent, table, wrap)
                wrap.append(table)
        return None


class LinkRewriteProcessor(Treeprocessor):
    """Rewrite every local href/src so it works from the page's output
    location, map .md links to .html pages and media to docs/imgstore."""

    def __init__(self, md, page):
        super().__init__(md)
        self.page = page

    def run(self, root):
        pg = self.page
        for el in root.iter():
            if el.tag in ("a", "img"):
                attr = "href" if el.tag == "a" else "src"
                url = el.get(attr)
                if not url:
                    continue
                new = pg.rewrite_local(url)
                if new:
                    el.set(attr, new)
                if el.tag == "a":
                    tgt = el.get("href") or ""
                    if tgt.startswith("http"):
                        el.set("target", "_blank")
                        el.set("rel", "noopener noreferrer")
            elif el.tag == "img":
                el.set("loading", "lazy")
                el.set("decoding", "async")
        return None


class ImgLazyProcessor(Treeprocessor):
    def run(self, root):
        for im in root.iter("img"):
            if not im.get("loading"):
                im.set("loading", "lazy")
                im.set("decoding", "async")
        return None


# --------------------------------------------------------------------------
# page model
# --------------------------------------------------------------------------

class Page:
    """One source .md file rendered into one docs/...html page."""

    def __init__(self, src_rel, repo):
        self.src_rel = src_rel
        self.out_rel = posixpath.splitext(src_rel)[0] + ".html"
        self.out_dir = posixpath.dirname(self.out_rel)
        self.title = ""
        self.desc = ""
        self.body_html = ""
        self.toc_html = ""
        self.heading_count = 0
        self.repo = repo
        self._fixed = None
        with open(ROOT / src_rel, encoding="utf-8", errors="replace") as f:
            self.source = f.read()
        self._parse_meta()

    def render_source(self):
        """Markdown text fed to the converter (lazy-list / heading
        interruption normalised, like GitHub's renderer)."""
        if self._fixed is None:
            self._fixed = fix_lazy_blocks(self.source)
        return self._fixed

    def _parse_meta(self):
        """Grab title (first # line) and a description (first plain
        paragraph) straight from the markdown source."""
        for line in self.source.splitlines():
            m = re.match(r"^ {0,3}# (.*)$", line)
            if m and not m.group(1).startswith("#"):
                self.title = strip_markup(m.group(1))
                break
        if not self.title:
            self.title = Path(self.src_rel).stem.replace("_", " ").strip()
        # description: first paragraph without markdown block markers
        lines = self.source.splitlines()
        para = []
        for line in lines:
            s = line.strip()
            if not s:
                if para:
                    break
                continue
            if s.startswith(("#", "!", ">", "|", "```", "<")) or re.match(
                    r"^([-*+]|\d+[.)])\s", s):
                if para:
                    break
                continue
            para.append(line.strip())
        if para:
            txt = strip_markup(" ".join(para))
            if len(txt) > 200:
                cut = txt[:200]
                brk = max(cut.rfind(". "), cut.rfind(": "), cut.rfind("; "))
                if brk > 80:
                    txt = cut[:brk + 1]
                else:
                    txt = cut + "…"
            self.desc = txt

    # -- URL resolution ---------------------------------------------------
    def rewrite_local(self, url):
        """Rewrite one href/src of this page.  Returns new URL or None when
        it should stay untouched."""
        url = url.strip()
        if not url or url.startswith(("#", "http://", "https://", "mailto:")):
            # remote github user-attachments images -> vendored copies
            if url.startswith("https://github.com/user-attachments/"):
                name = REMOTE_BY_URL.get(url)
                if name:
                    return rel_url(self.out_dir, posixpath.join("imgstore/external", name))
                return None
            return None
        head, sep, frag = url.partition("#")
        path = head or url
        if not path:
            return None  # fragment-only
        if path.startswith("/"):
            rp = posixpath.normpath(path[1:])
        else:
            rp = posixpath.normpath(posixpath.join(posixpath.dirname(self.src_rel), path))
        if rp.startswith("../") or rp.startswith("/"):
            return None  # outside the repo tree
        frag = frag if sep else ""
        out = self.repo.resolve_dest(rp)   # docs-relative path or None
        if out is None:
            return None
        base = rel_url(self.out_dir, out)
        return base + ("#" + frag if frag else "")


class Repo:
    """Knowledge about the whole corpus: md files -> pages, media map."""

    def __init__(self):
        self.md_files = []
        for dirpath, dirnames, filenames in os.walk(ROOT):
            dirnames[:] = [d for d in dirnames
                           if d not in EXCLUDE_DIRS]
            for fn in filenames:
                if fn.endswith(".md"):
                    full = os.path.join(dirpath, fn)
                    rel = posixpath.normpath(os.path.relpath(full, ROOT))
                    self.md_files.append(rel)
        self.md_files.sort()
        self.pages = {rel: Page(rel, self) for rel in self.md_files}
        # page set used for .md link mapping
        self.page_out = {rel: p.out_rel for rel, p in self.pages.items()}
        # media: repo path -> docs-relative path
        self.media = {}
        self.media_remote_used = set()
        self._collect_media()
        self.prefix_cache = {}

    # -- media collection -------------------------------------------------
    def _iter_targets(self, page):
        for m in re.finditer(r"!?\[[^\]]*\]\(([^)]*)\)", page.source):
            t = m.group(1).strip()
            # keep http(s) targets: _collect_media routes the vendored ones;
            # drop mailto: and pure-fragment targets
            if not t or t.startswith(("mailto:", "#")):
                continue
            yield t

    def _collect_media(self):
        """Map every referenced local file (that is not a .md page) into its
        destination under docs/ (media live under docs/imgstore/...)."""
        media_sources = set()
        for rel, page in self.pages.items():
            for t in self._iter_targets(page):
                if "://" in t:
                    if t.startswith("https://github.com/user-attachments/"):
                        name = REMOTE_BY_URL.get(t)
                        if name:
                            self.media_remote_used.add(name)
                    continue
                path = t.split("#")[0]
                if not path:
                    continue
                if path.startswith("/"):
                    rp = posixpath.normpath(path[1:])
                else:
                    rp = posixpath.normpath(
                        posixpath.join(posixpath.dirname(rel), path))
                if rp.endswith(".md"):
                    continue
                if not (ROOT / rp).is_file():
                    print("  ! missing media:", rp, "(from", rel + ")")
                    continue
                media_sources.add(rp)
        for rp in sorted(media_sources):
            key = self.media_key(rp)
            self.media[rp] = key
            if key in self.media.values() and list(self.media.values()).count(key) > 1:
                pass  # impossible by construction

    @staticmethod
    def media_key(rp):
        """docs/ path for a repo media file: keep imgstore/… as-is, fold any
        other top folder under imgstore/<lower-top>/…."""
        parts = rp.split("/")
        if parts[0] == "imgstore" and len(parts) > 1:
            return "imgstore/" + "/".join(parts[1:])
        return "imgstore/" + parts[0].lower() + "/" + "/".join(parts[1:])

    def resolve_dest(self, rp):
        """docs-relative target for a repo-relative reference."""
        if rp in self.page_out:
            return self.page_out[rp]
        if rp in self.media:
            return self.media[rp]
        # same file referenced with different case? try case-insensitive
        low = rp.lower()
        for k in self.page_out:
            if k.lower() == low:
                return self.page_out[k]
        for k in self.media:
            if k.lower() == low:
                return self.media[k]
        return None


# --------------------------------------------------------------------------
# markdown rendering
# --------------------------------------------------------------------------

def make_markdown(page):
    md = Markdown(extensions=["tables", "fenced_code", "footnotes", "toc",
                              "sane_lists"],
                  extension_configs={
                      "toc": {"slugify": gh_slugify, "title": "",
                              "toc_depth": "2-4"},
                  })
    md.inlinePatterns.register(StrikeInline(md), "strike", 199)
    # treeprocessor priorities: built-ins run inline(20) > prettify(10) >
    # toc(5) > unescape(0), so register ours below 10 to run *after* inline
    # has produced the final <a>/<img> elements.
    md.treeprocessors.register(CalloutProcessor(md), "callout", 9)
    md.treeprocessors.register(TaskListProcessor(md), "tasklist", 8)
    md.treeprocessors.register(EmojiProcessor(md), "emoji", 7)
    md.treeprocessors.register(TableWrapProcessor(md), "tablewrap", 6)
    md.treeprocessors.register(LinkRewriteProcessor(md, page), "linkrw", 5)
    md.treeprocessors.register(ImgLazyProcessor(md), "imglazy", 4)
    return md


def render_toc(tokens):
    """Render md.toc_tokens as a nested list."""
    if not tokens:
        return ""
    out = ["<ol>"]
    stack = []
    for tok in tokens:
        lvl = tok["level"]
        name = htmlmod.escape(tok.get("name", ""))
        # strip emoji shortcodes in headings (already converted in text but
        # toc names come from raw heading text)
        name = sub_emoji(name)
        item = ('<li class="toc-l%d"><a href="#%s">%s</a>' %
                (min(lvl, 4), htmlmod.escape(tok["id"]), name))
        while stack and stack[-1] >= lvl:
            out.append("</li>")
            stack.pop()
        if stack and stack[-1] < lvl:
            out.append("<ol>")
            stack.append(lvl)
        out.append(item)
        stack.append(lvl)
    while stack:
        out.append("</li>")
        stack.pop()
    out.append("</ol>")
    return "".join(out)


# --------------------------------------------------------------------------
# media processing
# --------------------------------------------------------------------------

def optimise_media(src, dst):
    """Write an optimised web copy of an image; falls back to a plain copy
    when re-encoding is not smaller than the source."""
    dst.parent.mkdir(parents=True, exist_ok=True)
    ext = src.suffix.lower()
    try:
        im = Image.open(src)
        w, h = im.size
        scale = min(1.0, MAX_SIDE / max(w, h))
        if scale < 1.0:
            im = im.resize((max(1, round(w * scale)),
                            max(1, round(h * scale))), Image.LANCZOS)
        tmp = dst.with_suffix(".tmp" + ext)
        if ext in (".jpg", ".jpeg"):
            if im.mode != "RGB":
                im = im.convert("RGB")
            im.save(tmp, "JPEG", quality=JPEG_QUALITY, optimize=True,
                    progressive=True)
        elif ext == ".gif":
            im.save(tmp, "GIF")
        else:
            if im.mode in ("P", "LA"):
                im = im.convert("RGBA" if "A" in im.mode else "RGB")
            if im.mode in ("CMYK",):
                im = im.convert("RGB")
            im.save(tmp, "PNG", optimize=True)
        im.close()
        if tmp.stat().st_size < src.stat().st_size:
            tmp.replace(dst)
            return True
        tmp.unlink(missing_ok=True)
    except Exception as exc:                     # noqa: BLE001
        print("  ! media fallback (plain copy) for", src.name, ":", exc)
    shutil.copyfile(src, dst)
    return False


def copy_media(repo):
    """Copy all referenced media into docs/imgstore and vendor remote ones."""
    done = set()
    n_opt = n_copied = n_bytes = 0
    for rp, key in sorted(repo.media.items()):
        dst = OUT_DIR / key
        if dst in done:
            continue
        done.add(dst)
        if dst.exists() and dst.stat().st_size:
            continue
        src = ROOT / rp
        if optimise_media(src, dst):
            n_opt += 1
        else:
            n_copied += 1
        n_bytes += dst.stat().st_size
    # vendored remote images
    ext_dir = OUT_DIR / "imgstore" / "external"
    ext_dir.mkdir(parents=True, exist_ok=True)
    for name in sorted(repo.media_remote_used):
        dst = ext_dir / name
        if not dst.exists():
            shutil.copyfile(MEDIA_REMOTE_DIR / name, dst)
            n_copied += 1
        n_bytes += dst.stat().st_size
    print("media: %d files (%d optimised, %d plain) -> %.1f MB" %
          (len(done) + len(repo.media_remote_used), n_opt, n_copied,
           n_bytes / 1024 / 1024))


# --------------------------------------------------------------------------
# chrome (header / footer / breadcrumbs)
# --------------------------------------------------------------------------

NAV_ITEMS = [
    ("SoC", "wiki/soc/Readme.html"),
    ("SM83", "wiki/sm83/Readme.html"),
    ("PCB", "wiki/pcb.html"),
    ("Methods", "wiki/methods.html"),
    ("Tests", "HDL/soc/icarus/Readme.html"),
]

FOOT_COLS = [
    ("Wiki", [
        ("SoC overview", "wiki/soc/Readme.html"),
        ("SM83 core", "wiki/sm83/Readme.html"),
        ("Reference PCB", "wiki/pcb.html"),
        ("Research methods", "wiki/methods.html"),
        ("Datasets", "wiki/datasets.html"),
    ]),
    ("Verilog", [
        ("Icarus suites", "HDL/soc/icarus/Readme.html"),
        ("SM83 suite waves", "HDL/sm83/Icarus/waves.html"),
        ("PPU suite waves", "HDL/soc/icarus/ppu/waves.html"),
        ("APU suite waves", "HDL/soc/icarus/apu/waves.html"),
        ("GTKWave skill", "HDL/soc/icarus/gtkwave-skill.html"),
    ]),
    ("Links", [
        ("GitHub repository", "https://github.com/emu-russia/dmgcpu", True),
        ("Deroute utility", "https://github.com/emu-russia/Deroute", True),
        ("dmg-schematics", "https://github.com/msinger/dmg-schematics", True),
        ("gb-research (Gekkio)", "https://github.com/Gekkio/gb-research", True),
        ("issues", "https://github.com/emu-russia/dmgcpu/issues", True),
    ]),
]

THEME_INLINE = (
    '<script>(function(){try{var t=localStorage.getItem("dmgcpu-theme")'
    '||(window.matchMedia&&matchMedia("(prefers-color-scheme: dark)").matches'
    '?"dark":"light");document.documentElement.setAttribute("data-theme",t);}'
    'catch(e){document.documentElement.setAttribute("data-theme","light");}})();'
    "</script>"
)


def header_html(prefix):
    """Header + top nav; prefix = relative path from page to docs/ root."""
    def link(href, label, cls=""):
        if href.startswith("http"):
            return ('<a class="ext" href="%s" target="_blank" rel="noopener noreferrer">'
                    "%s ↗</a>" % (href, label))
        return '<a href="%s"%s>%s</a>' % (posixpath.join(prefix, href),
                                          (" class=\"%s\"" % cls) if cls else "",
                                          label)
    nav = []
    for label, target in NAV_ITEMS:
        nav.append(link(target, label))
    return """<a class="skip-link" href="#main">Skip to content</a>
<header class="topbar">
  <div class="wrap topbar-inner">
    <a class="brand" href="%s">
      <img class="brand-mark" src="%s" alt="" width="26" height="26">
      <span class="brand-name">DMG-CPU <b>Research</b></span>
    </a>
    <nav class="topnav" aria-label="Primary">%s%s</nav>
    <button class="theme-toggle" id="theme-toggle" type="button" aria-pressed="false"
            aria-label="Switch colour theme">
      <span class="sun" aria-hidden="true">☀</span><span class="moon" aria-hidden="true">☾</span>
    </button>
  </div>
</header>""" % (posixpath.join(prefix, "index.html"),
               posixpath.join(prefix, "assets", "favicon.svg"),
               "".join(nav),
               link("https://github.com/emu-russia/dmgcpu", "GitHub"))


def footer_html(prefix):
    cols = []
    for head, items in FOOT_COLS:
        li = []
        for it in items:
            lbl, href = it[0], it[1]
            if href.startswith("http"):
                li.append('<li><a href="%s" target="_blank" rel="noopener noreferrer">%s ↗</a></li>'
                          % (href, lbl))
            else:
                li.append('<li><a href="%s">%s</a></li>' %
                          (posixpath.join(prefix, href), lbl))
        cols.append("<div><h4>%s</h4><ul>%s</ul></div>" % (head, "".join(li)))
    return """<footer class="site-foot">
  <div class="wrap">
    <div class="about">
      <h4>DMG-CPU Research</h4>
      <p>Die-level reverse engineering of the Nintendo DMG-CPU SoC of the
      original Game&nbsp;Boy: from silicon photographs to a die-perfect
      Verilog netlist.</p>
      <p class="foot-note">Unofficial research project, not affiliated with or
      endorsed by Nintendo. Terminology conventions are defined in the
      <a href="%s">readme</a>.</p>
    </div>
    %s
  </div>
</footer>""" % (posixpath.join(prefix, "Readme.html"), "".join(cols))


def breadcrumb_html(prefix, out_rel, page):
    """Home / <dir chain> / current page title."""
    crumbs = ['<a href="%s">Home</a>' % posixpath.join(prefix, "index.html")]
    d = posixpath.dirname(out_rel)
    parts = d.split("/") if d else []
    acc = ""
    last_is_current = False
    for i, part in enumerate(parts):
        if not part:
            continue
        acc = acc + "/" + part if acc else part
        idx_md = acc + "/Readme.md"
        idx_html = acc + "/Readme.html"
        is_last_dir = i == len(parts) - 1
        is_this = is_last_dir and out_rel == idx_html
        if idx_md in REPO.pages:
            label = REPO.pages[idx_md].title or part.replace("_", " ")
        else:
            label = part.replace("_", " ")
        if is_this:
            crumbs.append('<span class="current">%s</span>' %
                          htmlmod.escape(label))
            last_is_current = True
        elif idx_md in REPO.pages:
            crumbs.append('<a href="%s">%s</a>' %
                          (posixpath.join(prefix, idx_html),
                           htmlmod.escape(label)))
        else:
            crumbs.append("<span>%s</span>" % htmlmod.escape(label))
    if not last_is_current:
        title = page.title or posixpath.basename(out_rel)[:-5]
        crumbs.append('<span class="current">%s</span>' %
                      htmlmod.escape(title))
    return ('<nav class="crumbs" aria-label="Breadcrumb">%s</nav>' %
            '<span class="sep">/</span>'.join(crumbs))


def page_chrome(prefix, out_rel, title, desc, crumbs, toc, body,
                article_foot=""):
    ttl = htmlmod.escape(title or "DMG-CPU Research")
    if title:
        ttl_full = "%s · DMG-CPU Research" % ttl
    else:
        ttl_full = "DMG-CPU Research"
    desc_a = htmlmod.escape(desc or "")
    fav = posixpath.join(prefix, "assets", "favicon.svg")
    css = posixpath.join(prefix, "assets", "site.css")
    js = posixpath.join(prefix, "assets", "site.js")
    return """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>%s</title>
<meta name="description" content="%s">
<link rel="icon" href="%s" type="image/svg+xml">
<link rel="stylesheet" href="%s">
%s
</head>
<body>
%s
<main id="main" class="wrap">
%s
%s
<article class="content">%s%s</article>
</main>
%s
<script src="%s"></script>
</body>
</html>""" % (ttl_full, desc_a, fav, css, THEME_INLINE,
             header_html(prefix), crumbs, toc, body, article_foot,
             footer_html(prefix), js)


REPO = None  # filled in main


def build_pages(pages_only=False):
    repo = REPO
    page_objs = [repo.pages[rel] for rel in repo.md_files]
    # render markdown bodies -------------------------------------------------
    for p in page_objs:
        md = make_markdown(p)
        try:
            p.body_html = md.convert(p.render_source())
        except Exception as exc:                     # noqa: BLE001
            print("  ! markdown failed for", p.src_rel, ":", exc)
            p.body_html = "<p><strong>Failed to render.</strong></p>"
        toks = getattr(md, "toc_tokens", None) or []
        p.heading_count = sum(1 for t in toks if t.get("level", 0) >= 2)
        if p.heading_count >= 5:
            p.toc_html = ('<details class="toc"><summary>On this page</summary>%s'
                          "</details>" % render_toc(toks))
    # write article pages ----------------------------------------------------
    count = 0
    for p in page_objs:
        prefix = page_prefix(p.out_dir)
        # 'up' link to directory index
        foot = []
        parent = posixpath.dirname(p.src_rel)
        if parent:
            idx = parent + "/Readme.md"
            if idx in repo.pages:
                up_title = repo.pages[idx].title or "index"
                foot.append('<a class="up" href="%s">↑ %s</a>' %
                            (rel_url(p.out_dir, repo.pages[idx].out_rel),
                             htmlmod.escape(up_title)))
        foot.append('<a class="top" href="#main">Back to top ↑</a>')
        foot.append('<a href="https://github.com/emu-russia/dmgcpu/blob/main/%s" '
                    'target="_blank" rel="noopener noreferrer">Source on GitHub ↗</a>'
                    % p.src_rel)
        art_foot = ('<nav class="article-nav" aria-label="Page footer">%s</nav>'
                    % "".join(foot))
        html = page_chrome(prefix, p.out_rel, p.title, p.desc,
                           breadcrumb_html(prefix, p.out_rel, p),
                           p.toc_html, p.body_html, art_foot)
        out = OUT_DIR / p.out_rel
        out.parent.mkdir(parents=True, exist_ok=True)
        _atomic_write(out, html)
        count += 1
    print("pages: %d written" % count)


def _atomic_write(path, text):
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(text, encoding="utf-8")
    tmp.replace(path)


def build_index():
    """Landing page with hero + tile groups derived from landing.json."""
    import json
    data = json.loads((HERE / "landing.json").read_text(encoding="utf-8"))
    tiles_html = []
    for gi, group in enumerate(data["sections"]):
        cards = []
        for ti, t in enumerate(group["tiles"]):
            src = t["src"]
            page = REPO.pages.get(src)
            if page is None:
                print("  ! landing tile references missing page:", src)
                continue
            title = htmlmod.escape(t.get("title") or page.title or src)
            desc = t.get("text") or page.desc or ""
            desc = htmlmod.escape(desc)
            href = rel_url(".", page.out_rel)
            cards.append("""<a class="tile" href="%s">
  <span class="t-go" aria-hidden="true">→</span>
  <span class="t-head"><span class="t-idx">%s</span><h3>%s</h3></span>
  <p class="t-sub">%s</p>
</a>""" % (href, "%d.%02d" % (gi + 1, ti + 1), title, desc))
        tiles_html.append("""<section class="tile-group" id="%s">
  <div class="gh"><h2><span class="g">%s</span> %s</h2>
  <span class="g-sub">%s</span></div>
  <div class="tile-grid">%s</div>
</section>""" % (group["id"], "§%d" % (gi + 1),
                 htmlmod.escape(group["title"]),
                 htmlmod.escape(group.get("subtitle", "")),
                 "".join(cards)))
    hero = data.get("hero", {})
    html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>%s</title>
<meta name="description" content="%s">
<link rel="icon" href="assets/favicon.svg" type="image/svg+xml">
<link rel="stylesheet" href="assets/site.css">
%s
</head>
<body class="landing">
%s
<main id="main">
<section class="wrap hero">
  <div class="hero-text">
    <p class="hero-eyebrow">%s</p>
    <h1>%s <span class="accent">%s</span></h1>
    <p class="hero-lede">%s</p>
    <div class="hero-actions">
      <a class="btn btn-primary" href="#soc">Explore the SoC</a>
      <a class="btn btn-ghost" href="wiki/soc/Readme.html">SoC overview</a>
      <a class="btn btn-ghost" href="HDL/soc/icarus/Readme.html">Testbenches</a>
    </div>
    <ul class="hero-facts">
      <li><span class="k">die-perfect</span>&nbsp;Verilog netlist</li>
      <li><span class="k">Icarus</span>&nbsp;regression suites on the real netlist</li>
      <li><span class="k">open</span>&nbsp;research, sources in the repo</li>
    </ul>
  </div>
  <figure class="hero-media">
    <img src="imgstore/Nintendo_DMG_CPU_1.jpg"
         alt="Photograph of the Nintendo DMG-CPU die"
         width="1600" height="1200" loading="eager">
    <figcaption>DMG-CPU A — photo by Christian Bassow
      (<a href="https://commons.wikimedia.org/wiki/File:Nintendo_DMG_CPU_1.jpg"
      target="_blank" rel="noopener noreferrer">Wikimedia Commons</a>)</figcaption>
  </figure>
</section>
<section class="wrap landing-sections">
%s
</section>
</main>
%s
<script src="assets/site.js"></script>
</body>
</html>""" % (htmlmod.escape(data.get("site_title", "DMG-CPU Research")),
             htmlmod.escape(data.get("meta_description", "")),
             THEME_INLINE,
             header_html(""),
             htmlmod.escape(hero.get("eyebrow", "")),
             htmlmod.escape(hero.get("title", "DMG-CPU")),
             htmlmod.escape(hero.get("title_accent", "Research")),
             htmlmod.escape(hero.get("lede", "")),
             "".join(tiles_html),
             footer_html(""))
    out = OUT_DIR / "index.html"
    _atomic_write(out, html)
    print("index.html written")


def main():
    ap = argparse.ArgumentParser(description="Build docs/ GitHub Pages site")
    ap.add_argument("--pages-only", action="store_true",
                    help="render pages but skip media optimisation")
    args = ap.parse_args()

    global REPO
    REPO = Repo()

    (OUT_DIR / "assets").mkdir(parents=True, exist_ok=True)
    (OUT_DIR / "imgstore" / "external").mkdir(parents=True, exist_ok=True)
    for name in ("site.css", "site.js", "favicon.svg"):
        shutil.copyfile(STATIC_DIR / name, OUT_DIR / "assets" / name)
    (OUT_DIR / ".nojekyll").write_text("", encoding="utf-8")

    if not args.pages_only:
        copy_media(REPO)
    build_pages()
    build_index()
    print("done. site root: docs/index.html")


if __name__ == "__main__":
    main()
