#0.8413 - 0.5000 = 0.3413
import numpy

size = 1000000
arr = numpy.random.standard_normal(size)
count = 0

for i in arr:
    if(i >= 0 and i <= 1):
        count += 1

result = count / size
print("We expect this number to be around 0.34 -->", result)