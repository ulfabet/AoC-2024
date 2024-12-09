# AoC-2024 day 7
# - really slow. nothing to see here, please move along.
# - todo: split code into part 1 and part 2 

import std/strutils
import std/sequtils
import std/math

const
  # input = "day7.input"
  input = "day7.example"

proc opConcatenate(x, y: int): int = ($x & $y).parseInt

proc opMultiply(x, y: int): int = x*y

proc opAdd(x, y: int): int = x+y

let operators = [opMultiply, opAdd, opConcatenate]

# This could probably be done with some library function
proc toBase(x: int, base: int = 2, pad: int = 0): seq[int] =
  let y = x div base
  if y == 0 and pad <= 1:
    return @[x mod base]
  else:
    return toBase(y, base, pad-1) & @[x mod base]

proc perform(numbers, order: seq[int]): int =
  # echo "perform on numbers ", numbers, " in order ", order
  result = operators[order[0]](numbers[0], numbers[1])
  if numbers.len == 2:
    return result
  else:
    return perform(@[result] & numbers[2..^1], order[1..^1])

iterator possiblyTrue(): int =
  for line in input.lines:
    let
      a = line.split(": ")
      value = a[0].parseInt
      numbers = a[1].split.map(parseInt)
    echo "> ", line
    for i in 0 .. 3^(numbers.len-1)-1:
      let order = toBase(i, 3, numbers.len-1)
      if value == perform(numbers, order):
        yield value
        break

echo possiblyTrue.toSeq.sum
