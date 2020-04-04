import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

nproc, time1 = pd.read_csv('ts_test/speedup1k.log',header=None, sep='\s+').T.values
nproc, time2 = pd.read_csv('ts_test/speedup2k.log',header=None, sep='\s+').T.values
nproc, time3 = pd.read_csv('ts_test/speedup3k.log',header=None, sep='\s+').T.values
nproc, time4 = pd.read_csv('ts_test/speedup4k.log',header=None, sep='\s+').T.values
time_seq1 =  493.2708*np.ones_like(nproc)
time_seq2 = 1891.4422*np.ones_like(nproc)
time_seq3 = 1*np.ones_like(nproc)
time_seq4 = 1*np.ones_like(nproc)

speedup1=time1[0]/time1
speedup2=time2[0]/time2
speedup3=time3[0]/time3
speedup4=time4[0]/time4

fig, ax = plt.subplots()
ax.vlines(2,10,15000,'gray',':')
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
plt.legend()
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
