# AoC-2024 day 19

import std/strutils
import std/sequtils
import std/tables
import std/math

const
  input = "day19.input"

type
  Towel = string
  Design = string

let
  data = input.readFile.strip.split("\n\n")
  towels = data[0].split(", ")
  designs = data[1].splitLines

var cache = initTable[Design, int]()

proc arrange(design: Design, towels: seq[Towel]): int =
  if design in cache:
    return cache[design]
  if design.len == 0:
    return 1
  for towel in towels:
    if design.startsWith(towel):
      let n = arrange(design[towel.len .. ^1], towels)
      cache.mgetOrPut(design, 0).inc(n)
  return cache.mgetOrPut(design, 0)

let arrangements = designs.mapIt(it.arrange(towels))

echo "part 1"
echo designs.len - arrangements.count(0)

echo "part 2"
echo arrangements.sum
