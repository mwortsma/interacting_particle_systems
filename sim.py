from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import argparse
import numpy as np
import matplotlib.pyplot as plt
from scipy.misc import comb
import time

# sample with replacement
def sample_with_replacement(r, N, d):
	return (r/N)**d

def sample_without_replacement(r, N, d):
	return np.cumprod([(r-j)/(N-j) for j in range(d)])[-1]

def make_jump(state, jump_idx, m):
	if jump_idx < len(state):
		# pos jump
		state[jump_idx] += 1

		m[int(state[jump_idx])] += 1
	else:
		m[int(state[jump_idx - len(state)])] -= 1
		state[jump_idx - len(state)] -= 1

def get_jumps(N, d, lam, mu, state, m):
	### Positive Jumps ###
	pos_jumps = np.zeros(N)

	f = sample_without_replacement
	for i in range(N):
		k = state[i]
		pos_jumps[i] = N * lam * (f(m[k], N, d) -  f(m[k+1], N, d))/(m[k] - m[k+1])

	### Negative Jumps ###
	neg_jumps = np.zeros(N)
	# If a queue has > 0 elements, then set neg jump rate to mu
	neg_jumps[np.nonzero(state)] = mu

	return np.concatenate((pos_jumps,neg_jumps))


def main():

	parser = argparse.ArgumentParser(description='Rough simulation.')
	parser.add_argument('--N', dest='N', type=int, action='store', default=10, help='number of queues')
	parser.add_argument('--lambda', dest='lam', type=float, action='store', default=0.95, help='rate')
	parser.add_argument('--t', dest='t', type=int, action='store', default=100, help='time')

	args = parser.parse_args()
	N = args.N
	lam = args.lam
	mu = 1
	t_lim = args.t

	x = {1:[0], 2:[0], 3:[0]}
	y = {1:[0], 2:[0], 3:[0]}
	for d in [1, 2, 3]:

		# The state space is a vector of N natural numbers, where item i is the
		# number of items at queue i
		state = np.zeros(N)
		m = np.zeros(10000)
		m[0] = len(state)

		t = 0
		while(t < t_lim):	
			jumps = get_jumps(N, d, lam, mu, state, m)
			next_jump = np.random.exponential(1/sum(jumps))

			prob_jump = jumps / sum(jumps)
			jump_idx = np.random.choice(range(len(prob_jump)), 1, p=prob_jump)

			make_jump(state, jump_idx, m)
			x[d] += [t]
			y[d] += [sum(state)]

			t += next_jump
		
		print(d)

	plt.plot(x[1], y[1], label='d = 1')
	plt.plot(x[2], y[2], label='d = 2')
	plt.plot(x[3], y[3], label='d = 3')

	legend = plt.legend(loc='upper left', shadow=True)


	plt.savefig('sim_N_%d_lam_%f_t_%d.png' % (N, lam, t_lim))




if __name__ == "__main__":
    main()