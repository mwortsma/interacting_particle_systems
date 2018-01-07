import argparse
import numpy as np
import cPickle as pickle
import util


def discrete_full_simulation(T, p, q, n, init=0.5):
    X = np.zeros((T, n))
    # Initial conditions, if provided.
    X[0, :] = (np.random.rand(n) < init).astype(int)
    for t in range(T - 1):
        for i in range(n):
            if X[t, i] == 1:
                if np.random.rand() < q:
                    X[t + 1, i] = 0
            elif X[t, i] == 0:
                if np.random.rand() < p * (X[t, (i - 1) % n] + X[t, (i - 1) % n]):
                    X[t + 1, i] = 1
    return X


def generate_distribution(T, p, q, n, init, start, end, step_iters):
    f = {}
    inc = 1.0 / step_iters
    for i in range(step_iters):
        X = discrete_full_simulation(T, p, q, n, init)
        st = X[:, start:end].tostring()
        if st not in f:
            f[st] = inc
        else:
            f[st] += inc
    return f


def main():
    parser = argparse.ArgumentParser(
        description='Discrete Contact Process (Ring)')
    parser.add_argument('--simulate', action="store_true", default=False)
    parser.add_argument('-T', action="store", default=10, type=int)
    parser.add_argument('-p', action="store", default=(1.0 / 2), type=float)
    parser.add_argument('-q', action="store", default=(1.0 / 3), type=float)
    parser.add_argument('-n', action="store", default=5, type=int)
    parser.add_argument('--init', action="store", default=0.5, type=float)

    parser.add_argument('--generate_distribution',
                        action="store_true", default=False)
    parser.add_argument('--start_index', action="store", default=0, type=int)
    parser.add_argument('--end_index', action="store", default=1, type=int)
    parser.add_argument('--step_iters', action="store",
                        default=10000, type=int)
    parser.add_argument('--output_file', action="store", default="out.txt")
    args = parser.parse_args()

    if args.simulate:
        print discrete_full_simulation(args.T, args.p, args.q, args.n, args.init)

    if args.generate_distribution:
        f = generate_distribution(args.T, args.p, args.q, args.n, args.init,
                                  args.start_index, args.end_index, args.step_iters)
        util.save_distribution(f, args.output_file)


if __name__ == "__main__":
    main()
