# AoC-2024 day 23

import std/strutils
import std/sequtils
import std/sets
import std/tables
import std/algorithm

const
  input = "day23.input"

var connections = initTable[string, HashSet[string]]()

proc connect(a,b: string) =
  try:
    connections[a].incl(b)
  except KeyError:
    connections[a] = [b].toHashSet
  try:
    connections[b].incl(a)
  except KeyError:
    connections[b] = [a].toHashSet

for line in input.lines:
  let computer = line.split("-")
  connect(computer[0], computer[1])

proc part1() =
  echo "part 1"
  var lans: HashSet[HashSet[string]]
  for a,ac in connections:
    for b in ac:
      for c in connections[b]:
        if a in connections[c]:
          if [a,b,c].toHashSet.mapIt(it.startsWith("t")).foldl(a or b):
            lans.incl [a,b,c].toHashSet
  echo lans.len

part1()

# -- part 2

type 
  Computer = string
  Lan = HashSet[Computer]
  Lans = HashSet[Lan]

proc isConnected(a, b: Computer): bool =
  return a in connections[b]
  
proc findLans(a: Computer): Lans =
  result.incl [a].toHashSet
  for b in connections[a]:
    var newlans: Lans
    for lan in result:
      var disconnect: bool
      for c in lan:
        if isConnected(c, b):
          continue
        else:
          disconnect = true
      if disconnect:
        var newlan = lan * connections[b]
        newlan.incl b
        newlans.incl newlan
        newlans.incl lan
      else:
        var newlan = lan
        newlan.incl b
        newlans.incl newlan
    result = newlans

proc longest(lans: Lans): Lan =
  var length: int
  for lan in lans:
    if lan.len > length:
      length = lan.len
      result = lan

proc part2() =
  echo "part 2"
  var lans: Lans
  for c in connections.keys:
    lans.incl findLans(c).longest
  echo lans.longest.toSeq.sorted.join(",")

part2()
