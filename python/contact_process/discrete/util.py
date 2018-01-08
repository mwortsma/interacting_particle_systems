import argparse
import cPickle as pickle
import numpy as np
import matplotlib.pyplot as plt


def save_distribution(f, output_file):
    pickle.dump(f, open(output_file, "wb"))


def load_distribution(file):
    return pickle.load(open(file, "rb"))


def plot_distribution(f, T, title=None):
    y = []
    for i in range(2**T):
        dec = np.array(list(np.binary_repr(i).zfill(T))).astype(np.float)
        if dec.tostring() not in f:
            y.append(0)
        else:
            y.append(f[dec.tostring()])
    if title:
        plt.plot(y, label=title)
    else:
        plt.plot(y)
    return np.array(y)


def command_line_args():
    parser = argparse.ArgumentParser(
        description='Discrete Contact Process (Ring)')
    parser.add_argument('--simulate', action="store_true", default=False)
    parser.add_argument('-T', action="store", default=4, type=int)
    parser.add_argument('-p', action="store", default=(2.0 / 3), type=float)
    parser.add_argument('-q', action="store", default=(1.0 / 3), type=float)
    parser.add_argument('-n', action="store", default=5, type=int)
    parser.add_argument('--init', action="store", default=0.5, type=float)
    parser.add_argument('--graph', action="store", default="ring")
    parser.add_argument('--generate_distribution',
                        action="store_true", default=False)
    parser.add_argument('--start_index', action="store", default=0, type=int)
    parser.add_argument('--end_index', action="store", default=1, type=int)
    parser.add_argument('--step_iters', action="store",
                        default=100000, type=int)
    parser.add_argument('--file', action="store", default="out.txt")
    parser.add_argument('--plot', action="store_true", default=False)
    return parser.parse_args()


def main():

    args = command_line_args()

    if args.plot:
        f = load_distribution(args.file)
        plot_distribution(f, args.T)
        plt.show()

if __name__ == "__main__":
    main()
