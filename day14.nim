# AoC-2024 day 14

import std/strutils
import std/sequtils
import std/strscans
import std/math

type
  Coord = tuple
    x, y: int
  Robot = tuple
    position, velocity: Coord

const
  input = "day14.input"
  cols = 101
  rows = 103

proc `+`(a, b: Coord): Coord =
  return (a.x+b.x, a.y+b.y)

proc `mod`(a, b: Coord): Coord =
  (a.x mod b.x, a.y mod b.y)

proc move(robots: var seq[Robot]) =
  for i,r in robots:
    robots[i].position = ((cols, rows) + r.position + r.velocity) mod (cols, rows)

proc safetyFactor(robots: seq[Robot]): int =
  var q: array[4, int]
  for r in robots:
    if r.position.x < cols div 2:
      if r.position.y < rows div 2: q[0].inc
      if r.position.y > rows div 2: q[1].inc
    if r.position.x > cols div 2:
      if r.position.y < rows div 2: q[2].inc
      if r.position.y > rows div 2: q[3].inc
  return q.prod

proc isChristmasTree(robots: seq[Robot]): bool =
  var row = repeat(".", cols)
  var m = sequtils.repeat(row, rows)
  for r in robots:
    m[r.position.y][r.position.x] = 'O'
  for row in m:
    if row.find(repeat("O", 10)) >= 0:
      return true

proc parse(s: string): Robot =
  var x, y, dx, dy: int
  if s.scanf("p=$i,$i v=$i,$i", x, y, dx, dy):
    result.position = (x, y)
    result.velocity = (dx, dy)

var robots = input.lines.toSeq.map(parse)

for i in 1..rows*cols:
  robots.move
  if i == 100:
    echo "part 1"
    echo robots.safetyFactor
  if robots.isChristmasTree:
    echo "part 2"
    echo i
