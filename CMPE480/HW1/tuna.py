import sys
import copy
from collections import deque
from queue import PriorityQueue
import requests
search_list=["BFS","DFS","UCS","GS","A*","A*2"]
search= "BFS"
target_url="https://www.cmpe.boun.edu.tr/~emre/courses/cmpe480/hw1/input.txt"
txt = requests.get(target_url).text
univ_count = 1

class Node:
    def __init__(self, grid, positions, history, cost, row, col, pig, direction, count):
        self.grid = grid
        self.positions = positions
        self.history = history
        self.cost = cost
        self.row = row
        self.col = col
        self.pig = pig #Letter of the previous pig, to decide tie-breaking
        self.direction = direction
        self.count = count
    
    def __str__(self):
        return f"Path cost: {self.cost}\nSolution:{self.history}"

    #Wrong comparison logic but we use min priority queue. So it works in the end.
    def __gt__(self, node2):
        if(search == "UCS"):
            if(self.cost != node2.cost):
                return self.cost > node2.cost

        elif(search == "GS"):
            if(min(self.row, self.col) != min(node2.row, node2.col)):
                return min(self.row, self.col) > min(node2.row, node2.col)
        elif(search == "A*"):
            if(self.cost + min(self.row, self.col) != node2.cost + min(node2.row, node2.col)):
                return self.cost + min(self.row, self.col) > node2.cost + min(node2.row, node2.col)
        elif(search == "A*2"):
            if(self.cost + min(2 * self.row, self.col) != node2.cost + min(2 * node2.row, node2.col)):
                return self.cost + min(2 * self.row, self.col) > node2.cost + min(2 * node2.row, node2.col)

        if(ord(self.pig) != ord(node2.pig)):
            return ord(self.pig) > ord(node2.pig)

        if(self.direction == node2.direction):
            return self.count > node2.count #Entrance priority

        if(self.direction == "U"):
            return True
        if(self.direction == "R" and node2.direction != "U"):
            return True
        if(self.direction == "L"):
            return False
        if(self.direction == "D" and node2.direction != "L"):
            return False
            
        return True # Dummy return


# Prints the grid
def print_grid(grid):
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            print(grid[i][j], end="")
        print()

def isGoal(node):
    return len(node.positions) == 1

def canMoveUp(node, pig):
    coord = node.positions[pig]
    row = coord[0]
    col = coord[1]
    if(row == 0 or row == 1):
        return False
    if(node.grid[row-1][col] == '.'):
        return False

    row -= 2
    while(row >= 0):
        if(node.grid[row][col] == '.'):
            return True
        row -= 1

    return False

def canMoveDown(node, pig):
    coord = node.positions[pig]
    row = coord[0]
    col = coord[1]
    if(row == len(node.grid)-1 or row == len(node.grid)-2):
        return False
    if(node.grid[row+1][col] == '.'):
        return False

    row += 2
    while(row <= len(node.grid)-1):
        if(node.grid[row][col] == '.'):
            return True
        row += 1
        
    return False

def canMoveLeft(node, pig):
    coord = node.positions[pig]
    row = coord[0]
    col = coord[1]
    if(col == 0 or col == 1):
        return False
    if(node.grid[row][col-1] == '.'):
        return False

    col -= 2
    while(col >= 0):
        if(node.grid[row][col] == '.'):
            return True
        col -= 1

    return False

def canMoveRight(node, pig):

    coord = node.positions[pig]
    row = coord[0]
    col = coord[1]
    #print(col)
    if(col == len(node.grid[0])-1 or col == len(node.grid[0])-2):
        return False
    if(node.grid[row][col+1] == '.'):
        return False

    col += 2
    while(col <= len(node.grid[0])-1):
        if(node.grid[row][col] == '.'):
            return True
        col += 1
        
    return False

