from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import numpy as np
import matplotlib.pyplot as plt
from scipy.misc import comb
import time

def make_jump(state, jump_idx):
	if jump_idx < len(state):
		# pos jump
		state[jump_idx] += 1
	else:
		state[jump_idx - len(state)] -= 1

def get_jumps(N, d, lam, mu, state):
	### Positive Jumps ###
	pos_jumps = np.zeros(N)
	for i in range(len(state)):
		pos_jumps[i] = N * lam * (
			(sum(state >= state[i])/N) ** d - (sum(state > state[i])/N) ** d
			)/sum(state == state[i])

	### Negative Jumps ###
	neg_jumps = np.zeros(N)
	# If a queue has > 0 elements, then set neg jump rate to mu
	neg_jumps[np.nonzero(state)] = mu

	return np.concatenate((pos_jumps,neg_jumps))


def main():
	x = {1:[0], 2:[0], 3:[0]}
	y = {1:[0], 2:[0], 3:[0]}
	for d in [1, 2, 3]:
		N = 20
		lam = 0.95
		mu = 1

		# The state space is a vector of N natural numbers, where item i is the
		# number of items at queue i
		state = np.zeros(N)

		t = 0
		while(t < 1000):	
			jumps = get_jumps(N, d, lam, mu, state)
			next_jump = np.random.exponential(1/sum(jumps))

			prob_jump = jumps / sum(jumps)
			jump_idx = np.random.choice(range(len(prob_jump)), 1, p=prob_jump)

			make_jump(state, jump_idx)
			x[d] += [t]
			y[d] += [sum(state)]

			t += next_jump
			print(d, t)

	plt.plot(x[1], y[1], label='d = 1')
	plt.plot(x[2], y[2], label='d = 2')
	plt.plot(x[3], y[3], label='d = 3')

	legend = plt.legend(loc='upper left', shadow=True)


	plt.show()




if __name__ == "__main__":
    main()