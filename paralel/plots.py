import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

r, gdr = pd.read_csv('output/gdr.log',header=None, sep='\s+').T.values
time,temp,e_kin,e_pot,e_tot,press = pd.read_csv('output/results.log',header=0, sep='\s+').T.values

fig, ax = plt.subplots(1, dpi=200)
ax.vlines(2.628,0,15,'gray',':')
ax.hlines(1,0,15,'gray',':')
ax.plot(r,gdr, lw=1)
ax.set(xlim=(r[0],r[-1]), ylim=(0,1.55), xlabel='r [$\AA$]', ylabel='Radial distribution function')
plt.xticks((2,2.628,4,6,8,10),('2','$\sigma$','4','6','8','10'))
plt.tight_layout()
plt.savefig('output/gdr.png')


fig, ax = plt.subplots(1, dpi=200)
ax.plot(time,e_kin, label='Kinetic Energy')
ax.plot(time,e_pot, label='Potential Energy')
ax.plot(time,e_tot, label='Total Energy')
ax.set(xlim=(time[0],time[-1]), xlabel='time [ps]', ylabel='Energy (kJ/mol)')
ax.legend()
plt.tight_layout()
plt.savefig('output/energies.png')

fig, ax = plt.subplots(1, dpi=200)
ax.plot(time,temp, lw=1)
ax.plot([0,999],[300,300],'k:')
ax.set(xlim=(time[0],time[-1]), xlabel='time [ps]', ylabel='Temperature [Kelvin]')
plt.tight_layout()
plt.savefig('output/temperature.png')

fig, ax = plt.subplots(1, dpi=200)
ax.plot(time,press, lw=1)
ax.set(xlim=(time[0],time[-1]), xlabel='time [ps]', ylabel='MPa')
plt.tight_layout()
plt.savefig('output/pressure.png')

