walls="x xxx x   x    x   xxx  x   xx x x   xx x"
sensors=["on", "on", "on", "off", "off", "on", "off", "off", "off"]
widthOfMap = len(walls)
roundNum = len(sensors)
probabilities = [1/widthOfMap] * widthOfMap



def normalize(list):
    sum = 0
    for i in list:
        sum += i
    for i in range(len(list)):
        list[i] /= sum
    return list


for i in range(roundNum): #Calculate the probabilities after each round
    for j in range(widthOfMap): #Calculate the possibility for each position after sensor information
        sensor = sensors[i]
        isThereWall = walls[j] == 'x'
        if(sensor == "on"):
            if(isThereWall):
                probabilities[j] *= 7/9
            else:
                probabilities[j] *= 2/9
        elif(sensor == "off"):
            if(isThereWall):
                probabilities[j] *= 3/11
            else:
                probabilities[j] *= 8/11

    probabilities_copy = probabilities.copy()

    for j in range(widthOfMap): #Calculate the possibility for each position after right actuation
        index = j+1 #Index in our map

        if(index == 1):
            probabilities[0] *= 0.4
            continue

        if(index == widthOfMap):
            if(index%2 == 1): #Odd number 
                probabilities[j] = (probabilities_copy[j] * 1) + (probabilities_copy[j-1] * 0.8)
            elif(index%2 == 0): #Even number
                probabilities[j] = (probabilities_copy[j] * 1) + (probabilities_copy[j-1] * 0.6)
            continue

        if(index%2 == 1): #Odd number 
            probabilities[j] = (probabilities_copy[j] * 0.4) + (probabilities_copy[j-1] * 0.8)
        elif(index%2 == 0): #Even number
            probabilities[j] = (probabilities_copy[j] * 0.2) + (probabilities_copy[j-1] * 0.6) 


#Normalization code
probabilities = normalize(probabilities)

#Find the most probable one
robot_pos = -1
robot_pos_prob = -1
for i in range(len(probabilities)):
    if(probabilities[i] > robot_pos_prob):
        robot_pos = i+1
        robot_pos_prob = probabilities[i]

print('The most likely current position of the robot is',robot_pos,'with probability',robot_pos_prob)