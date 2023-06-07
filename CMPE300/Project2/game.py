# Authors: Alp Tuna     2019400288
#          Mustafa Atay 2020400333
# Compiling and Working
# can run with
# mpiexec -n [N] python3 game.py [input] [output]

from mpi4py import MPI
import sys

comm = MPI.COMM_WORLD #Just an API requirement
size = comm.Get_size() # Get the size of the community
rank = comm.Get_rank() # Get the rank of the current process
p_num = size-1 #we discard the manager process


if(rank == 0): # we are in manager process

    infile = open(sys.argv[1], "r")
    outfile = open(sys.argv[2], "w")
    first_line = infile.readline().split(" ")
    N = int(first_line[0]) #size of the map
    W = int(first_line[1]) #number of waves
    T = int(first_line[2]) #number of towers to be placed per wave

    
    coord_list = []
    for i in range(2*W):
        coord_list.append(infile.readline())


    coords_to_be_sent = {} # num : list --> num represents process num, list represents the data
    for i in range(p_num):
        coords_to_be_sent[i+1] = [N,W,T] #It is a nice idea to send these info as well.

    for i in range(2*W):
        process_to_sent = 0
        curr_line = coord_list[i].split(",")
        
        for j in range(2*T):
            #curr_coordinate = int(coord_list[i][(2*j) + (j//2)])
            curr_list = curr_line[j//2].strip().split(" ") 
            curr_coordinate = int(curr_list[j%2])
            if(j%2 == 0):
                process_to_sent = ((curr_coordinate)//(N // p_num)) + 1
            coords_to_be_sent[process_to_sent].append(curr_coordinate)
        for k in range(p_num):
            coords_to_be_sent[k+1].append('-')


    #print("coords_to_be_sent -->", coords_to_be_sent)
    for process in coords_to_be_sent:
        comm.send(coords_to_be_sent[process], dest=process, tag=1)

    result = []
    for i in range(p_num):
        curr_data = comm.recv(source=i+1, tag=2)
        result.append(curr_data)

#Below part is the output writing part. Our result is in result array and we simply print them.

    for i in range(p_num): #number of p_num
        for j in range(N//p_num):
            for k in range(N):
                if(k == N-1):
                    if(result[i][j][k] == 0):
                        outfile.write(".")
                    elif(result[i][j][k] == 1):
                        outfile.write("o")
                    else: 
                        outfile.write("+")
                else:
                    if(result[i][j][k] == 0):
                        outfile.write(". ")
                    elif(result[i][j][k] == 1):
                        outfile.write("o ")
                    else:
                        outfile.write("+ ")
            if((i+1)*(j+1) < N):            
                outfile.write("\n")

# We close the files in the end.

    infile.close()
    outfile.close()

else: #We are in actual processes which do the simulation.

    tower_arr = [] # 0 represents dot, 1 represents "o" tower, 2 represents "+" tower.
    health_arr = [] # Keeps the health of each tower.

    data = comm.recv(source=0, tag=1) # initial receive of the data from manager process
    #Below variables are the same names as given in the description.
    N = data[0]
    W = data[1]
    T = data[2]

    height = N // p_num #Height of the area given to one process 
    width = N #Width of the area given to one process 

    #Initial configurations begore starting simulation. 

    for i in range(height):
        health_arr.append([])
        tower_arr.append([])
        for j in range(N):
            health_arr[i].append(0)
            tower_arr[i].append(0)

#Initial configurations of the main arrays before starting simulation. 
#We receive the whole data in one step. Below loop is hard to understand.
#We used some indexing we have created and sent the data accordingly in one step.
#util_list simply includes the coordinates of the 

    util_list = [] #Keeps the coordinates of the towers.
    curr_wave = []
    for coord in data[3:]:
        if(coord == '-'):
            util_list.append(curr_wave)
            curr_wave = []
            continue
        curr_wave.append(coord)
    

    #Now, we set up the initial configurations and now ready to begin simulation.

    ###########   Our simulation starts here  ################

    for i in range(W):

        for j in range(len(util_list[2*i]) // 2): # "o" towers
            x_coord = util_list[2*i][2*j]
            y_coord = util_list[2*i][(2*j)+1] 
            if(tower_arr[x_coord % height][y_coord] == 0): #If there is not a tower, put it into map. Otherwise, don't put it into map.
                tower_arr[x_coord % height][y_coord] = 1 
                health_arr[x_coord % height][y_coord] = 6
        for k in range(len(util_list[(2*i)+1]) // 2): # "+" towers
            x_coord = util_list[(2*i)+1][2*k]
            y_coord = util_list[(2*i)+1][(2*k)+1]
            if(tower_arr[x_coord % height][y_coord] == 0): # If there is not a tower, put it into map. Otherwise, don't put it into map.
                tower_arr[x_coord % height][y_coord] = 2
                health_arr[x_coord % height][y_coord] = 8

        #Initial configurations are made for wave. Now it is time to start next 8 round!

        if(rank%2 == 1): #odd numbered processes
            data_above = [] 
            data_below = []

            ###### Our basic operation is here. Since communication overhead between interprocess communication is the highest concern.
            ##Just simulate 8 rounds serially.

            for round_num in range(8):
                #send above --> tower_arr[0]
                if(rank > 1):
                    comm.send(tower_arr[0], dest=rank-1, tag=1)

                #send below --> tower_arr[len(tower_arr)-1]
                if(rank < p_num):
                    comm.send(tower_arr[len(tower_arr)-1], dest=rank+1, tag=1)

                #receive from above
                if(rank > 1):
                    data_above = comm.recv(source=rank-1, tag=1) 

                #receive from below
                if(rank < p_num):
                    data_below = comm.recv(source=rank+1, tag=1) 




                #simulate

                #First we simulate the middle area of the striped version. This 
                #First and last row are handled in another loop since they are edge cases.

                for i in range(1,len(tower_arr)-1): #Simulate the middle area.
                    for j in range(len(health_arr[0])):
                        if(tower_arr[i][j] == 1): #It is "o" tower
                            damage = 0
                            if(tower_arr[i+1][j] == 2):
                                damage += 2
                            if(tower_arr[i-1][j] == 2):
                                damage += 2
                            if(j != (len(tower_arr[0]) - 1)): 
                                if(tower_arr[i][j+1] == 2):
                                    damage += 2
                            if(j != 0):
                                if(tower_arr[i][j-1] == 2):
                                    damage += 2

                            health_arr[i][j] -= damage

                        elif(tower_arr[i][j] == 2): # It is "+" tower
                            damage = 0

                            #I check all neighbors and increase the damage if appropriate tower is there.
                            if(tower_arr[i-1][j] == 1):
                                damage += 1
                            if(tower_arr[i+1][j] == 1):
                                damage += 1
                            if(j != 0):
                                if(tower_arr[i-1][j-1] == 1):
                                    damage += 1
                                if(tower_arr[i+1][j-1] == 1):
                                    damage += 1
                                if(tower_arr[i][j-1] == 1):
                                    damage += 1
                            if(j != len(tower_arr[0]) - 1):
                                if(tower_arr[i-1][j+1] == 1):
                                    damage += 1
                                if(tower_arr[i+1][j+1] == 1):
                                    damage += 1
                                if(tower_arr[i][j+1] == 1):
                                    damage += 1

                            health_arr[i][j] -= damage    #Substract damage from tower's health point.                        

                    #Below loop handles the first row of the area. It checks the neighbors accordingly.

                for i in range(len(health_arr[0])): # For the first row.
                    if(tower_arr[0][i] == 1):
                        damage = 0
                        if(i != 0):
                            if(tower_arr[0][i-1] == 2):
                                damage += 2
                        if(i != len(health_arr[0])-1):
                            if(tower_arr[0][i+1] == 2):
                                damage += 2
                        if(len(health_arr) > 1):
                            if(tower_arr[1][i] == 2):
                                damage += 2
                        if(len(data_above) != 0):
                            if(data_above[i] == 2):
                                damage += 2
                        if(height == 1): #I should handle it here since I don't handle this below.
                            if(data_below[i] == 2):
                                damage += 2

                        health_arr[0][i] -= damage #Decrease the health of the tower.

                        #Just do the same thing for other type of towers.
                        # You can skip these part if you understood above logic.

                    elif(tower_arr[0][i] == 2):
                        damage = 0
                        #I handle the edge case that height of the area is 1.
                        if(height == 1): #Height of the map is 1.
                            if(i != 0):
                                if(tower_arr[0][i-1] == 1):
                                    damage += 1
                            if(i != (len(tower_arr[0]) - 1)):
                                if(tower_arr[0][i+1] == 1):
                                    damage += 1
                            if(len(data_above) != 0):
                                if(data_above[i] == 1):
                                    damage += 1
                                if(i != 0):
                                    if(data_above[i-1] == 1):
                                        damage += 1
                                if(i != len(tower_arr[0])-1):
                                    if(data_above[i+1] == 1):
                                        damage += 1
                            if(len(data_below) != 0):
                                if(data_below[i] == 1):
                                    damage += 1
                                if(i != 0):
                                    if(data_below[i-1] == 1):
                                        damage += 1
                                if(i != len(tower_arr[0])-1):
                                    if(data_below[i+1] == 1):
                                        damage += 1

                        else: #Now, i can assume that height is not 0.

                            #Just find the damage that tower gets.
                            if(tower_arr[1][i] == 1):
                                damage += 1
                            if(i != 0):
                                if(tower_arr[0][i-1] == 1):
                                    damage += 1
                                if(tower_arr[1][i-1] == 1):
                                    damage += 1
                            if(i != (len(tower_arr[0]) - 1)):
                                if(tower_arr[0][i+1] == 1):
                                    damage += 1
                                if(tower_arr[1][i+1] == 1):
                                    damage += 1
                            if(len(data_above) != 0):
                                if(data_above[i] == 1):
                                    damage += 1
                                if(i != 0):
                                    if(data_above[i-1] == 1):
                                        damage += 1
                                if(i != len(tower_arr[0]) - 1):
                                    if(data_above[i+1] == 1):
                                        damage += 1

                        health_arr[0][i] -= damage

                #Below loop does the same thing as above. Just handle the last row of the area.
                for i in range(len(health_arr[0])): # For the last row.
                    if(height == 1): #First row and the last row are same. I handle this case above.
                        break

                    
                    #Handle "o" towers.
                    if(tower_arr[len(tower_arr)-1][i] == 1):
                        damage = 0

                        if(tower_arr[height-2][i] == 2):
                            damage += 2
                        if(i != 0):
                            if(tower_arr[height-1][i-1] == 2):
                                damage += 2
                        if(i != (len(tower_arr[0])-1)):
                            if(tower_arr[height-1][i+1] == 2):
                                damage += 2
                        if(len(data_below) != 0):
                            if(data_below[i] == 2):
                                damage += 2

                        health_arr[len(tower_arr)-1][i] -= damage

                    
                    elif(tower_arr[len(tower_arr)-1][i] == 2): #It is "+" tower.
                        
                        p_height = len(tower_arr)
                        p_width = len(tower_arr[0])
                        damage = 0

                        #Find the total damage it receives.
                        if(tower_arr[p_height-2][i] == 1):
                            damage += 1
                        if(i != 0):
                            if(tower_arr[p_height-2][i-1] == 1):
                                damage += 1
                            if(tower_arr[p_height-1][i-1] == 1):
                                damage += 1
                        if(i != (p_width - 1)):
                            if(tower_arr[p_height-2][i+1] == 1):
                                damage += 1
                            if(tower_arr[p_height-1][i+1] == 1):
                                damage += 1
                        if(len(data_below) != 0):
                            if(data_below[i] == 1):
                                damage += 1
                            if(i != 0):
                                if(data_below[i-1] == 1):
                                    damage += 1
                            if(i != (p_width - 1)):
                                if(data_below[i+1] == 1):
                                    damage += 1

                        health_arr[len(tower_arr)-1][i] -= damage


                #We are at the end of the round.
                #Now check if any tower is destroyed. If so, handle accordingly.
                
                for i in range(len(health_arr)): #Check if any tower is destroyed.
                    for j in range(len(health_arr[0])):
                        if(health_arr[i][j] <= 0):
                            health_arr[i][j] = 0
                            tower_arr[i][j] = 0
                #print("after round -->", round_num+1)
                #print("tower array -->", tower_arr)
                #print("health array -->", health_arr)

            #print("tower array after wave -->", tower_arr)
            #print("health array after wave -->", health_arr)



        #We were lazy and just copied the same code for even numbered processes.
        #They do the same thing as above. The only difference is the receive and send orders.
        #This doesn't change anything. So you can skip to the end of the code.
        #Therefore we didn't include any extra comment as we have provided for odd ranked processes.

        else: #even numbered processes

            data_above = []
            data_below = []
            
            for round_num in range(8):
                #receive from above
                data_above = comm.recv(source=rank-1, tag=1) 

                #receive from below
                if(rank < p_num):
                    data_below = comm.recv(source=rank+1, tag=1)

                #send above --> tower_arr[0]
                comm.send(tower_arr[0], dest=rank-1, tag=1)

                #send below --> tower_arr[len(tower_arr)-1]
                if(rank < p_num):
                    comm.send(tower_arr[len(tower_arr)-1], dest=rank+1, tag=1)


                #simulate

                for i in range(1,len(tower_arr)-1): #Simulate the middle area.
                    for j in range(len(health_arr[0])):
                        if(tower_arr[i][j] == 1): #It is "o" tower
                            damage = 0
                            if(tower_arr[i+1][j] == 2):
                                damage += 2
                            if(tower_arr[i-1][j] == 2):
                                damage += 2
                            if(j != (len(tower_arr[0]) - 1)): 
                                if(tower_arr[i][j+1] == 2):
                                    damage += 2
                            if(j != 0):
                                if(tower_arr[i][j-1] == 2):
                                    damage += 2

                            health_arr[i][j] -= damage

                        elif(tower_arr[i][j] == 2): # It is "+" tower
                            damage = 0

                            if(tower_arr[i-1][j] == 1):
                                damage += 1
                            if(tower_arr[i+1][j] == 1):
                                damage += 1
                            if(j != 0):
                                if(tower_arr[i-1][j-1] == 1):
                                    damage += 1
                                if(tower_arr[i+1][j-1] == 1):
                                    damage += 1
                                if(tower_arr[i][j-1] == 1):
                                    damage += 1
                            if(j != len(tower_arr[0]) - 1):
                                if(tower_arr[i-1][j+1] == 1):
                                    damage += 1
                                if(tower_arr[i+1][j+1] == 1):
                                    damage += 1
                                if(tower_arr[i][j+1] == 1):
                                    damage += 1

                            health_arr[i][j] -= damage                            

                for i in range(len(health_arr[0])): # For the first row.
                    if(tower_arr[0][i] == 1):
                        damage = 0
                        if(i != 0):
                            if(tower_arr[0][i-1] == 2):
                                damage += 2
                        if(i != len(health_arr[0])-1):
                            if(tower_arr[0][i+1] == 2):
                                damage += 2
                        if(len(health_arr) > 1):
                            if(tower_arr[1][i] == 2):
                                damage += 2
                        if(len(data_above) != 0):
                            if(data_above[i] == 2):
                                damage += 2
                        if(height == 1): #I should handle it here since I don't handle this below.
                            if(len(data_below)!=0):
                                if(data_below[i] == 2):
                                    damage += 2

                        health_arr[0][i] -= damage

                    elif(tower_arr[0][i] == 2):
                        damage = 0
                        if(height == 1): #Height of the map is 1.
                            if(i != 0):
                                if(tower_arr[0][i-1] == 1):
                                    damage += 1
                            if(i != (len(tower_arr[0]) - 1)):
                                if(tower_arr[0][i+1] == 1):
                                    damage += 1
                            if(len(data_above) != 0):
                                if(data_above[i] == 1):
                                    damage += 1
                                if(i != 0):
                                    if(data_above[i-1] == 1):
                                        damage += 1
                                if(i != len(tower_arr[0])-1):
                                    if(data_above[i+1] == 1):
                                        damage += 1
                            if(len(data_below) != 0):
                                if(data_below[i] == 1):
                                    damage += 1
                                if(i != 0):
                                    if(data_below[i-1] == 1):
                                        damage += 1
                                if(i != len(tower_arr[0])-1):
                                    if(data_below[i+1] == 1):
                                        damage += 1

                        else: #Now, i can assume that height is not 0.
                            if(tower_arr[1][i] == 1):
                                damage += 1
                            if(i != 0):
                                if(tower_arr[0][i-1] == 1):
                                    damage += 1
                                if(tower_arr[1][i-1] == 1):
                                    damage += 1
                            if(i != (len(tower_arr[0]) - 1)):
                                if(tower_arr[0][i+1] == 1):
                                    damage += 1
                                if(tower_arr[1][i+1] == 1):
                                    damage += 1
                            if(len(data_above) != 0):
                                if(data_above[i] == 1):
                                    damage += 1
                                if(i != 0):
                                    if(data_above[i-1] == 1):
                                        damage += 1
                                if(i != len(tower_arr[0]) - 1):
                                    if(data_above[i+1] == 1):
                                        damage += 1

                        health_arr[0][i] -= damage

                for i in range(len(health_arr[0])): # For the last row.
                    if(height == 1): #First row and the last row are same. I handle this case above.
                        break


                    if(tower_arr[len(tower_arr)-1][i] == 1):
                        damage = 0

                        if(tower_arr[height-2][i] == 2):
                            damage += 2
                        if(i != 0):
                            if(tower_arr[height-1][i-1] == 2):
                                damage += 2
                        if(i != (len(tower_arr[0])-1)):
                            if(tower_arr[height-1][i+1] == 2):
                                damage += 2
                        if(len(data_below) != 0):
                            if(data_below[i] == 2):
                                damage += 2

                        health_arr[len(tower_arr)-1][i] -= damage

                    elif(tower_arr[len(tower_arr)-1][i] == 2):
                        
                        p_height = len(tower_arr)
                        p_width = len(tower_arr[0])
                        damage = 0

                        if(tower_arr[p_height-2][i] == 1):
                            damage += 1
                        if(i != 0):
                            if(tower_arr[p_height-2][i-1] == 1):
                                damage += 1
                            if(tower_arr[p_height-1][i-1] == 1):
                                damage += 1
                        if(i != (p_width - 1)):
                            if(tower_arr[p_height-2][i+1] == 1):
                                damage += 1
                            if(tower_arr[p_height-1][i+1] == 1):
                                damage += 1
                        if(len(data_below) != 0):
                            if(data_below[i] == 1):
                                damage += 1
                            if(i != 0):
                                if(data_below[i-1] == 1):
                                    damage += 1
                            if(i != (p_width - 1)):
                                if(data_below[i+1] == 1):
                                    damage += 1

                        health_arr[len(tower_arr)-1][i] -= damage


                
                for i in range(len(health_arr)): #Check if any tower is destroyed.
                    for j in range(len(health_arr[0])):
                        if(health_arr[i][j] <= 0):
                            health_arr[i][j] = 0
                            tower_arr[i][j] = 0

    
    #Simulation is finished. Now, send data to parent.
    comm.send(tower_arr, dest=0, tag=2)
                

        

