import numpy as np
import cPickle as pickle
import matplotlib.pyplot as plt

f_local = pickle.load( open( "data/local_T=3_step_iters=1000000", "rb" ) )
f_local_one_particle = {}

inc = 1.0/len(f_local)

for k in f_local:
	X = np.reshape(np.fromstring(k), (3,7))
	st = X[:,0].tostring()
	if st not in f_local_one_particle: f_local_one_particle[st] = 0.0
	f_local_one_particle[st] += f_local[k]

f_full = pickle.load( open( "data/full_T=3_step_iters=10000", "rb" ) )


diff = sum([abs(f_full[k] - f_local_one_particle[k]) for k in f_full])
print(diff)

for k in sorted(f_local_one_particle.iterkeys()):
	print(np.fromstring(k))
	print(f_local_one_particle[k])
print('--')
for k in sorted(f_full.iterkeys()):
	print(np.fromstring(k))
	print(f_full[k])

plt.plot([f_full[v] for v in sorted(f_full.iterkeys())])
plt.plot([f_local_one_particle[v] for v in sorted(f_local_one_particle.iterkeys())])
plt.show()


