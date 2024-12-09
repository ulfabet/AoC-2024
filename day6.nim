# AoC-2024 day 6

import std/strutils
import std/sequtils
import std/math
import std/sets

type
  Coord = tuple
    y, x: int

const
  input = "day6.input"
  data = input.readFile.strip
  obstacle = '#'
  visited = 'X'
  empty = '.'

var
  m = data.split
  limit = m.len
  guardPosition: Coord
  guardDirection: Coord = (-1,0)
  obstructions: HashSet[Coord]

proc insideBounds(c: Coord): bool =
  if c.y >= 0 and c.x >= 0 and c.y < limit and c.x < limit:
    return true

proc getChar(c: Coord): char =
  if c.insideBounds:
    return m[c.y][c.x]
  else:
    return '.'

proc setChar(c: Coord, ch: char) =
  if c.insideBounds:
    m[c.y][c.x] = ch

proc `+`(a, b: Coord): Coord =
  return (a.y+b.y, a.x+b.x)

proc `-`(a, b: Coord): Coord =
  return (a.y-b.y, a.x-b.x)

proc rotated(c: Coord): Coord =
  return (c.x, -c.y)

proc findLoop() =
  var
    path: HashSet[(Coord, Coord)]
    obstructionPos = guardPosition + guardDirection
    scoutPos = guardPosition
    scoutDir = guardDirection.rotated

  if getChar(obstructionPos) == visited:
    return
  else:
    setChar(obstructionPos, obstacle)
  
  while scoutPos.insideBounds:
    if getChar(scoutPos) == obstacle:
      scoutPos = scoutPos - scoutDir + scoutDir.rotated
      scoutDir = scoutDir.rotated
      continue
    if (scoutPos, scoutDir) in path:
        obstructions.incl(obstructionPos)
        break
    path.incl((scoutPos, scoutDir))
    scoutPos = scoutPos + scoutDir

  setChar(obstructionPos, empty)
  return

proc findGuard(guard: char): Coord =
  for y, line in m:
    let x = line.find(guard)
    if x != -1:
      return (y,x)
  return (-1,-1)

guardPosition = findGuard('^')

while guardPosition.insideBounds:
  let nextPosition = guardPosition + guardDirection
  if getChar(nextPosition) == obstacle:
    guardDirection = guardDirection.rotated
  else:
    findLoop()
    setChar(guardPosition, visited)
    guardPosition = nextPosition

echo "part 1"
echo m.mapIt(it.count(visited)).sum

echo "part 2"
echo obstructions.len
