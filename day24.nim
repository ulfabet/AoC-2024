# AoC-2024 day 24
#
# todo - clean up

import std/strutils
import std/strformat
import std/strscans
import std/sequtils
import std/tables
import std/algorithm

const
  input = "day24.input"

type
  Wire = object
    id: string
    input,output: int
    validInput,validOutput: bool
  Gate = object
    op: string
    a,b,c: string
  Wires = Table[string,Wire]
  Gates = Table[string,Gate]

var
  wires: Wires
  gates: Gates

proc getWire(id: string): Wire =
  if id notin wires:
    var wire = Wire(id: id)
    wires[id] = wire
  return wires[id]

proc parseWire(s: string) =
  var wire: Wire
  if s.scanf("$w: $i", wire.id, wire.output):
    wire.validOutput = true
    wires[wire.id] = wire

proc parseGate(s: string) =
  var gate: Gate
  if s.scanf("$w $w $w -> $w", gate.a, gate.op, gate.b, gate.c):
    # todo - change this
    discard gate.a.getWire
    discard gate.b.getWire
    discard gate.c.getWire
    gates[gate.c] = gate

proc update(wires: var Wires) =
  for id in wires.keys:
    if wires[id].validInput:
      wires[id].output = wires[id].input
      wires[id].validOutput = true

var parse = parseWire
for line in input.lines:
  if line == "":
    parse = parseGate
  else:
    line.parse

proc open(gate: Gate) =
  if  wires[gate.a].validOutput and
      wires[gate.b].validOutput:
    wires[gate.c].validInput = true
    case gate.op:
      of "AND": wires[gate.c].input = wires[gate.a].output and wires[gate.b].output
      of "OR":  wires[gate.c].input = wires[gate.a].output or  wires[gate.b].output
      of "XOR": wires[gate.c].input = wires[gate.a].output xor wires[gate.b].output
      else: assert false

var xwires = wires.keys.toSeq.filterIt(it.startsWith("x")).sorted.reversed
var ywires = wires.keys.toSeq.filterIt(it.startsWith("y")).sorted.reversed
var zwires = wires.keys.toSeq.filterIt(it.startsWith("z")).sorted.reversed

proc invalidate(wires: var Wires) =
  for id in wires.keys:
    if id[0] notin ['x', 'y']:
      wires[id].validInput = false
      wires[id].validOutput = false

proc run() =
  wires.invalidate
  while true:
    if zwires.mapIt(wires[it].validInput).allIt(it == true):
      break
    for gate in gates.values:
      gate.open
    wires.update

run()

# --
echo "part 1"
let s = wires.keys.toSeq.filterIt(it.startsWith("z")).sorted.reversed.mapIt(wires[it].output).join
echo fromBin[int](s)

# --
echo "part 2"
var wrongWires: seq[string]

proc isXY(s: string): bool =
  return s[0] in ['x', 'y']

proc isXY(s: string, bit: int): bool =
  return s in [fmt"x{bit:02}", fmt"y{bit:02}"]

proc level3and(g: Gate, bit: int): bool =
  if g.op != "AND":
    echo g.c, " is not an AND output"
    wrongWires.add g.c
    return false
  if g.a.isXY or g.b.isXY:
    if g.a.isXY(bit) and g.b.isXY(bit):
      return true
    else:
      echo g.c, " carry inputs wrong? ", (g.a, g.b)
      return false
  else:
    return true

proc level2or(g: Gate, bit: int): bool =
  if g.op != "OR":
    echo g.c, " is not an OR output"
    return false
  if not level3and(gates[g.a], bit-1):
    return false
  if not level3and(gates[g.b], bit-1):
    return false
  return true

proc level2xor(g: Gate, bit: int): bool =
  if g.op != "XOR":
    echo g.c, " is not an XOR output"
    wrongWires.add g.c
    return false
  if g.a.isXY(bit) and g.b.isXY(bit):
    return true
  echo g.c, " XOR inputs seem wrong"
  wrongWires.add g.c

proc level1(g: Gate, bit: int): bool =
  if g.op != "XOR":
    echo g.c, " is not an XOR output"
    wrongWires.add g.c
    return false
  if g.a.isXY or g.b.isXY:
    echo g.c, " has inputs from x or y"
    return false
  if gates[g.a].op == "OR":
    if (level2or(gates[g.a], bit) and level2xor(gates[g.b], bit)):
      return true
    return false
  if gates[g.b].op == "OR":
    if (level2or(gates[g.b], bit) and level2xor(gates[g.a], bit)):
      return true
    return false
  discard level2xor(gates[g.a], bit)
  discard level2xor(gates[g.b], bit)

for bit in 2 .. xwires.high:
  discard level1(gates[fmt"z{bit:02}"], bit)

echo wrongWires.sorted.join(",")
