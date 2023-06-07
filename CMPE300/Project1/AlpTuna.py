import random
import time

# returns average case input list of lenght size
def createAverageInput(size):
    return [1 if random.random() > 1/3 else 0 for _ in range(size)]

# returns best case input list of lenght size
def createBestInput(size):
    return [0 for _ in range(size)]

# returns worst case input list of lenght size
def createWorstInput(size):
    return [1 for _ in range(size)]

# The given algorithm
def Example(X):
    n = len(X)
    y = 0
    for i in range(n):
        if X[i] == 0:
            for j in range(i, n):
                k = n
                while k > 1:
                    y = y + 1
                    k = k//2
        else:
            for m in range(i, n):
                for t in range(1, n+1):
                    x = n
                    while x > 0:
                        x = x - t
                        y = y + 1
    return y


# Executes the algorithm and returns the elapsed time
def executeTheAlgorithm(size, inputFunction):
    input_list = inputFunction(size)
    start_time = time.time()
    result = Example(input_list)
    elapsed_time = time.time() - start_time
    return elapsed_time

# Returns average elapsed time of execution given many times 
def executeManyTimes(size, inputFunction, times):
    summ = 0
    for i in range(times):
        summ += executeTheAlgorithm(size, inputFunction)
    return summ/times


# MAIN CODE PART

case_sizes = [1, 10, 50, 100, 200, 300, 400, 500, 600, 700]

for size in case_sizes:
    elapsed_time = executeTheAlgorithm(size, createBestInput)
    print("Case:", "best", "Size:", size, "Elapsed Time:", elapsed_time)
for size in case_sizes:
    elapsed_time = executeTheAlgorithm(size, createWorstInput)
    print("Case:", "worst", "Size:", size, "Elapsed Time:", elapsed_time)
for size in case_sizes:
    elapsed_time = executeManyTimes(size, createAverageInput,3)
    print("Case:", "average", "Size:", size, "Elapsed Time:", elapsed_time)
