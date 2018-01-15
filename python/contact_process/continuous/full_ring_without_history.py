from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import cPickle as pickle
import argparse

def cleaned(p):
    oldp = p
    i = 1
    while True:
        if len(p[0]) == i: break
        if p[0][i] == p[0][i-1] and p[1][i] == p[1][i-1]:
            p = (p[0][:i] + p[0][i+1:], p[0][:i] + p[0][i+1:])
        else:
            i += 1
    return p

def pkl_save(d, file):
    pickle.dump(d, open(file, "wb"))

# E.g. bin_tuples(4) = [(0, 0), (0, 1), (1, 0), (1, 1)]


def bin_tuples(z):
    z=1
    return [tuple(map(int, (bin(x)[2:].zfill(z)))) for x in range(2**z)]


class Event(object):

    def __init__(self, is_recover, node):
        self.is_recover = is_recover
        self.node = node


def get_rates(X, lam):
    n = len(X)
    rates = []
    events = []
    for i in range(n):
        if X[i] == 1:
            rates.append(1.)
            events.append(Event(True, i))
            if X[(i - 1) % n] == 0:
                rates.append(lam)
                events.append(Event(False, (i - 1) % n))
            if X[(i + 1) % n] == 0:
                rates.append(lam)
                events.append(Event(False, (i + 1) % n))
    return rates, events


def full_ring(T, lam, n):
    X = np.zeros((T, n))
    X[0, :] = (np.random.rand(n) < 0.5).astype(int)
    times = np.zeros(T)
    t = 1
    while t < T and sum(X[t - 1, :]) > 0:
        X[t, :] = X[t - 1, :]
        rates, events = get_rates(X[t - 1, :], lam)
        sum_rates = sum(rates)
        inc = np.random.exponential(1. / sum_rates)
        times[t] = times[t - 1] + inc
        scaled_rates = [z / sum_rates for z in rates]
        event = np.random.choice(events, 1, p=scaled_rates)[0]
        # print 'recovery %d node %d' % (event.is_recover, event.node)
        X[t, event.node] = (int)(not event.is_recover)
        t += 1
    return t, X


def main():
    parser = argparse.ArgumentParser(description='None')
    parser.add_argument('--plot', action="store_true", default=False)
    parser.add_argument('--save', action="store_true", default=False)
    parser.add_argument('--iters', action="store", default=1000, type=int)
    parser.add_argument('-T', action="store", default=3, type=int)
    args = parser.parse_args()
    iters = args.iters
    T = args.T
    lam = 0.6
    n = 15
    observed_1 = {}
    num_one_1 = {}
    observed_2 = {}
    num_one_2 = {}
    for p1 in bin_tuples(T):
        for p2 in bin_tuples(T):
            p = cleaned((p1,p2))
            b = cleaned((p2,p1))
            observed_1[p] = 0.0
            num_one_1[p] = 0.0
            observed_2[b] = 0.0
            num_one_2[b] = 0.0

    for iteration in range(iters):
        t, X = full_ring(T, lam, n)
        X_neg1 = X[T - 1, 5]
        X_0 = tuple(X[T-1:, 6])
        X_1 = tuple(X[T-1:, 7])
        X_2 = X[T - 1, 8]

        observed_1[cleaned((X_1, X_0))] += 1
        num_one_1[cleaned((X_1, X_0))] += X_2

        print(float(iteration) / iters)

    for iteration in range(iters):
        t, X = full_ring(T, lam, n)
        X_neg1 = X[T - 1, 5]
        X_0 = tuple(X[T-1:, 6])
        X_1 = tuple(X[T-1:, 7])
        X_2 = X[T - 1, 8]

        observed_2[cleaned((X_0, X_1))] += 1
        num_one_2[cleaned((X_0, X_1))] += X_neg1

        print(float(iteration) / iters)

    f1 = {}
    for p in observed_1:
        if observed_1[p] > 0:
            f1[p] = num_one_1[p] / observed_1[p]
        else:
            f1[p] = 0.0

    f2 = {}
    for p in observed_2:
        if observed_2[p] > 0:
            f2[p] = num_one_2[p] / observed_2[p]
        else:
            f2[p] = 0.0

    s = 0.
    for p in observed_1:
        print f1[p]
        print f2[p]
        print observed_1[p]
        print observed_2[p]
        print '-'
        s += abs(f1[p] - f2[p])
    print s

    string = "T=%d" % T
    if args.save:
        pkl_save(observed_1, string + "observed_1.pkl")
        pkl_save(observed_2, string + "observed_2.pkl")
        pkl_save(f1, string + "f1.pkl")
        pkl_save(f2, string +"f2.pkl")

    if args.plot:
        plt.plot([f1[v] for v in sorted(f1.iterkeys())], 'b')
        plt.plot([f2[v] for v in sorted(f1.iterkeys())], 'r')
        plt.show()


if __name__ == "__main__":
    main()
