import argparse
import numpy as np

# d is the degree of the tree
# T is how many timesteps are considered
# p, q are the contact process transition parameters
# iters is how many iterations to run the fixed point algorithm for
# epsilon is the breaking considion for consecutive iterations
# steps is how many iterations to run to generate the distribution
# nu is the initial condition (X_i(0) ~ bin(nu)).


def rt_mean_field(d, T, p, q, iters, epsilon, steps, nu):
    # f is the joint distribution over the single neighborhood of the root
    f = {}
    # cond is the conditional law of d-1 children given the root and the dth
    cond = [{} for t in range(T)]

    l1_distances = []

    for iteration in range(iters):
        f_new, cond_new = rt_mean_field_iteration(d, T, p, q, steps, nu, cond)

        # L1 distance
        l1_dist = 0
        l1_dist += sum([f_new[k] for k in f_new if k not in f])
        l1_dist += sum([f[k] for k in f if k not in f_new])
        l1_dist += sum([abs(f[k] - f_new[k]) for k in f if k in f_new])
        l1_distances.append(l1_dist)

        print 'iteration %d, L1 distance %f' % (iteration, l1_dist)

        if l1_dist < epsilon:
            break

        f = f_new
        cond = cond_new

    return f, cond, l1_distances


def rt_mean_field_iteration(d, T, p, q, steps, nu, cond):
    f_new = {}
    cond_new = init_cond(T)

    observed = init_observations(T)

    increment = 1.0 / steps
    for step in range(steps):
        # X[0] is root. X[1:d+1] is the d children.
        X = rt_realization(d, T, p, q, nu, cond)
        # record the realization in f_new
        if X.tostring() not in f_new:
            f[X.tostring()] = increment
        else:
            f_new[X.tostring()] += increment
        # record the realization in cond_new
        for t in range(1, T):
            for k in range(1, d + 1):
                other_children = X[t,1:k] + X[t,K:]
                root_and_child = (tupe(X[:t,0]), tuple(X[:t,k]))
                observed[t][root_and_child] += 1
                if other_children not in cond_new[t][root_and_child]:
                    cond_new[t][root_and_child][other_children] = 1
                else:
                    cond_new[t][root_and_child][other_children] += 1

    # normalize cond_new
    for t in range(1, T):
        for p in bin_tuples(t):
            for children in cond_new[t][p]:
                if observed[t][p] != 0:
                    cond_new[t][p][k] = cond_new[t][p][k] / observed[t][p]

    return f_new, cond_new


def bin_tuples(z):
    return [tuple(bin(x)[2:].zfill(z)) for x in range(2**z)]


def init_cond(T):
    cond = {}
    for t in range(1, T):
        for p1 in bin_tuples(t):
            for p2 in bin_tuples(t):
                cond[t][(p1, p2)] = {}
    return cond


def init_observations(T):
    cond = {}
    for t in range(1, T):
        for p1 in bin_tuples(t):
            for p2 in bin_tuples(t):
                cond[t][(p1, p2)] = 0.
    return cond


def rt_realization(d, T, p, q, nu, cond)
    X = np.zeros((T, d + 1))
    X[0, :] = (int) (np.random.rand(d+1) < nu)
    for t in range(1,T):
    	if X[0,t-1] == 0:
    		X[0,t] = (int) (np.random.rand() < p*sum([X[t-1,1:]]))
    	else:
    		X[0,t] = (int) (np.random.rand() > q)
    	for k in range(1,d+1):
    		if X[k,t-1] == 0:
    			root_and_child = (tuple(X[:t,k]), tuple(X[:t,0]))
    			options = cond[t][root_and_child]
    			random = np.random.rand()
    			s = 0
    			for k in options:
    				s += options[k]
    				if s > random:
    					X[k,t] = (int) (np.random.rand() < p*sum(k))
    		else:
    			x[k,t] = (int) (np.random.rand() > q)

