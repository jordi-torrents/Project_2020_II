import numpy as np
import matplotlib.pyplot as plt

temps = np.array([1612.8,1054.7,791.02,652.5,604.7])
workers=np.array([1,2,4,8,16])

fig, ax = plt.subplots()

ax.hlines(956,-5,30, ls=':', color='gray', label='Temps sequencial')
ax.plot(workers, temps,'.-', label='Temps paral·lel')
ax.set(xlim=(0,17), ylim=(0,1700), xlabel='N workers', ylabel='Time (s)')

plt.legend()
plt.tight_layout()
plt.savefig('temps_MPI.png', dpi=300)
