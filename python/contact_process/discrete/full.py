import argparse
import numpy as np
import cPickle as pickle
import util
import graphs
import matplotlib.pyplot as plt



def discrete_full_simulation(G, k, T, p, q, n, init=0.5):
    X = np.zeros((T, n))
    # Initial conditions, if provided.
    X[0, :] = (np.random.rand(n) < init).astype(int)
    for t in range(T - 1):
        for i in range(n):
            if X[t, i] == 1:
                X[t + 1, i] = (int)(np.random.rand() > q)
            elif X[t, i] == 0:
                X[t + 1, i] = (int)(np.random.rand() < (p / k)
                                    * sum([X[t, j] for j in G[i]]))
    return X


def generate_distribution(G, k, T, p, q, n, init, start, end, step_iters):
    f = {}
    inc = 1.0 / step_iters
    for i in range(step_iters):
        X = discrete_full_simulation(G, k, T, p, q, n, init)
        st = X[:, start:end].tostring()
        if st not in f:
            f[st] = inc
        else:
            f[st] += inc
    return f


def main():
    args = util.command_line_args()

    G, k = graphs.get_graph(args.graph, args.n)

    if args.simulate:
        print discrete_full_simulation(G, k, args.T, args.p, args.q, args.n, args.init)

    if args.generate_distribution:
        f = generate_distribution(G, k, args.T, args.p, args.q, args.n, args.init,
                                  args.start_index, args.end_index, args.step_iters)
        util.save_distribution(f, args.file)

    if args.plot:
        f = generate_distribution(G, k, args.T, args.p, args.q, args.n, args.init,
                                  args.start_index, args.end_index, args.step_iters)
        util.plot_distribution(f, args.T)
        plt.show()


if __name__ == "__main__":
    main()
