import numpy as np

def fixed_point_simulation(T,lam,k,epsilon,max_iters,step_iters):

	residuals = []

	# measure on the space of T x 7 matricies with each entry in {0,...,k-1}
	f = {}

	# for each matrix M of size t x 4, l[t][M], r[t][M] for 0 < t < T contain
	# a list of ((y,z), p) where (y,z) is the value of left two particels or
	# right two particles, and p is the probability of those values.
	l = [{} for t in range(T)]
	r = [{} for t in range(T)]

	for iteration in range(max_iters):
		new_f, l, r = one_iteration(T,r,k,l,r,step_iters)
		# Get the L1 norm of new_f - f.
		residuals.append(sum([abs(new_f[m] - f[m]) for m in new_f if m in f]))
		residuals[-1] += sum([new_f[m] for m in new_f if m not in f])
		residuals[-1] += sum([f[m] for m in f if m not in new_f])
		# Break if this norm exceeds epsilon.
		if residuals[-1] < epsilon: break

		f = new_f
		print(residuals[-1])

	print(residuals)
	return f, residuals

# Updates l and r from one observation of X
def update_l_and_r(T,X,l,r,ind):
	for t in range(1, T):
		X_minus_3_through_0 = X[:t,ind(-3):ind(1)].tostring()
		X_1_2 = X[t,ind(1)], X[t,ind(2)]

		if X_minus_3_through_0 not in l[t]:
			l[t][X_minus_3_through_0] = [X_1_2]
		else:
			l[t][X_minus_3_through_0].append(X_1_2)

		X_0_through_3 = X[:t,ind(-3):ind(1)].tostring()
		X_minus_2_minus_1 = X[t,ind(-2)], X[t,ind(-1)]

		if X_0_through_3 not in r[t]:
			r[t][X_0_through_3] = [X_minus_2_minus_1]
		else:
			r[t][X_0_through_3].append(X_minus_2_minus_1)


def one_iteration(T,lam,k,l,r,step_iters):
	f_new = {}
	l_new = [{} for t in range(T)]
	r_new = [{} for t in range(T)]

	ind_extended = lambda i : i + 5
	ind_small = lambda i : i + 3
	f_inc = 1.0/step_iters

	for iteration in range(step_iters):
		X = evolve_system(T,lam,k,l,r,ind_extended)

		# update f_new
		st = X.tostring()
		if st in f_new:
			f_new[st] += f_inc
		else:
			f_new[st] = f_inc
		del st

		# update l and r
		update_l_and_r(T,X,l,r,ind_small)

	return f_new, l_new, r_new


def evolve_system(T,lam,k,l,r,ind):
	# We have 11 queues total that we need to keep track of, -5, -4, ..., 4, 5

	# X[t,i] represents the legth of queue i at time t.
	X = np.zeros((T, 11))

	for t in range(0,T-1):

		X[t+1,:] = X[t,:]

		# arrival at i if arrivals[ind(i)] = true
		arrival = np.random.random(11) <= 0.95

		# If there is an arrival at queue -4 or -3 then we need to know the value
		# of queues -5 and -4.
		if arrival[ind(-4)] or arrival[ind(-3)]:
			X[t+1,ind(-4)], X[t+1,ind(-5)] = get_left(t+1,l,X,k,ind)

		# If there is an arrival at queue -4 or -3 then we need to know the value
		# of queues -5 and -4.
		if arrival[ind(3)] or arrival[ind(4)]:
			X[t+1,ind(5)], X[t+1,ind(4)] = get_right(t+1,r,X,k,ind)

		# Only need process arrivals from queues -4,...,4
		for i in range(1,11):

			# Serve an item, if queue is non-empty.
			if X[t,i] > 0:
				X[t+1,i] -= 1

			# If there is no arrival, continue.
			if not arrival[i]: continue

			# Get neighbors.
			neighbors = [ X[t, (i-1) % 11], X[t, i % 11], X[t, (i+1) % 11] ]

			# Get minimum value of neighbors.
			min_neighbor_length = min(neighbors)

			# Choose, at random, a neighbor with queue length = min
			min_neighbors = []
			for j in range(len(neighbors)):
				if neighbors[j] == min_neighbor_length:
					min_neighbors.append((i-1+j) % 11)
			min_neighbor = min_neighbors[np.random.randint(len(min_neighbors))]

			# Send one packet to min neighbor as long as below threshold
			if X[t+1,min_neighbor] < k-1:
				X[t+1,min_neighbor] += 1

	return X[:,ind(-3):ind(4)]

def get_left(t,l,X,k,ind):
	match_array = np.fliplr(X[:t,ind(-3):ind(1)]).tostring()
	if match_array not in l[t]:
		return np.random.randint(k),np.random.randint(k)
	tuples = l[t][match_array]
	del match_array
	return tuples[np.random.randint(len(tuples))]

def get_right(t,r,X,k,ind):
	match_array = np.fliplr(X[:t,ind(0):ind(4)]).tostring()
	if match_array not in r[t]:
		return np.random.randint(k),np.random.randint(k)
	tuples = r[t][match_array]
	del match_array
	return tuples[np.random.randint(len(tuples))]

## Test cases ##

def test_update_l_and_r():
	ind = lambda i : i + 5
	X = np.array([[-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5],
				  [-50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50],
				  [-500, -400, -300, -200, -100, 0, 100, 200, 300, 400, 500],
				  [-10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10]])
	Y = np.array([[-5, -4, -3, -2, -1, 0, 2, 3, 3, 4, 5],
				  [-50, -40, -30, -20, -10, 0, 11, 21, 30, 40, 50],
				  [-500, -400, -300, -200, -100, 0, 101, 201, 300, 400, 500],
				  [-10, -8, -6, -4, -2, 0, 3, 5, 6, 8, 10]])
	T = X.shape[0]
	l = [{} for t in range(T)]
	r = [{} for t in range(T)]

	update_l_and_r(T,X,l,r,ind)
	update_l_and_r(T,Y,l,r,ind)
	update_l_and_r(T,2*X,l,r,ind)

	'''
	for k in l[1]:
		print(np.fromstring(k,dtype=int).reshape(1,4))
		print(l[1][k])
	for k in l[2]:
		print(np.fromstring(k,dtype=int).reshape(2,4))
		print(l[2][k])
	for k in l[3]:
		print(np.fromstring(k,dtype=int).reshape(3,4))
		print(l[3][k])

	print(get_left(1,l,np.array([[-1, -1, 0, -1, -2, -3, -1, -1, -1, -1]]),10,ind))
	'''
	for k in r[1]:
		print(np.fromstring(k,dtype=int).reshape(1,4))
		print(r[1][k])
	for k in r[2]:
		print(np.fromstring(k,dtype=int).reshape(2,4))
		print(r[2][k])
	for k in r[3]:
		print(np.fromstring(k,dtype=int).reshape(3,4))
		print(r[3][k])




def test():
	test_update_l_and_r()

## Main ##

def main():
	fixed_point_simulation(3, 0.95, 10, 0.05, 10, 100000000)
	#test()

if __name__ == "__main__":
    main()