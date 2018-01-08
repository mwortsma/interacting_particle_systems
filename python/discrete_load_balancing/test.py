import numpy as np
import cPickle as pickle
import matplotlib.pyplot as plt

f_full = pickle.load( open( "data/f_full", "rb" ) )
f_local = pickle.load( open( "data/f_local", "rb" ) )

print(sum([f_full[v] for v in sorted(f_full.iterkeys())]))
print(sum([f_local[v] for v in sorted(f_local.iterkeys())]))

plt.plot(range(4**3), [f_full[v] for v in sorted(f_full.iterkeys())], 'r--', label='full')
plt.plot(range(4**3), [f_local[v] for v in sorted(f_local.iterkeys())], 'b--', label='local')
plt.legend(loc=2)
plt.savefig('full_vs_local.png')




