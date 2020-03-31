import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

r, gdr = pd.read_csv('output/gdr.log',header=None, sep='\s+').T.values
time,temp,e_kin,e_pot,e_tot,press = pd.read_csv('output/results.log',header=0, sep='\s+').T.values

fig, ax = plt.subplots(1, dpi=200)
ax.hlines(1,0,15,'gray',':')
ax.plot(r,gdr, lw=1)
ax.set(xlim=(r[0],r[-1]), ylim=(0,1.55), xlabel='r {$\AA$}', ylabel='Radial distribution function')
plt.tight_layout()
plt.savefig('output/gdr.png')


fig, ax = plt.subplots(1, dpi=200)
ax.plot(time,e_kin, label='Kinetic Energy')
ax.plot(time,e_pot, label='Potential Energy')
ax.plot(time,e_tot, label='Total Energy')
ax.set(xlim=(time[0],time[-1]), xlabel='time {ps}', ylabel='kJ/mol')
ax.legend()
plt.tight_layout()
plt.savefig('output/energies.png')

fig, ax = plt.subplots(1, dpi=200)
ax.hlines(300,0,15,'gray',':')
ax.plot(time,temp, lw=1)
ax.set(xlim=(time[0],time[-1]), xlabel='time {ps}', ylabel='Kelvin', title='Temperature')
plt.tight_layout()
plt.savefig('output/temperature.png')

fig, ax = plt.subplots(1, dpi=200)
ax.plot(time,press*1.e-6, lw=1)
ax.set(xlim=(time[0],time[-1]), xlabel='time {ps}', ylabel='MPa')
plt.tight_layout()
plt.savefig('output/pressure.png')
