# AoC-2024 day 20

import std/sequtils
import std/strutils
import std/sets
import std/tables
import std/heapqueue

const
  input = "day20.input"

type
  Coord = tuple
    x, y: int
  Node = Coord
  Element = object
    node: Node
    distance: int
  Distances = Table[Node, int]
  Map = seq[string]

proc `+`(a, b: Coord): Coord =
  return (a.x+b.x, a.y+b.y)

proc `-`(a, b: Coord): Coord =
  return (a.x-b.x, a.y-b.y)

proc `[]`(m: Map, c: Coord): char =
  if c.x < 0 or c.x > m[0].high or c.y < 0 or c.y > m.high:
    return '#'
  else:
    return m[c.y][c.x]

proc `<`(a, b: Element): bool = a.distance < b.distance

proc find(m: Map, target: char): Coord =
  for y, row in m:
    for x, ch in row:
      if ch == target:
        return (x, y)

proc cross(c: Coord): seq[Coord] =
  [(1,0), (-1,0), (0,-1), (0,1)].mapIt(c + it)

proc diamond(c: Coord, r = 1): seq[Coord] =
  for y in -r .. r:
    for x in -(r-abs(y)) .. r-abs(y):
      result.add(c+(x,y))

var prev: Table[Coord, Coord]

proc dijkstra(m: Map, start: Node): Distances =
  var visited: HashSet[Node]
  var queue: HeapQueue[Element]
  result[start] = 0
  queue.push(Element(node: start))
  while queue.len > 0:
    let current = queue.pop.node
    if current notin visited:
      visited.incl(current)
      for next in cross(current).filterIt(m[it] != '#'):
        let tentative = result[current] + 1
        if next notin result or tentative < result[next]:
          result[next] = tentative
          prev[next] = current
        queue.push(Element(node: next, distance: tentative))

proc len(c: Coord): int =
  return abs(c.x) + abs(c.y)

proc solve(radius: int): int =
  let
    m = input.readFile.strip.splitLines
    start = m.find('S')
    finish = m.find('E')
    distances = dijkstra(m, start)

  var c = finish
  while c != start:
    for d in c.diamond(radius):
      if m[d] == '#':
        continue
      let shortcut = d - c
      if distances[c] - shortcut.len - distances[d] >= 100:
        result += 1
    c = prev[c]

echo "part 1\n", solve(2)
echo "part 1\n", solve(20)
