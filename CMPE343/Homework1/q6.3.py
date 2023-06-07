import numpy
import matplotlib.pyplot as plt
import math


kl_divergence = 0
arr = numpy.random.normal(0,1,1000)

for num in arr:

    logarithmic_term = numpy.log(((math.exp(-(num**2)/2)) / (math.sqrt(2*math.pi))) / ((math.exp(-(num**2)/8)) / (2 * math.sqrt(2*math.pi)))) 
    kl_divergence += logarithmic_term

kl_divergence /= 1000

print(kl_divergence)