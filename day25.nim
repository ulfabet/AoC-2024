# AoC-2024 day 25

import std/strutils
import std/sequtils
import std/sugar

const
  input = "day25.input"

proc transposed(m: seq[string]): seq[string] =
  for r in 0 .. m.high:
    result.add ".".repeat(m.len)
    for c in 0 .. m[0].high:
      result[r][c] = m[c][r]

var
  locks: seq[seq[int]]
  keys: seq[seq[int]]

for s in input.readFile.strip.split("\n\n"):
  let
    m = s.splitLines[1 .. 5]
    a = m.transposed.mapIt(it.count("#"))
  if s[0] == '.':
    keys.add a
  else:
    locks.add a

let overlaps = collect:
  for lock in locks:
    for key in keys:
      zip(lock, key).map((t) => t[0] + t[1]).any((i) => i > 5)

echo "part 1"
echo overlaps.count(false)
