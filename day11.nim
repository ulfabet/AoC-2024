# AoC-2024 day 11

import std/strutils
import std/sequtils
import std/tables
import std/math

const
  input = "day11.input"

proc transform(stone: int): seq[int] =
  if stone == 0:
    result.add(1)
  elif ($stone).len mod 2 == 0:
    let a = ($stone).toSeq.distribute(2).mapIt(it.join).map(parseInt)
    result.add a[0]
    result.add a[1]
  else:
    result.add(stone*2024)

proc blink(stones: Table[int, int]): Table[int, int] =
  for stone, count in stones:
    for next in transform(stone):
      result[next] = result.getOrDefault(next) + count

proc solve(times: int): int =
  for line in input.lines:
    var stones = initTable[int, int]()
    for k in line.split.map(parseInt):
      stones[k] = stones.getOrDefault(k) + 1
    for i in 1..times:
      stones = blink(stones)
    return stones.values.toSeq.sum

echo "part 1"
echo solve(25)

echo "part 2"
echo solve(75)
