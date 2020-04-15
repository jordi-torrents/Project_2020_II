import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

nproc, time1 = pd.read_csv('ts_test/speedup1k.log',header=None, sep='\s+').T.values
nproc, time2 = pd.read_csv('ts_test/speedup2k.log',header=None, sep='\s+').T.values
nproc, time3 = pd.read_csv('ts_test/speedup3k.log',header=None, sep='\s+').T.values
nproc, time4 = pd.read_csv('ts_test/speedup4k.log',header=None, sep='\s+').T.values
time_seq1 =  493.2708*np.ones_like(nproc)
time_seq2 = 1891.4422*np.ones_like(nproc)
time_seq3 = 4206.4909*np.ones_like(nproc)
time_seq4 = 7405.5548*np.ones_like(nproc)

speedup1=time1[0]/time1
speedup2=time2[0]/time2
speedup3=time3[0]/time3
speedup4=time4[0]/time4

fig, ax = plt.subplots()
ax.vlines(2,10,15000,'gray',':', label='Sequential times')
ax.plot(nproc, time1,'C0-', label='1000 Particles')
ax.plot(nproc, time_seq1,'C0:')
ax.plot(nproc, time2,'C1-', label='2000 Particles')
ax.plot(nproc, time_seq2,'C1:')
ax.plot(nproc, time3,'C2-', label='3000 Particles')
ax.plot(nproc, time_seq3,'C2:')
ax.plot(nproc, time4,'C3-', label='4000 Particles')
ax.plot(nproc, time_seq4,'C3:')
ax.set(xlim=(nproc[0],nproc[-1]), ylim=(10,15000), xlabel='N workers', ylabel='Time (s)',xscale='log', yscale='log')
plt.xticks((1,2,10,100,400),('1','2','10','100','400'))
plt.legend(loc=1)
plt.tight_layout()
plt.savefig('temps_MPI.png', dpi=300)
# plt.show()

fig, ax = plt.subplots()
ax.plot([1,500],[1,500],'k:')
ax.plot(nproc, speedup1,'-', label='1000 Particles')
ax.plot(nproc, speedup2,'-', label='2000 Particles')
ax.plot(nproc, speedup3,'-', label='3000 Particles')
ax.plot(nproc, speedup4,'-', label='4000 Particles')
ax.set(xlim=(nproc[0],nproc[-1]), ylim=(nproc[0],nproc[-1]), xlabel='N workers', ylabel='Speedup',xscale='log', yscale='log')
plt.legend()
plt.xticks((1,10,100,400),('1','10','100','400'))
plt.tight_layout()
plt.savefig('speedup_MPI.png', dpi=300)



fig, axs = plt.subplots(2,2)

nproc_old, time_old1 = pd.read_csv('ts_test/algoritme_antic/speedup1k.log',header=None, sep='\s+').T.values
nproc_old, time_old2 = pd.read_csv('ts_test/algoritme_antic/speedup2k.log',header=None, sep='\s+').T.values
nproc_old, time_old3 = pd.read_csv('ts_test/algoritme_antic/speedup3k.log',header=None, sep='\s+').T.values
nproc_old, time_old4 = pd.read_csv('ts_test/algoritme_antic/speedup4k.log',header=None, sep='\s+').T.values

axs[0,0].set(title='1000 Particles')
axs[0,0].plot(nproc,time1, label='New Algorithm')
axs[0,0].plot(nproc_old,time_old1, label='Old Algorithm')
axs[0,0].legend()
axs[0,1].set(title='2000 Particles')
axs[0,1].plot(nproc,time2)
axs[0,1].plot(nproc_old,time_old2)
axs[1,0].set(title='3000 Particles')
axs[1,0].plot(nproc,time3)
axs[1,0].plot(nproc_old,time_old3)
axs[1,1].set(title='4000 Particles')
axs[1,1].plot(nproc,time4)
axs[1,1].plot(nproc_old,time_old4)

for ax in axs.flatten():
    ax.set(xlabel='N workers', ylabel='time (s)', xlim=(1,100), ylim=(10,20000), xscale='log', yscale='log')

plt.tight_layout()
plt.savefig('comparacio.png')
