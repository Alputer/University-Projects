
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package elements;


/**
 * Represents a message in the messaging program.
 * Each message has a sender,receiver and a body and three different time fields.
 */
public class Message implements Comparable<Message>{
    /**
     * Total number of messages.
     */
	private static int numOfMessages = 0;
	/**
	 * Unique ID for each message object.
	 */
	private int id;
	/**
	 * Body contains information of the message.
	 */
	private String body;
	/**
	 * Sender of this message.
	 */
	private User sender;
	/**
	 * Receiver of this message.
	 */
	private User receiver;
	/**
	 * Time when this message is sent from sender to receiver.
	 */
	private int timeStampSent;
	/**
	 * Time when receiver received the message.
	 */
	private int timeStampReceived;
	/**
	 * Time when receiver read the message.
	 */
	private int timeStampRead;
	
	
    public Message(User sender, User receiver, String body){
    	this.body = body;
		this.sender = sender;
		this.receiver = receiver;
		this.id = numOfMessages;
		numOfMessages++;
    }
	public Message(User sender, User receiver, String body, Server server, int time ) {
          this(sender,receiver,body);
		
        server.addMessage(this);
		this.setTimeStampSent(time);
		
	}
	
	public void setTimeStampRead(int timeStampRead){
		this.timeStampRead = timeStampRead;
	}
	
	public void setTimeStampReceived(int timeStampReceived){
		this.timeStampReceived = timeStampReceived;
	}
	
	public void setTimeStampSent(int timeStampSent){
		this.timeStampSent = timeStampSent;
	}
	
	public int getId(){
		return this.id;
	}
	
	public String getBody(){
		return this.body;
	}
	
	public User getReceiver(){
		return this.receiver;
	}
	
	public User getSender(){
		return this.sender;
	}
    /**
     * Comparison is made according to length of the bodies. 
     * Returns the difference between the two messages.
     */
	public int compareTo(Message o){
	   return  this.body.length() - o.body.length();
		
	}
	/**
	 * Checks whether the given object is same as this object.
	 */
	public boolean equals(Object o){
		if(o instanceof Message){
			Message msg = (Message)o;
			return this.id == msg.id;
		}
		else{
			return false;
		}
	}
	/**
	 * This method returns information about the message as a string.
	 */
	public String toString(){
		String result = "\tFrom: ";
		result += this.sender.getId();
		result += " to: ";
		result += this.receiver.getId();
		result += "\n\tReceived: ";
		
		if(this.timeStampReceived != 0)
		result += Integer.toString(this.timeStampReceived);
		
		result += " Read: ";
		
		if(this.timeStampRead != 0)
		result += Integer.toString(this.timeStampRead);
		
		result += "\n\t";
		result += this.body;

		return result;
	}
	


}
//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

