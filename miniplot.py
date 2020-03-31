import numpy as np
import matplotlib.pyplot as plt

temps1 = np.array([1670.6,1149.3,797.4,650.1,606.2,591.1,603.0,597.1])
temps2 = np.array([1803.3, 903.4,458.2,237.4,138.8, 74.4, 42.8, 30.1])
workers= np.array([     1,     2,    4,    8,   16,   32,   64,  128])
temps_seq=956

speedup1=temps1[0]/temps1
speedup2=temps2[0]/temps2

# speedup1=temps_seq/temps1
# speedup2=temps_seq/temps2

fig, ax = plt.subplots()
ax.hlines(temps_seq,-5,3000, ls=':', color='gray', label='Temps sequencial')
ax.plot(workers, temps1,'.-', label='Temps paral·lel Versió 1')
ax.plot(workers, temps2,'.-', label='Temps paral·lel Versió 2')
ax.set(xlim=(1,130), ylim=(10,1850), xlabel='N workers', ylabel='Time (s)',xscale='log', yscale='log')
plt.legend(loc=3)
plt.tight_layout()
plt.savefig('temps_MPI.png', dpi=300)

fig, ax = plt.subplots()
ax.plot([1,100],[1,100],'k:')
ax.plot(workers, speedup1,'.-', label='Temps paral·lel Versió 1')
ax.plot(workers, speedup2,'.-', label='Temps paral·lel Versió 2')
ax.set(xlim=(1,130), ylim=(1,100), xlabel='N workers', ylabel='Speedup',xscale='log', yscale='log')
plt.legend()
plt.tight_layout()
plt.savefig('speedup_MPI.png', dpi=300)
