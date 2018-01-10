from __future__ import division
import argparse
import numpy as np
import cPickle as pickle
import matplotlib.pyplot as plt

import os

# Returns a list (of length 2^z) where the ith element in the
# list is a tuple (a_1,...,a_z) where a_1,...,a_z are the coefficients
# when i is written in binary.

# E.g. bin_tuples(4) = [(0, 0), (0, 1), (1, 0), (1, 1)]
def bin_tuples(z):
    return [tuple(map(int, (bin(x)[2:].zfill(z)))) for x in range(2**z)]


def make_directory(parent, name):
	directory = os.path.join(parent,name)
	if not os.path.exists(directory):
		os.makedirs(directory)
		return directory
	return None

def pkl_save(d,file):
	pickle.dump( d, open( file, "wb" ))


def pkl_get(file):
	return pickle.load( open( file, "rb" ))

def command_line_args():
    parser = argparse.ArgumentParser(
        description='Discrete Contact Process (Ring)')
    parser.add_argument('--simulate', action="store_true", default=False)
    parser.add_argument('-d', action="store", default=4, type=int)
    parser.add_argument('-T', action="store", default=3, type=int)
    parser.add_argument('-p', action="store", default=(2.0 / 3), type=float)
    parser.add_argument('-q', action="store", default=(1.0 / 3), type=float)
    parser.add_argument('--nu', action="store", default=0.5, type=float)
    parser.add_argument('--epsilon', action="store",
                        default=0.05, type=float)
    parser.add_argument('--iters', action="store",
                        default=5, type=int)
    parser.add_argument('--steps', action="store",
                        default=10000, type=int)
    return parser.parse_args()