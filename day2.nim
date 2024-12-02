# AoC-2024 day 2

import std/strutils
import std/sequtils
import std/algorithm

const input = "day2.input".readFile

iterator diff(x: seq[int]): int =
  for i in x.low .. x.high-1:
    yield abs x[i]-x[i+1]

func isSafe(report: seq[int]): bool =
  if report.isSorted(Ascending) or report.isSorted(Descending):
    for i in report.diff:
      if i notin 1 .. 3:
        return false
    return true

func isAlmostSafe(report: seq[int]): bool =
  for i in report.low .. report.high:
    var dampened = report
    dampened.delete(i)
    if dampened.isSafe:
      return true

func parseReport(s: string): seq[int] =
  s.splitWhitespace.map(parseInt)

let reports = input.strip.splitLines.map(parseReport)

echo "part 1"
echo reports.map(isSafe).count(true)

echo "part 2"
echo reports.map(isAlmostSafe).count(true)
