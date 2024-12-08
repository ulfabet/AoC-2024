# AoC-2024 day 8

import std/strutils
import std/sequtils
import std/tables
import std/math

type
  Coord = tuple
    y, x: int
  Antenna = char

const
  input = "day8.input"
  data = input.readFile.strip
  empty = '.'
  antinode = '#'

var
  m = data.split
  limit = m.len
  antennas = initTable[Antenna, seq[Coord]]()

proc insideBounds(c: Coord): bool =
  if c.y >= 0 and c.x >= 0 and c.y < limit and c.x < limit:
    return true

proc getAntenna(c: Coord): Antenna =
  if c.insideBounds:
    return m[c.y][c.x]
  else:
    return '.'

proc setAntinode(c: Coord) =
  if c.insideBounds:
    m[c.y][c.x] = antinode

proc `+`(a, b: Coord): Coord =
  return (a.y+b.y, a.x+b.x)

proc `-`(a, b: Coord): Coord =
  return (a.y-b.y, a.x-b.x)

proc `*`(a: int, b: Coord): Coord =
  return (a*b.y, a*b.x)

iterator eachPair(s: seq[Coord]): seq[Coord] =
  for i in s.low .. s.high-1:
    for j in i+1 .. s.high:
      yield @[s[i], s[j]]

proc calculateResonantFrequencies(start, stop: int) =
  for a, s in antennas:
    for pair in s.eachPair:
      let d = pair[1] - pair[0]
      for k in start .. stop:
        setAntinode(pair[0] - k * d)
        setAntinode(pair[1] + k * d)

proc buildModel() =
  var cursor: Coord

  proc collectAntennas(c: Coord) =
    let a = c.getAntenna
    if a == empty:
      return
    if antennas.contains(a):
      antennas[a].add(c)
    else:
      antennas[a] = @[c]

  proc advance(c: var Coord, n: int = 1) =
    c.y += (c.x + n) div limit
    c.x = (c.x + n) mod limit

  while cursor.insideBounds:
    cursor.collectAntennas
    cursor.advance

buildModel()

echo "part 1"
calculateResonantFrequencies(1, 1)
echo m.mapIt(it.count(antinode)).sum

echo "part 2"
calculateResonantFrequencies(0, limit)
echo m.mapIt(it.count(antinode)).sum

