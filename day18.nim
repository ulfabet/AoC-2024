# AoC-2024 day 18

import std/sequtils
import std/strscans
import std/sets
import std/tables
import std/heapqueue

type
  Coord = tuple[x, y: int]
  Node = Coord
  Element = object
    node: Node
    distance: int
  Distances = Table[Node, int]

let
  input = "day18.input"
  limit = 70
  start = (0,0)

var bytes: seq[Coord]
var bytelimit: int

for line in input.lines:
  var c: Coord
  if line.scanf("$i,$i", c.x, c.y):
    bytes.add(c)

proc `+`(a, b: Coord): Coord =
  return (a.x+b.x, a.y+b.y)

proc `<`(a, b: Element): bool = a.distance < b.distance

proc readMemory(c: Coord): char =
  if c in bytes[0..<bytelimit] or c.x < 0 or c.x > limit or c.y < 0 or c.y > limit:
    return '#'
  else:
    return '.'

proc cross(c: Coord): seq[Coord] =
  [(1,0), (-1,0), (0,1), (0,-1)].mapIt(c + it)

proc dijkstra(start: Node): Distances =

  var visited: HashSet[Node]
  var queue = initHeapQueue[Element]()

  result[start] = 0
  queue.push(Element(node: start))
  
  while queue.len > 0:
    let current = queue.pop.node
    if current notin visited:
      visited.incl(current)
      for next in cross(current).filterIt(it.readMemory != '#'):
        var tentative = result[current] + 1
        if next notin result or tentative < result[next]:
          result[next] = tentative
        queue.push(Element(node: next, distance: tentative))

proc part1() =
  echo "part 1"
  bytelimit = 1024
  echo dijkstra(start)[(limit,limit)]

proc part2() =
  echo "part 2"
  var
    lo = bytes.low
    hi = bytes.high
    curr = (hi-lo) div 2
  while true:
    bytelimit = curr
    let ds = dijkstra(start)
    if (limit,limit) in ds:
      lo = curr
      curr += (hi-curr) div 2
    else:
      hi = curr
      curr -= (curr-lo) div 2
    if curr == lo:
      echo bytes[curr]
      break

part1()
part2()
