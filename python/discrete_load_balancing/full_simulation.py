import numpy as np

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

if __name__ == "__main__":
    main()
