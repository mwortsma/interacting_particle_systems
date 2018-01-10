from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import rt_util

# d is the degree of the tree
# T is how many timesteps are considered
# p, q are the contact process transition parameters
# iters is how many iterations to run the fixed point algorithm for
# epsilon is the breaking considion for consecutive iterations
# steps is how many iterations to run to generate the distribution
# nu is the initial condition (X_i(0) ~ bin(nu)).


def rt_local_approx(d, T, p, q, iters, epsilon, steps, nu, file=None):
    # f is the joint distribution over the single neighborhood of the root
    f = {}
    # cond is the conditional law of d-1 children given the root and the dth
    cond = init_cond(T)

    one_particle_distr = init_one_particle_distr(T)

    distances = []

    one_particle_distances = []

    if file:
        F = open(file, "w")

    for iteration in range(iters):
        f_new, cond_new, one_particle_distr_new, bad = rt_local_approx_iteration(
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
                           one_particle_distr_new[k])**l for k in rt_util.bin_tuples(T)])
        one_particle_distances.append(op_dist)
        info_str = 'iteration %d, Full distance %f, OP Distance %f, baddness %f' % (
            iteration, dist, op_dist, bad)

        if file:
            F.write(info_str)
            F.write('\n')
        else:
            print info_str

        f = f_new
        cond = cond_new
        one_particle_distr = one_particle_distr_new

        if dist < epsilon:
            break

    return f, cond, one_particle_distr, distances, one_particle_distances, bad


def rt_local_approx_iteration(d, T, p, q, steps, nu, cond):
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
        for p1 in rt_util.bin_tuples(t):
            for p2 in rt_util.bin_tuples(t):
                p = (p1, p2)
                for c in cond_new[t][p]:
                    if observed[t][p] != 0:
                        cond_new[t][p][c] = cond_new[t][p][c] / observed[t][p]

    return f_new, cond_new, one_particle_distr_new, bad / steps


def init_cond(T):
    cond = [{} for t in range(T)]
    for t in range(1, T):
        for p1 in rt_util.bin_tuples(t):
            for p2 in rt_util.bin_tuples(t):
                cond[t][(p1, p2)] = {}
    return cond


def init_observations(T):
    observations = [{} for t in range(T)]
    for t in range(1, T):
        for p1 in rt_util.bin_tuples(t):
            for p2 in rt_util.bin_tuples(t):
                observations[t][(p1, p2)] = 0.
    return observations


def init_one_particle_distr(T):
    one_particle_distr = {}
    for p in rt_util.bin_tuples(T):
        one_particle_distr[p] = 0.
    return one_particle_distr


# TODO: fix conversion away from int
def rt_realization(d, T, p, q, nu, cond):
    bad = 0
    X = np.zeros((T, d + 1))
    X[0, :] = (np.random.rand(d + 1) < nu).astype(int)
    for t in range(1, T):
        if X[t - 1, 0] == 0:
            X[t, 0] = (int)(np.random.rand() < (p / d) * sum(X[t - 1, 1:]))
        else:
            X[t, 0] = (int)(np.random.rand() > q)
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
    d = 4
    T = 4
    p = 2.0 / 3
    q = 1.0 / 3
    nu = 0.5
    cond = init_cond(T)
    steps = 10000
    epsilon = 0.005
    iters = 10
    f, c, opd, res, op_res, bad = rt_local_approx(
        d, T, p, q, iters, epsilon, steps, nu)


if __name__ == "__main__":
    main()
