#!/usr/bin/env python3
# gen_weakbus.py - generate ppu2_weakbus.v from ppu2_merged.v
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
# Bus modelling only - HDL/soc/ppu2.v is NOT modified.
#
# Usage: python3 gen_weakbus.py   (run in this directory)

import re

SRC = "ppu2_merged.v"
DST = "ppu2_weakbus.v"

# the 24 notif0 cells whose output hangs on one of the six oa-chain nodes
CELLS = ("g416 g419 g421 g468 "
         "g360 g362 g418 g472 "
         "g357 g368 g370 g471 "
         "g371 g459 g473 g474 "
         "g352 g356 g462 g463 "
         "g353 g461 g464 g475").split()
NODES = ("w497", "w146", "w500", "w554", "w641", "w49")

t = open(SRC).read()
n = 0
for c in CELLS:
    t, k = re.subn(r"dmg_notif0 " + c + r" \(", "dmg_notif0_od " + c + " (", t)
    n += k
if n != len(CELLS):
    raise SystemExit("expected %d renames, got %d" % (len(CELLS), n))
for w in NODES:
    t, k = re.subn(r"(wire " + w + r";)", r"\1\n\tpullup (" + w + ");", t)
    n += k
if n != len(CELLS) + len(NODES):
    raise SystemExit("unexpected pullup count")
open(DST, "w").write(t)
print("wrote %s (%d transforms)" % (DST, n))
