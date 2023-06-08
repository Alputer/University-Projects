import random

random.seed(1)

# puts a new queen at (row,col) location. Updates available matrix according to that.
# AvailMatrix is a nXn matrix having boolean variables that shows whether at that coordinate
# of the board a queen can be placed.
def updateAvailMatrix(matrix, row, col):
    n = len(matrix)
    for i in range(n):
        matrix[row][i] = False
        matrix[i][col] = False
    
    # diagonal that goes from top left to right bottom
    start = min(row, col)
    end = min(n-1-row, n-1-col)
    for i in range(-start, end+1):
        matrix[row+i][col+i] = False

    # diagonal that goes from top right to left bottom
    start = min(row, n-1-col)
    end = min(n-1-row, col)
    for i in range(-start, end+1):
        matrix[row+i][col-i] = False

# columns are the columns that queens are placed. Returns true if at (row,col) location, a new queen
# can be placed. Returns false, otherwise.
def canPlaced(columns, row, col):
    if len(columns) > row:
        return False
    
    for c in columns:
        if c == col:
            return False
        
    for i in range(len(columns)):
        y_dist = row - i
        if columns[i] + y_dist == col:
            return False
        elif columns[i] - y_dist == col:
            return False
    
    return True

# The LasVegas algorithm given in the description but additionally this function gets a file as an input
# and writes output to that file. This function returns a list representing columns on which queens are
# placed
def QueensLasVegas(n, file):
    column = []
    availColumns = [i for i in range(n)]
    availMatrix = [[True for _ in range(n)] for _ in range(n)]

    R = 0
    while R <= n-1 and len(availColumns) > 0:
        if(len(availColumns) == 0):
            break

        c_index = random.randint(0, len(availColumns)-1)
        C = availColumns[c_index]
        column.append(C)

        updateAvailMatrix(availMatrix, R, C)

        if R+1 <= n-1:
            availColumns = [i for i in range(n) if availMatrix[R+1][i]]
        else:
            availColumns = []

        file.write("Step {}: Columns: {}\n".format(R+1, column))
        file.write("Step {}: Available: {}\n".format(R+1, availColumns))

        R += 1
    if len(column) == n:
        file.write("Successful\n")
    else:
        file.write("Unsuccessful\n")
    file.write("...\n")

    return column

# This function handles operations needed for the first part of the project.
def executePart1(n, trials, file_name):
    success_count = 0 

    file = open(file_name, "w")

    for i in range(trials):
        result = QueensLasVegas(n, file)
        if len(result) == n:
            success_count += 1
    
    file.close()

    p = success_count / trials

    print("LasVegas Algorithm With n = {}".format(n))
    print("Number of successful placements is {}".format(success_count))
    print("number of trials is {}".format(trials))
    print("Probability that it will come to a solution is {}".format(p))
    print()


# This is a determenistic queen placement algorithm which is uses backtracking. There are already some queens are 
# placed in a chessboard. This function returns true, if there is a possible way to place remaining queens. Returns 
# false, otherwise.  
def deterministicQueens(n, row, availColumns, column):
    if n == len(column):
        return True

    for C in availColumns:
        column.append(C)
        tmpAvailColumns = []
        for i in range(n):
            if canPlaced(column, row+1, i):
                tmpAvailColumns.append(i)
        if deterministicQueens(n, row+1, tmpAvailColumns, column):
            return True
        column.pop()

    return False

# This function places k queens using Las Vegas algorithm and then checks whether there is at least one
# possible way of placing the remaining queens. If the answer is yes, returns true. Returns false, otherwise.
def QueensLasVegasWithK(n, k):
    column = []
    availColumns = [i for i in range(n)]

    if k > n:
        raise RuntimeError("Bad arguments, k <= n inequity should hold.")

    if n == k:
        return True

    # Repeating algorithm till we find a possible placement of k queens
    while len(column) != k:
        column = []
        availColumns = [i for i in range(n)]
        availMatrix = [[True for _ in range(n)] for _ in range(n)]

        R = 0

        while R < k and len(availColumns) > 0:
            if(len(availColumns) == 0):
                break

            c_index = random.randint(0, len(availColumns)-1)
            C = availColumns[c_index]
            column.append(C)

            updateAvailMatrix(availMatrix, R, C)

            if R+1 <= n-1:
                availColumns = [i for i in range(n) if availMatrix[R+1][i]]
            else:
                availColumns = []
            R += 1

    return deterministicQueens(n, k, availColumns, column)


# This function handles operations needed for the second part of the project.
def executePart2(n, k, trials):
    success_count = 0 

    for i in range(trials):
        result = QueensLasVegasWithK(n, k)
        if result:
            success_count += 1

    p = success_count / trials

    print("k is {}".format(k))
    print("Number of successful placements is {}".format(success_count))
    print("number of trials is {}".format(trials))
    print("Probability that it will come to a solution is {}".format(p))



# MAIN CODE #

mode = input()

if mode == "part1":
    executePart1(6, 10000, "result_6.txt")
    executePart1(8, 10000, "result_8.txt")
    executePart1(10, 10000, "result_10.txt")
elif mode == "part2":
    for n in [6, 8, 10]:
        print("------------{}------------".format(n))
        for k in range(n):
            executePart2(n, k, 10000)
        print()
else:
    print("Wrong argument is given. Terminating...")

