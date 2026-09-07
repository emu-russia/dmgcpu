#!/usr/bin/env python3
# gen_weakbus.py - generate weak/discharge-only oa-bus variants from
# ppu2_merged.v
#
# Applies the "weak / discharge-only" bus model (issue #390, round 27) to the
# six oa-chain inverse-hold nodes of PPU2:
#   w497/w146/w500/w554/w641/w49   (each driven by 4 notif0 mux groups,
#   scan w518 / port-B w475 / CPU w403 / store w444 / idle w48)
#   1. the notif0 drivers of these nodes are renamed to dmg_notif0_od
#      (open-drain: pull low only when enabled AND data==1; see
#      bus_weak_cells.v);
#   2. a pullup() keeper is added to each node so the precharge level (1)
#      is held between/overlapping drives.
# The oa NOT gates (g68-g73) and everything downstream are unchanged.
#
# Two outputs:
#   ppu2_weakbus.v  - all six groups weak (round 27 default). Static
#                     overlap of the mode-2 scan group with the port-B
#                     const / CPU / store groups still corrupts the scan
#                     address low bits (round 29).
#   ppu2_m2only.v   - additionally, the 18 NON-scan oa-chain drivers are
#                     disabled while ppu_mode2 is high (n_ena = orig |
#                     ppu_mode2), so during the mode-2 scan ONLY the scan
#                     group w518 drives (stable even words {2,4,..,78});
#                     in mode 3 the store re-read (w444) etc. work again
#                     (round 30: sprite pixels reach LD0/LD1 under this).
# Bus modelling only - HDL/soc/ppu2.v is NOT modified.
#
# Usage: python3 gen_weakbus.py   (run in this directory)

import re

SRC = "ppu2_merged.v"

# the 24 notif0 cells whose output hangs on one of the six oa-chain nodes
CELLS = ("g416 g419 g421 g468 "
         "g360 g362 g418 g472 "
         "g357 g368 g370 g471 "
         "g371 g459 g473 g474 "
         "g352 g356 g462 g463 "
         "g353 g461 g464 g475").split()
# the mode-2 scan group cells (enable w518) - kept active during mode 2
SCAN = {"g419", "g360", "g368", "g371", "g463", "g464"}
NODES = ("w497", "w146", "w500", "w554", "w641", "w49")
M2NET = "w3"   # internal net of ppu_mode2 (ppu2.v: assign ppu_mode2 = w3)


def transform(t, non_scan_mode2_gate):
    n = 0
    for c in CELLS:
        t, k = re.subn(r"dmg_notif0 " + c + r" \(", "dmg_notif0_od " + c + " (", t)
        n += k
    if n != len(CELLS):
        raise SystemExit("expected %d renames, got %d" % (len(CELLS), n))
    if non_scan_mode2_gate:
        for c in CELLS:
            if c in SCAN:
                continue
            t, k = re.subn(
                r"(dmg_notif0_od " + c + r" \(\s*\.n_ena\(\s*)(\w+)(\s*\))",
                r"\1(\2 | " + M2NET + r")\3", t)
            if k != 1:
                raise SystemExit("failed to gate %s" % c)
            n += 1
    for w in NODES:
        t, k = re.subn(r"(wire " + w + r";)", r"\1\n\tpullup (" + w + ");", t)
        n += k
    return t, n


base = open(SRC).read()

t, n = transform(base, False)
open("ppu2_weakbus.v", "w").write(t)
print("wrote ppu2_weakbus.v (%d transforms)" % n)

t, n = transform(base, True)
open("ppu2_m2only.v", "w").write(t)
print("wrote ppu2_m2only.v (%d transforms)" % n)
