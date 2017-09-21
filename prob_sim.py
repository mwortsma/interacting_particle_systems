from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import numpy as np
import matplotlib.pyplot as plt
from scipy.misc import comb
import time

# sample with replacement
def sample_with_replacement(r, N, d):
	return (r/N)**d

def sample_without_replacement(r, N, d):
	return np.cumprod([(r-j)/(N-j) for j in range(d)])[-1]

N = 1000

state = np.random.randint(N, size=N)
state = np.sort(state)

m = np.zeros(max(state)+2)
for j in range(len(m)):
	m[j] = sum(state >= j)

for d in [1,2,3,4]:

	chosen = np.zeros(N)


	iters = 100000
	for _ in range(iters):
		choices = np.random.permutation(range(N))[:d]
		choices_map = {}
		for c in choices:
			if state[c] in choices_map:
				choices_map[state[c]] += [c]
			else:
				choices_map[state[c]] = [c]
		
		min_key = min(choices_map, key=choices_map.get)
		q = np.random.permutation(choices_map[min_key])[0]
		chosen[q] += 1

	chosen = chosen / iters
	ax = plt.subplot(2,2,d)

	label='simulation d = %d' % d
	plt.plot(chosen, label='simulation', linestyle='None',marker='.')
	print('done')

	f = sample_without_replacement
	y = np.zeros(N)
	for j in range(N):
		k = state[j]
		y[j] = (f(m[k], N, d) -  f(m[k+1], N, d))/(m[k] - m[k+1])

	plt.plot(y, label='prediction', linestyle='None',marker='.')
	legend = plt.legend(loc='upper right', shadow=True)
	ax.set_title("d = %d" % d)
	ax.set_xlabel("Queue # (sorted by length)")
	ax.set_ylabel("Probability Chosen")
plt.show()

