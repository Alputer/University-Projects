#Xi+1 = (aXi + c) mod(m) 

#m = 16381
#a = 665
#c = 3424
import math
import numpy
import matplotlib.pyplot as plt

size = 10000

# Below function generates pseudo-random array of numbers between 0 and 1.
# Size of the array is given as input and different seed values can be used.

############ Function for part A #######################
#Implementation of linear congruential generator
#I picked these constants from https://www.ams.org/journals/mcom/1999-68-225/S0025-5718-99-00996-5/S0025-5718-99-00996-5.pdf

def my_generate_rand_arr(seed, length):
    result = []
    curr = seed
    for _ in range(length):
        curr = (665*curr + 3424) % 16381
        result.append(curr / 16380)

    return result


my_uniform_arr1 = my_generate_rand_arr(1071, size) # Uniform distribution using my function
my_uniform_arr2 = my_generate_rand_arr(1453, size) # Uniform distribution using my function
prebuilt_uniform_arr1 = numpy.random.uniform(0,1,size) # Uniform distribution using prebuilt function
prebuilt_uniform_arr2 = numpy.random.uniform(0,1,size) # Uniform distribution using prebuilt function




my_standard_normal_arr1 = []
my_standard_normal_arr2 = []
prebuilt_standard_normal_arr1 = []
prebuilt_standard_normal_arr2 = []

##### In this for loop, I implement the equation given in the question #############
for i in range(10000):
    
    if(my_uniform_arr1[i] == 0):
        my_uniform_arr1[i] = 0.000000000001
    if(my_uniform_arr2[i] == 0):
        my_uniform_arr2[i] = 0.000000000001

    my_curr_num1 = math.sqrt(-2 * math.log(my_uniform_arr1[i])) * math.cos(2 * math.pi * my_uniform_arr2[i])
    my_curr_num2 = math.sqrt(-2 * math.log(my_uniform_arr1[i])) * math.sin(2 * math.pi * my_uniform_arr2[i])
    prebuilt_curr_num1 = math.sqrt(-2 * math.log(prebuilt_uniform_arr1[i])) * math.cos(2 * math.pi * prebuilt_uniform_arr2[i])
    prebuilt_curr_num2 = math.sqrt(-2 * math.log(prebuilt_uniform_arr1[i])) * math.sin(2 * math.pi * prebuilt_uniform_arr2[i])
    my_standard_normal_arr1.append(my_curr_num1)
    my_standard_normal_arr2.append(my_curr_num2)
    prebuilt_standard_normal_arr1.append(prebuilt_curr_num1)
    prebuilt_standard_normal_arr2.append(prebuilt_curr_num2)

############ IMPORTANT ################

# First and second give uniform distributions for Part-A.
# Third and forth lines give standard normal distribution using my uniform distributions.
# Fifth and sixth lines give standard normal distribution using pre-built uniform distributions.

#plt.hist(my_uniform_arr1) 
#plt.hist(my_uniform_arr2)
#plt.hist(my_standard_normal_arr1)
#plt.hist(my_standard_normal_arr2)
#plt.hist(prebuilt_standard_normal_arr1)
#plt.hist(prebuilt_standard_normal_arr2)
plt.show() 


