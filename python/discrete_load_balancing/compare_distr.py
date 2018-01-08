import numpy as np
import cPickle as pickle
import matplotlib.pyplot as plt

print 'opening'
f_local = pickle.load( open( "data/local_T=3_step_iters=10000000", "rb" ) )
f_local_one_particle = {}
print 'openend'

inc = 1.0/len(f_local)

z = 0.
l = len(f_local)
for k in f_local:
	X = np.reshape(np.fromstring(k), (3,7))
	st = X[:,0].tostring()
	if st not in f_local_one_particle: f_local_one_particle[st] = 0.0
	f_local_one_particle[st] += f_local[k]
	z += 1
	print z/l

f_full = pickle.load( open( "data/full_T=3_step_iters=100000", "rb" ) )


#diff = sum([abs(f_full[k] - f_local_one_particle[k]) for k in f_full])
#print(diff)

for k in sorted(f_local_one_particle.iterkeys()):
	print(np.fromstring(k))
	print(f_local_one_particle[k])
print('--')
for k in sorted(f_full.iterkeys()):
	print(np.fromstring(k))
	print(f_full[k])

T = 3
k = 4

Y = []
X = np.zeros((T))
for i in range(k**T):
	Y.append(X.tostring())
	for j in range(T):
		if X[-1-j] < k-1:
			X[-1-j] += 1
			break
		else:
			X[-1-j] = 0

for v in Y:
	if v not in f_full:
		f_full[v] = 0
	if v not in f_local_one_particle:
		f_local_one_particle[v] = 0

plt.plot([f_full[v] for v in Y])
plt.plot([f_local_one_particle[v] for v in Y])

pickle_out = open("data/f_full","wb")
pickle.dump(f_full, pickle_out)
pickle_out.close()

pickle_out = open("data/f_local","wb")
pickle.dump(f_local_one_particle, pickle_out)
pickle_out.close()

plt.show()


