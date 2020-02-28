import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

r = np.array(pd.read_csv('initial_pos.xyz', header=None, skipinitialspace=True, sep=' ').values[:,:-1])

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.scatter(r[:,0],r[:,1],r[:,2])
plt.show()
