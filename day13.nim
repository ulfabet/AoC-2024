# AoC-2024 day 13

import std/strscans
import std/sequtils
import std/tables
import std/math

const
  input = "day13.input"

type
  Coord = tuple
    x, y: int64
  Button = Coord
  Prize = Coord
  Machine = tuple
    buttons: Table[char, Button]
    prize: Prize

var machines: seq[Machine]
var m: Machine

proc parse(s: string) =
  var
    id: char
    x, y: int
  if s.scanf("Button $c: X+$i, Y+$i", id, x, y):
    var a,b: int64
    m.buttons[id] = (a,b)
    m.buttons[id].x = x
    m.buttons[id].y = y
  if s.scanf("Prize: X=$i, Y=$i", x, y):
    m.prize.x = x
    m.prize.y = y
    machines.add(m)

for line in input.lines:
  parse(line)

proc `*`(a, b: Coord): Coord =
  return (a.x*b.x, a.y*b.y)

proc tokens(m: Machine): int64 =
  let
    mp = m.prize
    ma = m.buttons['A']
    mb = m.buttons['B']
    scale = (lcm(ma.x, ma.y) div ma.x, lcm(ma.x, ma.y) div ma.y)
    mbs = mb * scale
    ps = mp * scale
    b = (ps.x - ps.y) div (mbs.x - mbs.y)
    a = (mp.y - b * mb.y) div ma.y
  if (a*ma.x + b*mb.x, a*ma.y + b*mb.y) == mp:
    result = 3*a+b

echo "part 1"
echo machines.map(tokens).sum

echo "part 2"
for i, m in machines:
  machines[i].prize = (m.prize.x + 10000000000000, m.prize.y + 10000000000000)
echo machines.map(tokens).sum
