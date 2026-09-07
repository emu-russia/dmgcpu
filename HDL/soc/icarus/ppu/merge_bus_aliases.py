"""Merge bidirectional-bus alias assigns into real net aliases for Icarus.

For every `assign <bus>[<i>] = wNNN;` where <bus> is an inout bus port
(d/md/nma/n_oama/n_oamb) the internal wire wNNN is renamed to <bus>[<i>]
throughout the module and the assign + the now-redundant wire declaration
are removed.  Output-port aliases (n_ma, ppu_wr etc.) and input aliases are
left untouched (they are true one-way drivers and elaborate fine).
"""
import re, sys

def merge(path, out):
    src = open(path).read()
    aliases = []
    pat = re.compile(r'^\s*assign\s+(\w+)\s*\[\s*(\d+)\s*\]\s*=\s*(w\d+)\s*;', re.M)
    for m in pat.finditer(src):
        bus, i, w = m.group(1), m.group(2), m.group(3)
        if bus in ('d', 'md', 'nma', 'n_oama', 'n_oamb'):
            aliases.append((w, '%s[%s]' % (bus, i)))
    if not aliases:
        print(path, ': nothing to merge')
        return
    # remove the alias assign lines for those buses
    src = re.sub(r'^\s*assign\s+(?:d|md|nma|n_oama|n_oamb)\s*\[\s*\d+\s*\]\s*=\s*w\d+\s*;\s*\n', '', src, flags=re.M)
    # remove redundant single-wire declarations for renamed nets
    for w, _ in aliases:
        src = re.sub(r'^\s*wire\s+' + w + r'\s*;\s*\n', '', src, flags=re.M)
    # rename
    for w, rep in aliases:
        src = re.sub(r'\b' + w + r'\b', rep, src)
    open(out, 'w').write(src)
    print(path, '->', out, 'merged', len(aliases), 'aliases')

if __name__ == '__main__':
    merge(sys.argv[1], sys.argv[2])
