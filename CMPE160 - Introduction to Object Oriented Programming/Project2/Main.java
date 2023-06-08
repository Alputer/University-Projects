
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package executable;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Iterator;
import java.util.Scanner;

import elements.Message;
import elements.Server;
import elements.User;
     /**
      * Main class of the second project of the course CMPE160
      * Objective of the project is implementing a basic messaging program.
      * Queries are given from the input file according to given rules from the description.
      * Output file includes warnings and some specific user messages.
      * 
      * @author Alp Tuna
      */
  public class Main{
    	 
	    
	  /**
	   * Server of the project.
	   */
      private static Server server;
      /**
       * All users are kept in this array with their ID's as their index.
       */
	  private static User[] users;
	  /**
	   * Represents the time of the program.
	   * Increases by one in each query. If the query is reading and more than one message is read,
	   * it increases by the number of the messages which were read.
	   */
	  private static int currentTime = 0;
	  
	  /**
	   * Main class of the project. Creates user array and initializes the server.
	   * Then performs necessary actions according the given queries in the input file.
	   * @param args
	   * @throws FileNotFoundException
	   */
	  public static void main(String[] args) throws FileNotFoundException{
		  
		Scanner console = new Scanner(new File(args[0]));
		PrintStream printer = new PrintStream(new File(args[1]));
		
		int usersNo = console.nextInt();
		int noOfQueries = console.nextInt();
		long serverCapacity = console.nextLong();
		
		server = new Server(serverCapacity);
		
		users = new User[usersNo];
		for(int i=0;i<users.length;i++){
		  users[i] = new User(i);	
		}
		
		/*
		 * Number of iterations are given in the first line. 
		 * I iterate noOfQueries times and perform neccessary actions according to given queries.
		 * Each number corresponds to a function which has an implementation in main class.
		 */
		for(int i=0;i<noOfQueries;i++){
			
			int query = console.nextInt();
			
			switch(query){
			
		    case 0:
				int sender_id = console.nextInt();
				int receiver_id = console.nextInt();
				String message = console.nextLine();
				message = message.trim();
			    sendMessage(sender_id, receiver_id, message, printer);
			    
			    break;
		    case 1:
		    	int receiverA_id = console.nextInt();
		    	
		    	receiveAllMessages(receiverA_id, printer);
		    	break;
			case 2:
				int receiverB_id = console.nextInt();
				int noOfMessages = console.nextInt();
				
				readMessages(receiverB_id, noOfMessages);
				break;
			case 21:
				int receiverX_id = console.nextInt();
				int senderX_id = console.nextInt();
				
				readAll(receiverX_id, senderX_id);
				break;
			case 22:
				int receiverY_id = console.nextInt();
				int message_id = console.nextInt();
				
				read(receiverY_id, message_id);
				break;
			case 3:
				int user1_id = console.nextInt();
				int user2_id = console.nextInt();
				makeFriend(user1_id, user2_id);
				
		        break;
			case 4:
	            int userA_id = console.nextInt();
				int userB_id = console.nextInt();
				removeFriend(userA_id, userB_id);
				
		        break;
			case 5:
				deleteAllMesages();
				
				break;
			case 6:
				printServerCurrentSize(printer);
				
				break;	
			case 61:
				int userD_id = console.nextInt();
				
				printLastRead(userD_id, printer);
				break;
			}
		}
	  
	       console.close();
	  }
            /**
             * This method represents the action of sending a message.
             * Keeps track of information about the size of the server in order to sent information to checkServerLoadMethod
             * Whether checking for warnings in neccessary.
             * @param sender_id
             * @param receiver_id
             * @param message
             * @param printer
             */
	private static void sendMessage(int sender_id, int receiver_id, String message, PrintStream printer) {
	
		boolean isPreviouslyLessThan50 = false;
		boolean isPreviouslyLessThan80 = false;
		
		double ratio = 1.0 * server.getCurrentSize() / server.getCapacity();
		if(ratio < 1.0/2){
			isPreviouslyLessThan50 = true;
		    isPreviouslyLessThan80 = true;
		}
		else if(ratio < 4.0/5){
			isPreviouslyLessThan80 = true;
		}

			
		    users[sender_id].sendMessage(users[receiver_id], message, currentTime, server);
		    server.checkServerLoad(printer,isPreviouslyLessThan50, isPreviouslyLessThan80);
			currentTime++;
		}
	/**
	 * Receiver user receives all messages sent to him/her via this function.
	 * @param receiver_id
	 * @param printer
	 */
	private static void receiveAllMessages(int receiver_id, PrintStream printer) {	
		
		boolean isPreviouslyLessThan50 = false;
		boolean isPreviouslyLessThan80 = false;
		
		double ratio = 1.0 * server.getCurrentSize() / server.getCapacity();
		if(ratio < 1.0/2){
			isPreviouslyLessThan50 = true;
		    isPreviouslyLessThan80 = true;
		}
		else if(ratio < 4.0/5){
			isPreviouslyLessThan80 = true;
		}
		
		users[receiver_id].getInbox().receiveMessages(server, currentTime);
		server.checkServerLoad(printer, isPreviouslyLessThan50, isPreviouslyLessThan80);
		currentTime++;
	}
	/**
	 * Reads last noOfMessages number of messages receiver user has received.
	 * @param receiver_id
	 * @param noOfMessages
	 */
	private static void readMessages(int receiver_id, int noOfMessages) {
		
		currentTime += users[receiver_id].getInbox().readMessages(noOfMessages, currentTime);	
		
	}
     /**
      * Reads all messages sender user sent to receiver user.
      * @param receiver_id 
      * @param sender_id
      */
	private static void readAll(int receiver_id, int sender_id) {
		
		currentTime += users[receiver_id].getInbox().readMessages(users[sender_id], currentTime);	
	}
	/**
	 * Reads the specific message with given id.
	 * @param receiver_id
	 * @param message_id
	 */
	private static void read(int receiver_id, int message_id) {
		
		users[receiver_id].getInbox().readMessage(message_id, currentTime);
		currentTime++;
	}
    /**
     * Adds each person to other person's friendship list.
     * 
     * @param user1_id First user's ID
	 * @param user2_id Second user's ID
     */
	private static void makeFriend(int user1_id, int user2_id) {
		User user1 = users[user1_id];
		User user2 = users[user2_id];
		
		user1.addFriend(user2);	
		currentTime++;
	}
	/**
	 * Removes each person from other person's friendship list.
	 * 
	 * @param user1_id First user's ID
	 * @param user2_id Second user's ID
	 */
	private static void removeFriend(int user1_id, int user2_id) {
		User user1 = users[user1_id];
		User user2 = users[user2_id];
		
		user1.removeFriend(user2);
		currentTime++;
	}
	/**
	 * Deletes all messages from the queue of the server.
	 */
	private static void deleteAllMesages() {
		
		server.flush();
		currentTime++;
	}
	/**
	 * Prints the current size of the server. 
	 */
	private static void printServerCurrentSize(PrintStream printer) {
		
	  printer.println("Current load of the server is "+ server.getCurrentSize() + " characters.");	
	  currentTime++;
	}
	
	/**
	 * Prints the last read message of the user that has given id.
	 * In order to do it, i traversed the whole queue of the user until the end.
	 * @param userD_id User's id
	 * @param printer PrintStream object
	 */
	private static void printLastRead(int userD_id, PrintStream printer) {
	  Iterator<Message> itr = users[userD_id].getInbox().getRead().iterator();

	  Message msg = null;
	while(itr.hasNext()){
		 msg = (Message)itr.next();
		
	}
	if(msg != null)
	printer.println(msg);
	currentTime++;
		
	}

     

   }
//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE


