import argparse
import numpy as np
import cPickle as pickle
import util
import graphs


def discrete_full_simulation(G, k, T, p, q, init=0.5):
    X = np.zeros(T)
    # Initial conditions, if provided.
    X[0] = (int)(np.random.rand(1) < init)
    for t in range(T - 1):
        if X[t] == 1:
            X[t + 1] = (int)(np.random.rand(1) >= q)
        elif X[t] == 0:
            X[t + 1] = (int)(np.random.rand() < (p / k) *
                             sum([(discrete_full_simulation(G, k, t + 1, p, q, init)[-1]) for j in range(k)]))
    return X


def generate_distribution(G, k, T, p, q, init, step_iters):
    f = {}
    inc = 1.0 / step_iters
    for i in range(step_iters):
        X = discrete_full_simulation(G, k, T, p, q, init)
        st = X.tostring()
        if st not in f:
            f[st] = inc
        else:
            f[st] += inc
    return f


def main():
    args = util.command_line_args()

    G, k = graphs.get_graph(args.graph, args.n)

    if args.simulate:
        print discrete_full_simulation(G, k, args.T, args.p, args.q, args.init)

    if args.generate_distribution:
        f = generate_distribution(
            G, k, args.T, args.p, args.q, args.init, args.step_iters)
        util.save_distribution(f, args.file)


if __name__ == "__main__":
    main()
