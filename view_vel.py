import matplotlib.pyplot as plt
import numpy as np

file = open('initial_vel.xyz','r')
line= file.readline()
vel_matrix=[]
vel_array=[]
while line:
    at =[]
    coord_x , coord_y , coord_z = line.split()
    coord_x = float(coord_x); at.append(coord_x)
    coord_y = float(coord_y); at.append(coord_y)
    coord_z = float(coord_z); at.append(coord_z)
    vel_array.append(coord_x)
    vel_array.append(coord_y)
    vel_array.append(coord_z)
    vel_matrix.append(at)    
    line = file.readline()
vel_matrix = np.array(vel_matrix)
vel_array = np.array(vel_array)
plt.hist(vel_array,bins=30)
plt.show()
