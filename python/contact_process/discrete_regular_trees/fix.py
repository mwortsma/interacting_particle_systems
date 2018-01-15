from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import os

import rt_full_simulation
import rt_local_approx
import rt_util

import time


def fix(d, T, p, q, iters, epsilon, steps, nu):
    start = time.time()

    info = 'd=%d_T=%d_p=%0.3f_q=%0.3f_steps=%0.1E' % (d, T, p, q, steps)
    name = 'plots/data_' + info
    parent = "./"
    directory = os.path.join(parent, name)

    opd = rt_util.pkl_get(os.path.join(directory,'local_one_particle.pkl'))
    full = rt_util.pkl_get(os.path.join(directory,'full_one_particle.pkl'))

    plt.plot([full[p] for p in rt_util.bin_tuples(T)], label='full')
    plt.plot([opd[p] for p in rt_util.bin_tuples(T)], label='local')
    plt.legend(loc=2)
    l1 = sum([abs(full[p] - opd[p]) for p in rt_util.bin_tuples(T)])
    info = ('L1 distance = %0.4f ' % l1) + info.replace("_", " ")
    plt.title(info)
    plt.xlabel('One Particle Path')
    plt.ylabel('Probability')
    plt.savefig(os.path.join(directory,"fig.png"))
    F = open(os.path.join(directory,"L1.txt"), "w")
    F.write('%f' % l1)
    F.close()

    F = open(os.path.join(directory,"time.txt"), "w")
    F.write('%f' % l1)
    F.close()

    end = time.time()
    F = open(os.path.join(directory,"time.txt"), "w")
    F.write('%f' % (end-start))
    F.close()




def main():
    args=rt_util.command_line_args()

    fix(args.d, args.T, args.p, args.q, args.iters,
            args.epsilon, args.steps, args.nu)


if __name__ == "__main__":
    main()
