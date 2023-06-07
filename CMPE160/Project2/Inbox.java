
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package boxes;

import java.util.Iterator;
import java.util.ListIterator;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

import elements.*;

/**
 * This class represents the inbox object of any user.
 * It has an owner, stack "unread" for unread messages and a queue "read" for messages that have been read.
 * It has mainly 2 type of functionalities. First one is receiving messages from the server and second one is
 * reading the messages which have already been received. 
 */
public class Inbox extends Box{
	
	/**
	 * This stack represents the messages a user received but has not read.
	 * Therefore last received message is the first to be read.
	 */
	private Stack<Message> unread;
	
	/**
	 * This queue represents the messages a user has read and keeps them in the order in which they were read.
	 * Therefore first element is the one which has been read first.
	 */
	private Queue<Message> read;
	
	public Inbox(User user){
		this.owner = user;
		this.unread = new Stack<Message>();
		this.read = new LinkedList<Message>();
	}
	
	public Queue<Message> getRead(){
		return this.read;
	}
	/**
	 * This method performs neccessary actions when a message is received.
	 * It updates the server and message's TimeStampReceived field.
	 * @param server Represents the server
	 * @param time TimeStampReceived is set to "time" variable.
	 */
  public void receiveMessages(Server server, int time){
        Iterator<Message> itr = server.getMsgs().iterator();
        while(itr.hasNext()){
        	Message msg = itr.next();
        	if(msg.getReceiver().equals(this.owner) && this.owner.isFriendsWith(msg.getSender())){
        	unread.add(msg);
        	msg.setTimeStampReceived(time);
        	itr.remove();
        	server.setCurrentSize((int)server.getCurrentSize()- msg.getBody().length());
        	}
        }
  }
  /**
   * Reads "num" number of messages from the stack and copies them to the queue.
   * Therefore the order of the last num messages are reversed when they are copied.
   * First element is the one which has been read first.
   * @param num Number of the messages to be read. If 0 or more than the size of the stack, means all of the messages.
   * @param time
   * @return
   */
  public int readMessages(int num, int time){
	  if(unread.size()==0)
		  return 1;
	  
	  if(num == 0 || num > unread.size())
		  num = unread.size();
	  int result = num;
	  
	  ListIterator<Message> itr = unread.listIterator(unread.size());

	  while(num > 0){
		  Message msg = itr.previous();
		  msg.setTimeStampRead(time++);
		  read.add(msg);
		  itr.remove(); // Removes from unread list.
		  num--;
	  }
	  
	  if(result == 0)
		  return 1;
	  else
        return result;
  }
  /**
   * This method reads all of the messages received from the server whose owner is the "sender" parameter.
   * Therefore the order of the last num messages are reversed when they are copied.
   * It reads from the stack, and copies them to a queue.
   * Therefore, first element of the queue is the one which has been read first.
   * @param sender Sender of the message.
   * @param time Time is when messages are read. Increases by one between two consecutive messages that has been read.
   * @return
   */
  public int readMessages(User sender, int time){
	  if(unread.size()==0)
		  return 1;
	  
	  ListIterator<Message> itr = unread.listIterator(unread.size());
	  int total = 0;
	  while(itr.hasPrevious()){
		  Message msg = itr.previous();
		  
		  if(msg.getSender().equals(sender)){
			  msg.setTimeStampRead(time++);
			  read.add(msg);
			  itr.remove(); // Removes from unread list.
			  total++;
		  }
	  }
		  		  
	  if(total==0)
		  return 1;
	  else
		  return total;
  }
  /**
   * This method reads the message with given ID if it exists.
   * @param msgId ID of the message.
   * @param time When the message is read.
   */
  public void readMessage(int msgId, int time){
	  Iterator<Message> itr = unread.iterator();
	  while(itr.hasNext()){
		  Message msg = itr.next();
		  
		  if(msg.getId() == msgId){
			  msg.setTimeStampRead(time);
			  read.add(msg);
			  itr.remove(); // Removes from unread list.
			  return;
		  }
	  
	  }
  }

}
//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

