# AoC-2024 day 4

import std/strutils
import std/sequtils

const input = "day4.input"

type
  Coord = tuple
    y, x: int
  Matrix = object
    data: seq[string]

let
  m = Matrix(data : input.lines.toSeq)
  limit = m.data.len

proc charFromCoord(self: Matrix, c: Coord): char =
  try:
    self.data[c.y][c.x]
  except IndexDefect:
    '.'

proc stringFromCoords(self: Matrix, coords: seq[Coord]): string =
  coords.mapIt(self.charFromCoord(it)).join

proc advance(c: var Coord, n: int = 1) =
  c.y += (c.x + n) div limit
  c.x = (c.x + n) mod limit

proc sum(a,b: Coord): Coord =
  (a.y+b.y, a.x+b.x)

proc search(word: string, locations: seq[seq[Coord]]): int =
  var cursor: Coord
  while cursor.y <= limit:
    for coords in locations:
      if word == m.stringFromCoords(coords.mapIt(sum(cursor, it))):
        result += 1
    advance(cursor)

# --
echo "part 1"

let
  part1 = @[
    @[(0,0), (0,1), (0,2), (0,3)], # right
    @[(0,0), (0,-1), (0,-2), (0,-3)], # left
    @[(0,0), (1,0), (2,0), (3,0)], # down
    @[(0,0), (-1,0), (-2,0), (-3,0)], # up
    @[(0,0), (1,1), (2,2), (3,3)], # right, down
    @[(0,0), (-1,1), (-2,2), (-3,3)], # right, up
    @[(0,0), (1,-1), (2,-2), (3,-3)], # left, down
    @[(0,0), (-1,-1), (-2,-2), (-3,-3)] # left, up
  ]

echo search("XMAS", part1)

# --
echo "part 2"

let
  part2= @[
    @[(0,0), (0,2), (1,1), (2,0), (2, 2)], # MSAMS
    @[(0,0), (2,0), (1,1), (0,2), (2, 2)], # MMASS
    @[(0,2), (0,0), (1,1), (2,2), (2, 0)], # SMASM
    @[(2,0), (0,0), (1,1), (2,2), (0, 2)]  # SSAMM
  ]

echo search("MSAMS", part2)
