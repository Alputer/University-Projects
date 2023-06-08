#Replace µ = 0 and σ = 1. Then, we get --> P(|X| ≥ k) ≤ 1/k^2
#We expect P(|X| ≥ 2) ≤ 1/4
#We expect P(|X| ≥ 5) ≤ 1/25
#We expect P(|X| ≥ 10) ≤ 1/100
#Now run the simulation accordingly.
import numpy

size = 1000000
arr = numpy.random.standard_normal(size)
count1 = 0
count2 = 0
count3 = 0

for i in arr:
    i = abs(i)
    if(i >= 10 ):
        count1 += 1
        count2 += 1
        count3 += 1
    elif(i >= 5):
        count1 += 1
        count2 += 1
    elif(i >= 2):
        count1 += 1



result1 = count1 / size
result2 = count2 / size
result3 = count3 / size
print("We expect this number to be less than 0.25 -->", result1)
print("We expect this number to be less than 0.04 -->", result2)
print("We expect this number to be less than 0.01 -->", result3)