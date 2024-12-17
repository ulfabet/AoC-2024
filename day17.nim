# AoC-2024 day 17

import std/strutils
import std/sequtils
import std/strscans
import std/math

type
  InstructionPointer = int
  Program = seq[int]
  Operand = int
  Registers = seq[int64]

let
  input = "day17.input".readFile
  data = input.strip.split("\n\n")

proc parseRegister(s: string): int =
  var register: char
  if not s.scanf("Register $c: $i", register, result):
    assert false

proc parseProgram(s: string): Program =
  s.split[1].split(",").map(parseInt)

var
  registers = data[0].splitLines.mapIt(int64 it.parseRegister)
  program = data[1].parseProgram
  output: seq[int]
  ip: InstructionPointer

proc combo(o: Operand): int64 =
  case o:
    of 0..3: return o
    of 4..6: return registers[o-4]
    else: assert false

proc iadv(o: Operand) =
  registers[0] = registers[0] div 2^combo(o)

proc ibxl(o: Operand) =
  registers[1] = registers[1] xor o

proc ibst(o: Operand) =
  registers[1] = combo(o) mod 8

proc ijnz(o: Operand) =
  if registers[0] != 0:
    ip = o-2

proc ibxc(o: Operand) =
  registers[1] = registers[1] xor registers[2]

proc iout(o: Operand) =
  output.add(int combo(o) mod 8)

proc ibdv(o: Operand) =
  registers[1] = registers[0] div 2^combo(o)

proc icdv(o: Operand) =
  registers[2] = registers[0] div 2^combo(o)

proc run(p: Program) =
  let instructions = [iadv, ibxl, ibst, ijnz, ibxc, iout, ibdv, icdv]
  ip = 0
  while ip < p.high:
    instructions[p[ip]](p[ip+1])
    ip += 2

proc part1() =
  program.run
  echo "part 1\n", output.join(",")

proc part2() =
  var
    a = int64 1E13
    b = a div 8
    c = 1
  while true:
    registers = @[a, 0, 0]
    output = @[]
    program.run
    if output[^c..^1] == program[^c..^1]:
      if output.len == program.len:
        if output == program:
          break
        b = max(1, b div 8)
        c += 1
    a += b
  echo "part 2\n", a

part1()
part2()
