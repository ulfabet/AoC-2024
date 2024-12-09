# AoC-2024 day 9

import std/strutils

const
  input = "day9.input"

# Globals for part 1
var
  files, freeSpace: seq[int]

for line in input.lines:
  for i,c in line:
    if i mod 2 == 0:
      files.add(c.int-48)
    else:
      freeSpace.add(c.int-48)

# Globals for part 2 - Yes, this is dirty.
var
  blocks = files
  empty = freeSpace
  space: seq[seq[int]]

for i,_ in empty:
  space.add(@[])

proc part1(): int =
  var
    index: int
    head = files.low
    tail = files.high

  while head <= tail:
    for i in 1 .. files[head]:
      result += index * head
      index += 1
    if head == tail:
      break
    for i in 1 .. freeSpace[head]:
      while files[tail] == 0:
        tail.dec
      result += index * tail
      index += 1
      files[tail].dec
    head.inc

proc part2(): int =
  var
    index: int
    head = blocks.low
    tail = blocks.high

  # iterate files from high to low
  while tail > 0:
    # look for leftmost empty space
    head = 0
    let n = blocks[tail]
    while head < tail and empty[head] < n:
      head.inc
    if head < tail:
      # move file
      empty[head].dec(n)
      empty[tail-1].inc(n)
      for i in 1 .. n:
        space[head].add(tail)
      blocks[tail] = 0
    tail.dec

  # calculate checksum
  for i, n in blocks:
    for j in 1 .. n:
      result += index * i
      index += 1
    if i < space.len:
      for id in space[i]:
        result += index * id
        index += 1
      index += empty[i]
  return

echo "part 1"
echo part1()

echo "part 2"
echo part2()
