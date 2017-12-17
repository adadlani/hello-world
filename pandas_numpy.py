# Script to demo Pandas and NumPy
import numpy as np
import pandas as pd

# Create a dataframe with some random data 
# (start_value, end_value, size=(rows, columns))
scores = pd.DataFrame(np.random.randint(0, 100, size=(5,4)), 
	columns=['q1','q2','q3','q4'], 
	index=['a1', 'a2', 'a3', 'a4', 'a5'])

# Create a dataframe with weights
weights = pd.DataFrame(np.random.randint(1,10, size=(1,4)), 
	columns=['w1', 'w2', 'w3', 'w4'],
	index=['w'])

# Debug
print(scores)
print(weights)

#print(dir(scores))
#.add, all, apply, applymap, columns, combineMult, count, cummax, cummin, get_value, get_values, index, iteritems
print(scores.add())