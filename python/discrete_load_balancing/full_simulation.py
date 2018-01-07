import numpy as np
import cPickle as pickle

def typical_distr(T,lam,n,k,j,step_iters):

	f = {}
	f_inc = 1.0/step_iters

	for iteration in range(step_iters):
		X,_ = full_simulation(T,lam,n,k)
		# update f_new
		st = X[:,j].tostring()
		if st in f:
			f[st] += f_inc
		else:
			f[st] = f_inc

	return f

def full_simulation(T,lam,n,k):

	# How many packets are lost.
	loss = 0

	# X[t,i] represents the legth of queue i at time t.
	X = np.zeros((T, n))

	# Initial conditions: All queues empty.

	for t in range(0,T-1):

		X[t+1,:] = X[t,:]

		for i in range(0,n):

			# Serve an item, if queue is non-empty.
			if X[t,i] > 0:
				X[t+1,i] -= 1

			# If there is no arrival, continue.
			if np.random.rand() > lam:
				continue

			# Get neighbors.
			neighbors = [ X[t, (i-1) % n], X[t, i % n], X[t, (i+1) % n] ]

			# Get minimum value of neighbors.
			min_neighbor_length = min(neighbors)

			# Choose, at random, a neighbor with queue length = min
			min_neighbors = []
			for j in range(len(neighbors)):
				if neighbors[j] == min_neighbor_length:
					min_neighbors.append((i-1+j) % n)
			min_neighbor = min_neighbors[np.random.randint(len(min_neighbors))]

			# Send one packet to min neighbor as long as below threshold
			if X[t+1,min_neighbor] < k-1:
				X[t+1,min_neighbor] += 1
			else:
				loss += 1

	return X, loss
	
def main():
	print(full_simulation(4, 0.95, 10, 4))

	T = 3
	step_iters = 10000

	f = typical_distr(T,0.95,20,10,10,step_iters)
	pickle_out = open("data/full_T=%d_step_iters=%d" % (T,step_iters),"wb")
	pickle.dump(f, pickle_out)
	pickle_out.close()

if __name__ == "__main__":
    main()
