import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import Axes3D

# file = open('gdr.log', 'r')
# lines = file.readline

r = np.array(pd.read_csv('gdr.log', header=None, usecols=[0,1], skipinitialspace=True, sep=' '))

# print(r)

fig = plt.figure()
plt.plot(r[:,0],r[:,1])
plt.show()
