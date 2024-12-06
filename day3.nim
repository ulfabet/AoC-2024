# AoC-2024 day 3

import std/strutils
import std/sequtils
import std/math

const input = "day3.input".readFile
var index: int

proc consume(n: int): bool =
  index += n
  return true

proc consume(s: string): bool =
  if input.continuesWith(s, index):
    return consume(s.len)

proc readChar(c: var char): bool =
  c = input[index]
  return consume(1)

proc parseFactor(value: var int): bool =
  iterator consumeDigits(n: int): char =
    for i in 1 .. n:
      let old = index
      var c: char
      if readChar(c) and c in Digits:
        yield c
      else:
        index = old
        break
  let s = consumeDigits(3).toSeq.join
  if s.len > 0:
    value = s.parseInt
    return true

proc parseMul(product: var int): bool =
  let old = index
  var a, b: int
  if consume("mul(") and parseFactor(a) and consume(",") and parseFactor(b) and consume(")"):
    product = a*b
    return true
  else:
    index = old
    return false
  
iterator eachProduct(): int =
  index = input.low
  while index < input.high:
    var product: int
    if parseMul(product):
      yield product
    else:
      discard consume(1)

var disabled: bool

proc parseDo(): bool =
  if consume("do()"):
    disabled = false
    return true

proc parseDont(): bool =
  if consume("don't()"):
    disabled = true
    return true

iterator eachEnabledProduct(): int =
  index = input.low
  while index < input.high:
    var product: int
    discard parseMul(product) or parseDo() or parseDont() or consume(1)
    if not disabled and product != 0: yield product

echo "part 1"
echo eachProduct().toSeq.sum

echo "part 2"
echo eachEnabledProduct().toSeq.sum
