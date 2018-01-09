from __future__ import division
import argparse
import numpy as np
import cPickle as pickle
import matplotlib.pyplot as plt

class Node(object):
    def __init__(self, d, T, nu, parent, depth):
        self.children = []
        self.parent = parent
        self.state = np.zeros(T)
        self.state[0] = (int) (np.random.rand() < nu)
        self.is_leaf = (depth == 0)

        if not self.is_leaf:
        	for c in range(d-1):
        		self.children.append(Node(d,T,nu,self,depth-1))
        	if self.parent is None:
        		self.children.append(Node(d,T,nu,self,depth-1))

    def transition(self,d,p,q,t):
    	if self.state[t-1] == 0:
    		k = 1 if self.is_leaf else d
    		s = sum([child.state[t-1] for child in self.children])
    		if self.parent is not None: 
    			s += self.parent.state[t-1]
    		self.state[t] = (int)(np.random.rand() < s/float(k))
    	else:
    		self.state[t] = (int)(np.random.rand() > q)
    	for c in self.children:
    		c.transition(d,p,q,t)

# d is the degree of the tree
# T is how many timesteps are considered
# p, q are the contact process transition parameters
# steps is how many iterations to run to generate the distribution
# nu is the initial condition (X_i(0) ~ bin(nu)).

def rt_full_simulation(d, T, p, q, steps, nu):
	root = Node(d,T,nu,None,T)
	for t in range(1,T):
		root.transition(d,p,q,t)
	return tuple(root.state)

def generate_distr(d, T, p, q, nu,steps):
	f = {}
	for p in [tuple(map(int, (bin(x)[2:].zfill(T)))) for x in range(2**T)]:
		f[p] = 0

	inc = 1./steps
	for step in range(steps):
		X = rt_full_simulation(d, T, p, q, steps, nu)
		f[X] += inc

	return f


def main():
    d = 3
    T = 3
    p = 2.0 / 3
    q = 1.0 / 3
    nu = 0.5
    steps = 1000
    epsilon = 0.05
    iters = 10
    rt_full_simulation(d, T, p, q, steps, nu)

    f = generate_distr(d, T, p, q, nu,steps)

    print sum([f[v] for v in f])
    print '------------------'
    print f


if __name__ == "__main__":
    main()