"""Generate a GTKWave v3.3.128 .gtkw save file from a VCD (issue #390).

Usage: python3 mk_gtkw.py <in.vcd> <out.gtkw> [--signals name1 name2 ...]
Reads the real $scope tree from the VCD, resolves each requested signal to its
id/width (vector names keep their [msb:lsb] suffix), then writes a v3.3.128
save file: @201 group headers, @22/@28 trace lines, ending with the
[pattern_trace] footer that 3.3.128 emits.
"""
import re, sys

def parse_vcd(path):
    src = open(path, newline='').read().split('$enddefinitions', 1)[0]
    scopes = []
    tree = {}
    for ln in src.splitlines():
        ln = ln.strip('\r')
        if ln.startswith('$scope'):
            scopes.append(ln.split()[2])
        elif ln.startswith('$upscope'):
            scopes.pop()
        elif ln.startswith('$var'):
            p = ln.split()
            # $var <type> <width> <id> <name> [range] $end
            width = int(p[2]); name = p[4]
            rng = p[5] if len(p) > 5 and p[5] != '$end' else None
            path = '.'.join(scopes + [name])
            if rng:
                path = path + rng if rng.startswith('[') else path
            tree[path] = width
    return tree

def main():
    args = [a for a in sys.argv[1:]]
    vcd, out = args[0], args[1]
    sigs = []
    if '--signals' in args:
        i = args.index('--signals')
        sigs = args[i+1:]
    tree = parse_vcd(vcd)
    if not sigs:
        sigs = list(tree.keys())
    missing = [s for s in sigs if s not in tree]
    if missing:
        print('WARNING missing:', missing, file=sys.stderr)
    with open(out, 'w', newline='\n') as f:
        f.write('[*]\n[*] GTKWave Analyzer v3.3.128 (w)1999-2026 BSI\n[*]\n')
        f.write('[*] generated for HDL/sm83/Icarus (issue #400)\n[*]\n')
        f.write('[dumpfile] "%s"\n' % out.replace('.gtkw','.vcd').replace('\\','\\\\'))
        f.write('[timestart] 0\n[size] 1920 1000\n[pos] -1 -1\n')
        f.write('*-0.000000 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1\n')
        f.write('[treeopen] %s\n' % sigs[0].split('.')[0])
        f.write('[sst_width] 250\n[signals_width] 200\n[sst_expanded] 1\n[sst_vpaned_height] 400\n')
        cur_group = None
        for s in sigs:
            w = tree.get(s, 1)
            f.write('@22\n%s\n' % s if w > 1 else '@28\n%s\n' % s)
        f.write('[pattern_trace] 1\n[pattern_trace] 0\n')
    print('wrote', out, 'signals:', len([s for s in sigs if s in tree]))

if __name__ == '__main__':
    main()
