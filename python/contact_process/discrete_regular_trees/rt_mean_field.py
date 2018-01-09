from __future__ import division
import argparse
import numpy as np
import cPickle as pickle
import matplotlib.pyplot as plt
import thread

import multiprocessing

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
    cond = init_cond(T)

    one_particle_distr = init_one_particle_distr(T)

    distances = []

    one_particle_distances = []

    for iteration in range(iters):
        f_new, cond_new, one_particle_distr_new = rt_mean_field_iteration(
            d, T, p, q, steps, nu, cond)

        # distance
        l = 1
        dist = 0
        dist += sum([f_new[k]**l for k in f_new if k not in f])
        dist += sum([f[k]**l for k in f if k not in f_new])
        dist += sum([abs(f[k] - f_new[k])**l for k in f if k in f_new])
        distances.append(dist)

        op_dist = 0
        op_dist = sum([abs(one_particle_distr[k] -
                           one_particle_distr_new[k])**l for k in bin_tuples(T)])

        print 'iteration %d, Full distance %f, OP Distance %f' % (iteration, dist, op_dist)

        if dist < epsilon:
            break

        f = f_new
        cond = cond_new
        one_particle_distr = one_particle_distr_new

    return f, cond, one_particle_distr, distances


def rt_mean_field_iteration(d, T, p, q, steps, nu, cond):
    f_new = {}
    cond_new = init_cond(T)
    one_particle_distr_new = init_one_particle_distr(T)

    observed = init_observations(T)

    bad = 0.

    increment = 1.0 / steps
    for step in range(steps):
        # X[0] is root. X[1:d+1] is the d children.
        X, b = rt_realization(d, T, p, q, nu, cond)
        bad += b
        # record the realization in f_new
        if X.tostring() not in f_new:
            f_new[X.tostring()] = increment
        else:
            f_new[X.tostring()] += increment
        # record the realization in cond_new
        for t in range(1, T):
            for k in range(1, d + 1):
                # TODO: See email clarification and change to t instead of t-1
                # maybe.
                other_children = tuple(X[t - 1, 1:k]) + \
                    tuple(X[t - 1, (k + 1):])
                root_and_child = (tuple(X[:t, 0]), tuple(X[:t, k]))
                observed[t][root_and_child] += 1
                if other_children not in cond_new[t][root_and_child]:
                    cond_new[t][root_and_child][other_children] = 1
                else:
                    cond_new[t][root_and_child][other_children] += 1
        # Record realization in one_particle_distr
        one_particle_distr_new[tuple(X[:, 0])] += increment

    # normalize cond_new
    for t in range(1, T):
        for p1 in bin_tuples(t):
            for p2 in bin_tuples(t):
                p = (p1, p2)
                for c in cond_new[t][p]:
                    if observed[t][p] != 0:
                        cond_new[t][p][c] = cond_new[t][p][c] / observed[t][p]

    print bad/steps
    return f_new, cond_new, one_particle_distr_new


# Returns a list (of length 2^z) where the ith element in the
# list is a tuple (a_1,...,a_z) where a_1,...,a_z are the coefficients
# when i is written in binary.

# E.g. bin_tuples(4) = [(0, 0), (0, 1), (1, 0), (1, 1)]
def bin_tuples(z):
    return [tuple(map(int, (bin(x)[2:].zfill(z)))) for x in range(2**z)]


def init_cond(T):
    cond = [{} for t in range(T)]
    for t in range(1, T):
        for p1 in bin_tuples(t):
            for p2 in bin_tuples(t):
                cond[t][(p1, p2)] = {}
    return cond


def init_observations(T):
    observations = [{} for t in range(T)]
    for t in range(1, T):
        for p1 in bin_tuples(t):
            for p2 in bin_tuples(t):
                observations[t][(p1, p2)] = 0.
    return observations


def init_one_particle_distr(T):
    one_particle_distr = {}
    for p in bin_tuples(T):
        one_particle_distr[p] = 0.
    return one_particle_distr


# TODO: fix conversion away from int
def rt_realization(d, T, p, q, nu, cond):
    bad = 0
    X = np.zeros((T, d + 1))
    X[0, :] = (np.random.rand(d + 1) < nu).astype(int)
    for t in range(1, T):
        if X[0, t - 1] == 0:
            X[0, t] = (int)(np.random.rand() < (p / d) * sum(X[t - 1, 1:]))
        else:
            X[0, t] = (int)(np.random.rand() > q)
        for k in range(1, d + 1):
            if X[t - 1, k] == 0:
                root_and_child = (tuple(X[:t, k]), tuple(X[:t, 0]))
                if len(cond[t][root_and_child]) > 0:
                    options = cond[t][root_and_child]
                    random = np.random.rand()
                    s = 0
                    for other_children in options:
                        s += options[other_children]
                        if s > random:
                            break
                else:
                    # no options here -- just take a random number?
                    # hopefully this doesn't happen after the first iteration.
                    other_children = (np.random.rand(d) < nu).astype(int)
                    bad += 1
                X[t, k] = (int)(np.random.rand() < (
                                p / d) * (sum(other_children) + X[t - 1, 0]))

            else:
                X[t, k] = (int)(np.random.rand() > q)
    return X.astype(int), bad


def main():
    cond = init_cond(3)
    d = 3
    T = 4
    p = 2.0 / 3
    q = 1.0 / 3
    nu = 0.5
    cond = init_cond(T)
    steps = 10000000
    epsilon = 0.005
    iters = 10
    f,c,opd, res = rt_mean_field(d, T, p, q, iters, epsilon, steps, nu)


if __name__ == "__main__":
    main()
