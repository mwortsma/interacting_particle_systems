from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import os

import rt_full_simulation
import rt_local_approx
import rt_util

import time


def compare(d, T, p, q, iters, epsilon, steps, nu):
    start = time.time()

    info = 'd=%d_T=%d_p=%0.3f_q=%0.3f_steps=%0.1E' % (d, T, p, q, steps)
    name = 'data/data_' + info
    parent = "./"
    rt_util.make_directory(parent, name)
    directory = os.path.join(parent, name)
    info_file = os.path.join(directory, "info")
    f, c, opd, res, op_res, bad = rt_local_approx.rt_local_approx(
        d, T, p, q, iters, epsilon, steps, nu, info_file)

    rt_util.pkl_save(f, os.path.join(directory, 'local_joint.pkl'))
    rt_util.pkl_save(c, os.path.join(directory, 'local_cond.pkl'))
    rt_util.pkl_save(opd, os.path.join(directory, 'local_one_particle.pkl'))
    rt_util.pkl_save(res, os.path.join(directory, 'local_joint_residual.pkl'))
    rt_util.pkl_save(op_res, os.path.join(
        directory, 'local_one_particle_residual.pkl'))

    full = rt_full_simulation.generate_distr(d, T, p, q, nu, steps)
    rt_util.pkl_save(full, os.path.join(directory, 'full_one_particle.pkl'))

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

    compare(args.d, args.T, args.p, args.q, args.iters,
            args.epsilon, args.steps, args.nu)


if __name__ == "__main__":
    main()
