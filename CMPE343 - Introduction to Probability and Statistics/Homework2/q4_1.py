#import numpy
#import matplotlib.pyplot as plt
import math
import random

sum = 0
n = 100000


for _ in range(n):
    sum += math.cos(math.pi * random.random())


result = sum / n
print("We expect the result to be something very close to 0 -->  %.4f" % result)