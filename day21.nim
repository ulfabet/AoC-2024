# AoC-2024 day 21

import std/strutils
import std/sequtils
import std/tables
import std/algorithm

const
  input = "day21.input"

type
  Coord = tuple[x, y: int]
  Button = char

let
  dirsymbols = { (-1,0):'<', (1,0):'>', (0,-1):'v', (0,1):'^' }.toTable
  dircoords =  { '<':(-1,0), '>':(1,0), 'v':(0,-1), '^':(0,1), 'A':(0,0) }.toTable

proc `+`(a, b: Coord): Coord =
  return (a.x+b.x, a.y+b.y)

proc `-`(a, b: Coord): Coord =
  return (a.x-b.x, a.y-b.y)

type
  KeyPad = object
    cursor: Coord
    buttons: Table[Button, Coord]

var kn: KeyPad
kn.cursor = (2,0)
kn.buttons = {'7':(0,3), '8':(1,3), '9':(2,3),
              '4':(0,2), '5':(1,2), '6':(2,2),
              '1':(0,1), '2':(1,1), '3':(2,1),
              ' ':(0,0), '0':(1,0), 'A':(2,0)}.toTable

var kd: KeyPad
kd.cursor = (2,1)
kd.buttons = {' ':(0,1), '^':(1,1), 'A':(2,1),
              '<':(0,0), 'v':(1,0), '>':(2,0)}.toTable

proc possibleMoves(k: var Keypad, b: Button): seq[string] =
  let
    coord = k.buttons[b]
    d = coord - k.cursor
  var move: string
  if d.x != 0:
    move &= dirsymbols[(d.x div abs(d.x), 0)].repeat(abs(d.x))
  if d.y != 0:
    move &= dirsymbols[(0, d.y div abs(d.y))].repeat(abs(d.y))
  move.sort
  result.add move & "A"
  while move.nextPermutation:
    result.add move & "A"

  # avoid moving through empty space
  proc isValid(k: Keypad, moves: string): bool =
    var cur = k.cursor
    var coords: seq[Coord]
    for move in moves:
      cur = cur + dircoords[move]
      coords.add cur
    return k.buttons[' '] notin coords

  result = result.filterIt(k.isValid it)
  k.cursor = coord

proc press(k: var Keypad, b: Button): string =
  # todo - use a prebuilt table of moves
  if k.cursor == k.buttons['A']:
      let moves = { 'A':"A", '^':"<A", '>':"vA", 'v':"<vA", '<':"v<<A" }.toTable
      result = moves[b]
  if k.cursor == k.buttons['^']:
      let moves = { 'A':">A", '^':"A", '>':"v>A", 'v':"vA", '<':"v<A" }.toTable
      result = moves[b]
  if k.cursor == k.buttons['>']:
      let moves = { 'A':"^A", '^':"<^A", '>':"A", 'v':"<A", '<':"<<A" }.toTable
      result = moves[b]
  if k.cursor == k.buttons['v']:
      let moves = { 'A':"^>A", '^':"^A", '>':">A", 'v':"A", '<':"<A" }.toTable
      result = moves[b]
  if k.cursor == k.buttons['<']:
      let moves = { 'A':">>^A", '^':">^A", '>':">>A", 'v':">A", '<':"A" }.toTable
      result = moves[b]
  k.cursor = k.buttons[b]

var
  nextmove: Table[string, string]
  movecount: Table[string, int]

proc simulate(kps: var seq[KeyPad], s: string): string =
  if kps.len == 0:
    return s
  var
    keypads = kps[1..^1]
    keypad = kps[0]
    buttons = s.mapIt(keypad.press it).join
  return keypads.simulate(buttons)

proc splitA(s: string): seq[string] =
  s.split("A").mapIt(it&"A")[0..^2]

proc recurse(kps: var seq[KeyPad]): int =
  if kps.len == 0:
    for k,v in movecount:
      result += k.len * v
    return
  var
    keypads = kps[1..^1]
    keypad = kps[0]
  var movecountcopy = movecount
  movecount.clear
  for moves,count in movecountcopy:
    if count == 0:
      continue
    var next: string
    for move in moves.splitA:
      # consult book of moves
      if move in nextmove:
        next = nextmove[move]
      else:
        next = move.mapIt(keypad.press it).join
        nextmove[move] = next
      # consult book of repetitions
      if next in movecount:
        movecount[next].inc(count)
      else:
        movecount[next] = count
  return keypads.recurse

proc calcScore(ks: var seq[KeyPad], s: string): int64 =
  # maybe - rename to totalKeyPresses
  var
    keypads = ks[1..^1]
    keypad = ks[0]
    sum: int
  for c in s:
    var size: int
    var bestmove: string
    for move in keypad.possibleMoves(c):
      var simpads = keypads[0..1]
      let bigmove = simpads.simulate move
      if bigmove.len <= size or size == 0:
        size = bigmove.len
        bestmove = move
    sum += size
    movecount = {bestmove: 1}.toTable
    result += keypads.recurse
  return

proc solve(n: int) =
  var sum: int64
  for code in input.lines:
    var keypads = @[kn] & kd.repeat(n)
    let score = keypads.calcScore(code)
    sum += score * code[0..^2].parseInt
    echo (code, score, score * code[0..^2].parseInt)
  echo sum

echo "part 1"
solve(2)
echo "part 2"
solve(25)
