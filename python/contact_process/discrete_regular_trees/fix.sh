#!/bin/bash

# default p = 2/3, q = 1/3
# python compare.py --steps 10000 -d 4 -T 2 --iters 2

for d in 2 3 4 5
do
  for T in 2 3 4 5 6
  do
    for steps in 10000 100000 1000000
    do
      python fix.py --steps $steps -d $d -T $T --iters 6 --epsilon 0.005
    done
  done
done