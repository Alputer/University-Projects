import numpy
import matplotlib.pyplot as plt

arr1 = numpy.random.normal(-1,1,100000)
arr2 = numpy.random.normal(3,2,100000)
arr3 = arr1 + arr2


plt.hist(arr3)

plt.show()
