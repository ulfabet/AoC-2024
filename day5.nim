# AoC-2024 day 5

import std/strscans
import std/strutils
import std/sequtils
import std/math
import std/algorithm
import std/tables

const input = "day5.input"

let data = input.readFile.split("\n\n")

var 
  rules = initTable[int, seq[int]]()
  updates = data[1].strip.splitLines.mapIt(it.split(",").map(parseInt))

for line in data[0].splitLines:
  var a, b: int
  if scanf(line, "$i|$i", a, b):
    rules[a] = rules.getOrDefault(a) & @[b]

proc compareOrder(x, y: int): int =
  if y in rules.getOrDefault(x):
    return -1
  else:
    return 1

proc middlePageNumber(s: seq[int]): int = s[s.high div 2]

echo "part 1"
echo updates.filterIt(it.isSorted(compareOrder)).map(middlePageNumber).sum

echo "part 2"
echo updates.filterIt(not it.isSorted(compareOrder)).mapIt(it.sorted(compareOrder).middlePageNumber).sum
