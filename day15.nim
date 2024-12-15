# AoC-2024 day 15

import std/sequtils
import std/strutils
import std/tables

type
  Coord = tuple
    x, y: int
  Robot = Coord
  Direction = Coord
  Map = seq[string]

let
  input = "day15.input".readFile
  direction = {'<': (-1,0), '^': (0,-1), '>': (1,0), 'v': (0,1)}.toTable

proc `+`(a, b: Coord): Coord =
  return (a.x+b.x, a.y+b.y)

proc `-`(a, b: Coord): Coord =
  return (a.x-b.x, a.y-b.y)

proc `*`(k: int, a: Coord): Coord =
  return (k*a.x, k*a.y)

proc `[]`(m: Map, c: Coord): char =
  return m[c.y][c.x]

proc `[]=`(m: var Map, c: Coord, ch: char) =
  m[c.y][c.x] = ch

proc findRobot(m: Map): Robot =
  for y, row in m:
    for x, ch in row:
      if ch == '@':
        return (x, y)

proc writeSlice(m: var Map, c: Coord, d: Direction, s: string) =
  for i, ch in s:
    m[c+i*d] = s[i]

proc sumGPS(m: Map, box: char): int =
  for y, row in m:
    for x, ch in row:
      if ch == box:
        result += 100*y + x

proc push(m: var Map, c: Coord, d: Direction, simulate: bool = false): bool =
  proc commit(m: var Map, s: string): bool =
    if not simulate:
      m.writeSlice(c, d, '.' & s[0..^2])
    return true
  var
    n = c + d
    slice = $m[c]
  while true:
    slice &= m[n]
    case m[n]:
      of '#':
        return false
      of '.':
        return m.commit(slice)
      of '[':
        if d.x == 0:
          return m.push(n, d, simulate) and m.push(n+(1,0), d, simulate) and m.commit(slice)
      of ']':
        if d.x == 0:
          return m.push(n, d, simulate) and m.push(n-(1,0), d, simulate) and m.commit(slice)
      else:
        discard
    n = n + d

proc move(m: var Map, r: var Robot, d: Direction) =
  if m.push(r, d, simulate = true) and m.push(r, d):
    r = r + d

proc part1(input: string) =
  let data = input.split("\n\n")
  var
    map = data[0].split
    robot = map.findRobot
  for ch in data[1].strip.split.join():
    map.move(robot, direction[ch])
  echo "part 1: ", map.sumGPS('O')

proc part2(input: string) =
  proc change(ch: char): string =
    case ch:
      of 'O': return "[]"
      of '@': return "@."
      else: return ch&ch
  let data = input.split("\n\n")
  var
    map = data[0].split.mapIt(it.mapIt(it.change).join)
    robot = map.findRobot
  for ch in data[1].strip.split.join():
    map.move(robot, direction[ch])
  echo "part 2: ", map.sumGPS('[')

part1(input)
part2(input)
