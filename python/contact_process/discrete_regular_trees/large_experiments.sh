#!/bin/bash

for d in 2 3 4 5 6
do
  for T in 2 3 4 5 6
  do
    python compare.py --steps 10000000 -d $d -T $T --iters 6 --epsilon 0.005
  done
done