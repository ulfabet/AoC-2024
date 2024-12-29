# AoC-2024 day 22

import std/strutils
import std/sequtils
import std/tables
import std/math

const
  input = "day22.input"

proc next(n: int): int =
  result = (n * 64) xor n
  result = result mod 16777216
  result = (result div 32) xor result
  result = result mod 16777216
  result = (result * 2048) xor result
  result = result mod 16777216

iterator generate(seed, count: int): int =
  var n = seed
  for i in 1 .. count:
    n = next(n)
    yield n

type
  Monkey = object
    bananas: Table[seq[int],int]

proc digit(n: int): int =
  return n mod 10

proc diff(t: tuple[a,b: int]): int =
  return t.a - t.b

proc buyIf(monkeys: seq[Monkey], change: seq[int]): int =
  for m in monkeys:
    result += m.bananas.getOrDefault(change)

proc addMonkey(seed: int): Monkey =
  let
    prices = generate(seed, 2000).toSeq.map(digit)
    deltas = zip(prices, seed.digit & prices).map(diff)
  for i in deltas.low .. deltas.high - 3:
    let change = deltas[i .. i + 3]
    if change notin result.bananas:
      result.bananas[change] = prices[i + 3]

proc solve(input: string) =
  echo "adding monkeys"
  let monkeys = input.lines.toSeq.map(parseInt).map(addMonkey)

  echo "counting change"
  var changecount: Table[seq[int],int]
  for m in monkeys:
    for c in m.bananas.keys:
      changecount[c] = changecount.getOrDefault(c) + 1

  echo "monkey business"
  var best: int
  let maximum = changecount.values.toSeq.max
  for buyers in countdown(maximum, 1):
    if best >= 9 * buyers:
      break
    for change, count in changecount:
      if count == buyers:
        let total = monkeys.buyIf(change)
        if total > best:
          best = total
  echo best

echo "part 1"
echo input.lines.toSeq.map(parseInt).mapIt(it.generate(2000).toSeq[^1]).sum

echo "part 2"
solve(input)
