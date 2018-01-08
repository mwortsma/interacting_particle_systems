import argparse
import cPickle as pickle
import numpy as np
import matplotlib.pyplot as plt
import full
import mean_field
import util
import graphs

args = util.command_line_args()

G, k = graphs.get_graph("ring", args.n)

f_full_ring= full.generate_distribution(G, k,
                                    args.T, args.p, args.q, args.n, args.init, args.start_index, args.end_index, args.step_iters)
f_mean_field_ring = mean_field.generate_distribution(G, k,
                                                args.T, args.p, args.q, args.init, args.step_iters)

G, k = graphs.get_graph("complete", args.n)

f_full_complete = full.generate_distribution(G, k,
                                    args.T, args.p, args.q, args.n, args.init, args.start_index, args.end_index, args.step_iters)
f_mean_field_complete = mean_field.generate_distribution(G, k,
                                                args.T, args.p, args.q, args.init, args.step_iters)


y1 = util.plot_distribution(f_full_ring, args.T, "full (ring)")
y2 = util.plot_distribution(f_mean_field_ring, args.T, "mean field (ring)")

y3 = util.plot_distribution(f_full_complete, args.T, "full (complete)")
y4 = util.plot_distribution(f_mean_field_complete, args.T, "mean field (complete)")

plt.legend(loc=2)
title = 'mean_field_vs_full_n=%d_p=%f_q=%f.png' % (args.n, args.p, args.q)
plt.title(title)
# plt.show()
plt.savefig('fig/' + title)

print(title)
print("ring")
print(np.linalg.norm(y1 - y2))
print("complete")
print(np.linalg.norm(y3 - y4))
print("difference in mean fields")
print(np.linalg.norm(y2- y4))
print("difference in fulls")
print(np.linalg.norm(y1- y3))
