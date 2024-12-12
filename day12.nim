# AoC-2024 day 12

import std/strutils
import std/sets

type
  Coord = tuple
    y, x: int
  Direction = Coord
  Coords = HashSet[Coord]
  Perimeter = HashSet[(Coord, Direction)]

const
  input = "day12.input"
  data = input.readFile.strip

var
  m = data.split
  limit = m.len

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

proc mapRegions(start: Coord) =
  var unknown: Coords
  var regions: Coords
  var part1, part2: int

  proc getRegionFromCoord(c: Coord): Coords =
    var next: Coords
    var perimeter: Perimeter
    next.incl(c)
    while next.len > 0:
      let current = next
      next = HashSet[Coord]()
      for c in current:
        unknown.excl(c)
        regions.incl(c)
        result.incl(c)
        for n in cross(c):
          if getChar(n) == getChar(c):
            if n notin result:
              next.incl(n)
          else:
            perimeter.incl((n,n-c))
            if n.insideBounds and n notin regions:
              unknown.incl(n)

    proc numberOfSides(p: var Perimeter): int =
      proc removeNeighbours(p: var Perimeter, c: Coord, d: Direction) =
        for n in c.cross:
          if (n, d) in p:
            p.excl((n, d))
            p.removeNeighbours(n, d)
      while p.len > 0:
        result += 1
        let (c, d) = p.pop
        p.removeNeighbours(c, d)

    part1 += result.len * perimeter.len
    part2 += result.len * perimeter.numberOfSides

  unknown.incl(start)
  while unknown.len > 0:
    discard getRegionFromCoord(unknown.pop)

  echo "part 1"
  echo part1
  echo "part 2"
  echo part2

mapRegions((0,0))
