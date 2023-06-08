
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package boxes;

import java.util.LinkedList;
import java.util.Queue;

import elements.*;
/**
 * Outbox object of a user. It keeps the messages he/she has sent.
 */
public class Outbox extends Box{

	 private Queue<Message> sent;
	
public Outbox(User owner){
	this.owner = owner;
	this.sent = new LinkedList<Message>();
}
 /**
  * Adds the message to the queue "sent".
  * @param msg Represents the message.
  */
public void addMessage(Message msg){
	this.sent.add(msg);
}

}
//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

