# AoC-2024 day 16
# todo:
# - refactor to reduce duplicate code in part1 and part2
# - improve backtracking?

import std/sequtils
import std/strutils
import std/sets
import std/tables
import std/heapqueue

type
  Coord = tuple
    x, y: int
  Direction = Coord
  Map = seq[string]
  Node = tuple
    coord: Coord
    direction: Direction
  Element = object
    node: Node
    distance: int

let
  input = "day16.input".readFile
  east = (1,0)
  west = (-1,0)
  north = (0,-1)
  south = (0,1)

proc `+`(a, b: Coord): Coord =
  return (a.x+b.x, a.y+b.y)

proc `-`(a, b: Coord): Coord =
  return (a.x-b.x, a.y-b.y)

proc `[]`(m: Map, c: Coord): char =
  if c.x < 0 or c.x > m[0].high or c.y < 0 or c.y > m.high:
    return '#'
  else:
    return m[c.y][c.x]

proc `[]=`(m: var Map, c: Coord, ch: char) =
  m[c.y][c.x] = ch

proc `<`(a, b: Element): bool = a.distance < b.distance

proc find(m: Map, target: char): Coord =
  for y, row in m:
    for x, ch in row:
      if ch == target:
        return (x, y)

proc cross(c: Coord): seq[Coord] =
  [east, west, north, south].mapIt(c + it)

var predecessors = initTable[Coord, HashSet[(Coord, int)]]()

proc dijkstra(m: Map, start: Node): Table[Node, int] =
  # with distance 1 on straights and distance 1000 on corners

  var distances = initTable[Node, int]()
  var visited: HashSet[Node]
  var queue = initHeapQueue[Element]()

  distances[start] = 0
  queue.push(Element(node: start))
  
  while queue.len > 0:
    let
      element = queue.pop
      current = element.node

    if current in visited:
      continue
    visited.incl(current)
    for neighbour in cross(current.coord).filterIt(m[it] != '#'):
      var tentative = distances[current] + 1
      let
        direction = neighbour - current.coord 
        n = (neighbour, direction)
        d = distances.getOrDefault(n)
      if direction != current.direction:
        tentative += 1000
      if tentative < d or d == 0:
        distances[n] = tentative
        # there must be a cleaner way to do this
        try:
          predecessors[neighbour].incl((current.coord, tentative))
        except KeyError:
          predecessors[neighbour] = [(current.coord, tentative)].toHashSet

      queue.push(Element(node: n, distance: tentative))

  return distances

iterator scores(distances: Table[Node, int], target: Coord): int =
  for n,d in distances:
    if n.coord == target:
      yield d

proc part1(input: string) =
  var
    maze = input.strip.split
    start = (maze.find('S'), east)

  echo "part 1"
  echo maze.dijkstra(start).scores(maze.find('E')).toSeq.min

proc part2(input: string) =
  var
    maze = input.strip.split
    start = (maze.find('S'), east)
    distances = maze.dijkstra(start)
    score = distances.scores(maze.find('E')).toSeq.min

  proc count(m: Map, ch: char): int =
    for row in m:
      result += row.count(ch)
        
  proc backtrack(c: Coord, distance: int) =
    for (p, d) in predecessors[c]:
      if d == distance:
        maze[c] = 'O'
        backtrack(p, d-1)
        backtrack(p, d-1001)

  backtrack(maze.find('E'), score)
  echo "part 2"
  echo maze.count('O')+1

part1(input)
part2(input)