def moveUp(node, pig): #pig is letter
    newGrid = copy.deepcopy(node.grid)
    newPositions = copy.deepcopy(node.positions)
    coord = newPositions[pig]
    row = coord[0]
    col = coord[1]
    newGrid[row][col] = '.'
    row -= 1

    while(newGrid[row][col] != '.'):
        del newPositions[newGrid[row][col]] # delete by value
        newGrid[row][col] = '.'
        row -= 1
    
    
    newGrid[row][col] = pig
    newPositions[pig] = [row, col]
    newHistory = node.history
    newHistory += "" if(len(node.history) == 0) else "," #add comma or not
    newHistory += f" {pig} up"

    row_count = 0
    for i in range(len(newGrid)):
        for j in range(len(newGrid[0])):
            if(newGrid[i][j] != "."):
                row_count += 1
                break
    global univ_count
    univ_count += 1
    return Node(newGrid, newPositions, newHistory, node.cost + 1, row_count, node.col, pig, "U", univ_count - 1)

def moveDown(node, pig): #pig is letter
    newGrid = copy.deepcopy(node.grid)
    newPositions = copy.deepcopy(node.positions)
    coord = newPositions[pig]
    row = coord[0]
    col = coord[1]
    newGrid[row][col] = '.'
    row += 1

    while(newGrid[row][col] != '.'):
        del newPositions[newGrid[row][col]] # delete by value
        newGrid[row][col] = '.'
        row += 1

    
    
    newGrid[row][col] = pig
    newPositions[pig] = [row, col]
    newHistory = node.history
    newHistory += "" if(len(node.history) == 0) else "," #add comma or not
    newHistory += f" {pig} down"

    row_count = 0
    for i in range(len(newGrid)):
        for j in range(len(newGrid[0])):
            if(newGrid[i][j] != "."):
                row_count += 1
                break

    global univ_count
    univ_count += 1
    return Node(newGrid, newPositions, newHistory, node.cost + 3, row_count, node.col, pig, "D", univ_count - 1)

def moveLeft(node, pig): #pig is letter
    newGrid = copy.deepcopy(node.grid)
    newPositions = copy.deepcopy(node.positions)
    coord = newPositions[pig]
    row = coord[0]
    col = coord[1]
    newGrid[row][col] = '.'
    col -= 1

    while(newGrid[row][col] != '.'):
        del newPositions[newGrid[row][col]] # delete by value
        newGrid[row][col] = '.'
        col -= 1
    
    
    newGrid[row][col] = pig
    newPositions[pig] = [row, col]
    newHistory = node.history
    newHistory += "" if(len(node.history) == 0) else "," #add comma or not
    newHistory += f" {pig} left"

    col_count = 0
    for i in range(len(newGrid[0])):
        for j in range(len(newGrid)):
            if(newGrid[j][i] != "."):
                col_count += 1
                break
    global univ_count
    univ_count += 1 
    return Node(newGrid, newPositions, newHistory, node.cost + 4, node.row, col_count, pig, "L", univ_count - 1)

def moveRight(node, pig): #pig is letter
    newGrid = copy.deepcopy(node.grid)
    newPositions = copy.deepcopy(node.positions)
    coord = newPositions[pig]
    row = coord[0]
    col = coord[1]
    newGrid[row][col] = '.'
    col += 1

    while(newGrid[row][col] != '.'):
        del newPositions[newGrid[row][col]] # delete by value
        newGrid[row][col] = '.'
        col += 1

    
    newGrid[row][col] = pig
    newPositions[pig] = [row, col]
    newHistory = node.history
    newHistory += "" if(len(node.history) == 0) else "," #add comma or not
    newHistory += f" {pig} right"

    col_count = 0
    for i in range(len(newGrid[0])):
        for j in range(len(newGrid)):
            if(newGrid[j][i] != "."):
                col_count += 1
                break
    global univ_count
    univ_count += 1
    return Node(newGrid, newPositions, newHistory, node.cost + 2, node.row, col_count, pig, "R", univ_count - 1)


