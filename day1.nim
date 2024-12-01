# AoC-2024 day 1

import std/strutils
import std/sequtils
import std/math
import std/algorithm

const input = "day1.example"

func parseLine(s: string): tuple =
  let i = s.splitWhitespace.map(parseInt)
  (i[0], i[1])

func diff(x: tuple): int =
  abs x[0]-x[1]

let (left, right) = input.readFile.strip.splitLines.map(parseLine).unzip

echo "part 1"
echo zip(left.sorted, right.sorted).map(diff).sum

echo "part 2"
echo left.mapIt(it * right.count(it)).sum
