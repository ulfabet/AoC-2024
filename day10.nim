# AoC-2024 day 10

import std/strutils
import std/sequtils
import std/math

type
  Coord = tuple
    y, x: int

const
  input = "day10.input"
  data = input.readFile.strip
  trailhead = '0'
  goal = '9'

var
  m = data.split
  limit = m.len

iterator allTrailheads(): Coord =
  for y,row in m:
    for x,c in row:
      if c == trailhead:
        yield (y,x)

proc `+`(a, b: Coord): Coord =
  return (a.y+b.y, a.x+b.x)

proc `-`(a, b: Coord): Coord =
  return (a.y-b.y, a.x-b.x)

proc insideBounds(c: Coord): bool =
  if c.y >= 0 and c.x >= 0 and c.y < limit and c.x < limit:
    return true

proc cross(c: Coord): seq[Coord] =
  result.add c-(1,0)
  result.add c+(1,0)
  result.add c-(0,1)
  result.add c+(0,1)

proc getChar(c: Coord): char =
  if c.insideBounds:
    return m[c.y][c.x]
  else:
    return '.'

proc findTrails(c: Coord): int =
  var next = @[c]
  var goals: seq[Coord]
  while next.len > 0:
    let current = next
    next = @[]
    for c in current:
      if getChar(c) == goal:
        if c notin goals:
          goals.add(c)
        continue
      for n in cross(c):
        if getChar(n).ord == getChar(c).ord+1:
          if n notin next:
            next.add(n)
  return goals.len

echo "part 1"
echo allTrailheads.toSeq.map(findTrails).sum

proc findRating(c: Coord): int =
  var next = @[c]
  while next.len > 0:
    let current = next
    next = @[]
    for c in current:
      if getChar(c) == goal:
        result += 1
        continue
      for n in cross(c):
        if getChar(n).ord == getChar(c).ord+1:
          next.add(n)

echo "part 2"
echo allTrailheads.toSeq.map(findRating).sum
