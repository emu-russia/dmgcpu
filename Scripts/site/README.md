# docs/ site generator (issue #402)

Builds the static GitHub-Pages site in `docs/` from the repository
markdown (root `Readme.md`, `wiki/`, `HDL/`, `netlist/`, `logisim/`) plus
the images those files reference.

Output layout (mirrors the repo under `docs/`, all URLs relative so the
site works from `file://` and from GitHub Pages under any base path):

    docs/index.html            landing page with tiles
    docs/Readme.html           the root Readme
    docs/wiki/...html          wiki pages
    docs/HDL/...html           HDL / testbench pages
    docs/imgstore/...          site copies of referenced images
    docs/assets/site.{css,js}  theme + styling
    docs/.nojekyll

Notes:

* `.md` links are rewritten to the generated `.html` pages; image links are
  rewritten to the copies under `docs/imgstore` (repo-root-absolute and
  relative references both work).
* Referenced images are copied as **optimised web copies** (longest side
  capped at 3200 px, JPEG q86 / PNG optimised) so the site stays small;
  the full-resolution originals stay in the repository.
* Images that only live on the web (GitHub user-attachments, used by
  `wiki/soc/sch/bank.md`) are vendored under `media_remote/` and copied to
  `docs/imgstore/external/` so the page works offline too.
* Light/dark theme toggle is pure CSS + a small inline script, persisted in
  `localStorage` (`dmgcpu-theme`) and defaulting to `prefers-color-scheme`.

## Usage

    python3 -m pip install --target .deps -r requirements.txt
    PYTHONPATH=.deps python3 build_site.py            # pages + media
    PYTHONPATH=.deps python3 build_site.py --pages-only

Re-running the build is idempotent: already-copied media and unchanged
pages are not rewritten (no spurious diffs).
