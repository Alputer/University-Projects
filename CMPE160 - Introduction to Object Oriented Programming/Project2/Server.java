
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package elements;

import java.io.PrintStream;
import java.util.LinkedList;
import java.util.Queue;

/**
 * This class represents a server object in the messaging program.
 * It has a capacity, current size and a queue of stored messages
 */
public class Server{
	/**
	 * Maximum number of characters, the server can contain.
	 */
	private long capacity;
	/**
	 * Current size of the server.
	 */
	private long currentSize;
	/**
	 * Queue of the messages in the server.
	 */
	private Queue<Message> msgs;
	
	public Server(long capacity){
	  this.capacity = capacity;
	  this.currentSize = 0;
	  msgs = new LinkedList<Message>();
	}
	
	public long getCurrentSize(){
		return this.currentSize;
	}
	public void setCurrentSize(int size){
		this.currentSize = (long)size;
	}
	
	public long getCapacity(){
		return this.capacity;
	}
	
	public Queue<Message> getMsgs(){
		return this.msgs;
	}
	/**
	 *  Checks whether the server becomes 50% or 80% full or decreased from +80 to somewhere between 50%-80%.
	 *  If so, prints warning messages.
	 *  Also if the server's size has reached the capacity, deletes all the messages and prints a corresponding message.
	 * @param printer Printer object
	 */
	public void checkServerLoad(PrintStream printer, boolean previouslyLessThan50, boolean previouslyLessThan80){
		double ratio = 1.0 * this.currentSize / this.capacity;
		
		if(ratio >= 1){
			printer.println("Server is full. Deleting all messages...");
			flush();
		}
		else if(ratio >= 4.0/5){
			if(previouslyLessThan80)
			printer.println("Warning! Server is 80% full.");
		}
		
		else if((ratio >= 1.0/2) && (previouslyLessThan50 || !previouslyLessThan80)){
			printer.println("Warning! Server is 50% full.");
		}
			
	}
	/**
	 * Deletes all messages from the queue of the server.
	 */
	public void flush(){
		this.msgs.clear();
		this.currentSize = 0;
	}
	/**
	 * Adds the message object to the queue of the server.
	 * @param msg Message object
	 */
	public void addMessage(Message msg){
		this.msgs.add(msg);
		this.currentSize += msg.getBody().length();
	}
}
//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