if __name__ == '__main__':


    lines = txt.split("\n")
    for i in range(len(lines)):
        lines[i] = list(lines[i])
    lines.pop()
    
    R = len(lines)
    C = len(lines[0])
    row = 0
    col = 0
    for line in lines:
        for ch in line:
            if ch != ".":
                row += 1
                break
    for i in range(len(lines[0])):
        for j in range(len(lines)):
            if lines[j][i] != ".":
                col += 1
                break

    positions = dict()
    for i in range(len(lines)):
        for j in range(len(lines[0])):
            if(lines[i][j] != "."):
                positions[lines[i][j]] = [i,j]


    #positions = {'a': [4,2], 'b': [3,2], 'c': [2,2], 'd': [1,2], 'e': [4,3], 'f': [3,3], 'g': [2,3], 'h': [1,3]} #Sorted according to letter names.
    #positions = {'a': [6,3], 'b': [6,4]} #Sorted according to letter names.
    numOfNodesVisited = 0
    grid = lines
    #print(grid)
    #print(R)
    #print(C)
    #print(row)
    #print(col)
    #grid = [[".",".",".",".",".",".",".","."],
    #    [".",".",".",".",".",".",".","."],
    #    [".",".",".",".",".",".",".","."],
    #    [".",".",".",".",".",".",".","."],
    #    [".",".",".",".",".",".",".","."],
    #    [".",".",".",".",".",".",".","."],
    #    [".",".",".","a","b",".",".","."],
    #    [".",".",".",".",".",".",".","."]]


    headNode = Node(grid, positions, "", 0, row, col, "", "", 0)

    if(search == "DFS"):

        fringe = [headNode]

        while(len(fringe) != 0):
            currNode = fringe.pop()
            numOfNodesVisited += 1

            if(isGoal(currNode)):
                print(f"Number of removed nodes: {numOfNodesVisited}")
                print(currNode)
                sys.exit(0)
        
            keys = PriorityQueue() # returns all pigs
            for key in currNode.positions.keys():
                keys.put(key)
            while(not keys.empty()):
                pig = keys.get()
                if(canMoveLeft(currNode, pig)):
                    fringe.append(moveLeft(currNode, pig))
                if(canMoveDown(currNode, pig)):
                    fringe.append(moveDown(currNode, pig))
                if(canMoveRight(currNode, pig)):
                    fringe.append(moveRight(currNode, pig))
                if(canMoveUp(currNode, pig)):
                    fringe.append(moveUp(currNode, pig)) 
                           
    elif(search == "BFS"):
        fringe = deque()
        fringe.append(headNode)

        while(len(fringe) != 0):
            currNode = fringe.popleft()
            numOfNodesVisited += 1

            if(isGoal(currNode)):
                print(f"Number of removed nodes: {numOfNodesVisited}")
                print(currNode)
                sys.exit(0)
        
            keys = PriorityQueue() # returns all pigs
            for key in currNode.positions.keys():
                keys.put(key)
            while(not keys.empty()):
                pig = keys.get()
                if(canMoveLeft(currNode, pig)):
                    fringe.append(moveLeft(currNode, pig))
                if(canMoveDown(currNode, pig)):
                    fringe.append(moveDown(currNode, pig))
                if(canMoveRight(currNode, pig)):
                    fringe.append(moveRight(currNode, pig))
                if(canMoveUp(currNode, pig)):
                    fringe.append(moveUp(currNode, pig)) 

    elif(search == "UCS" or search == "GS" or search == "A*" or search == "A*2"):
        fringe = PriorityQueue()
        fringe.put(headNode)

        while(not fringe.empty()):
            currNode = fringe.get()
            numOfNodesVisited += 1
            #print(currNode.grid)
            #print(currNode.row)
            #print(currNode.col)
            #print(currNode.cost)
            #print(currNode.count)

            if(isGoal(currNode)):
                print(f"Number of removed nodes: {numOfNodesVisited}")
                print(currNode)
                sys.exit(0)
        
            
            keys = PriorityQueue() # returns all pigs
            for key in currNode.positions.keys():
                keys.put(key)
            while(not keys.empty()):
                pig = keys.get()
                if(canMoveLeft(currNode, pig)):
                    fringe.put(moveLeft(currNode, pig))
                if(canMoveDown(currNode, pig)):
                    fringe.put(moveDown(currNode, pig))
                if(canMoveRight(currNode, pig)):
                    fringe.put(moveRight(currNode, pig))
                if(canMoveUp(currNode, pig)):
                    fringe.put(moveUp(currNode, pig))

       
        
        

        


