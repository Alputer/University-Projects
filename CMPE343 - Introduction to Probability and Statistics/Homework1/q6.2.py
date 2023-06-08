import numpy
import matplotlib.pyplot as plt

arr1 = [5, 10, 20, 30, 40, 100]
arr2 = [0.2 , 0.33, 0.5]

for n in arr1:
    for p in arr2:


        arr3 = numpy.random.binomial(n,p,10000)
        arr4 = numpy.random.normal(n*p,n*p*(1-p),10000)

        plt.figure()
        plt.hist(arr3)
        plt.hist(arr4)

        plt.show()