//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE
package elements;

import java.util.ArrayList;

import boxes.*;

/**
 * This class represents a user object in the messaging program. Each user has
 * an id, inbox, outbox and friends.
 * 
 */
public class User {
     /**
      * Id of the user. Unique for each user.
      */
	private int id;
	/**
	 * Inbox object of the user.
	 */
	private Inbox inbox;
	/**
	 * Outbox object of the user.
	 */
	private Outbox outbox;
	/**
	 * List of the users which are friends of this user.
	 */
	private ArrayList<User> friends;

	public User(int id) {
		this.id = id;
		this.inbox = new Inbox(this);
		this.outbox = new Outbox(this);
		this.friends = new ArrayList<User>();
	}

	public int getId() {
		return this.id;
	}
	
	public Inbox getInbox(){
		return this.inbox;
	}
	/**
	 * Checks whether the given parameter is this object.
	 */
	public boolean equals(Object other){
		if(other instanceof User){
			User user2 = (User)other;
			return this.id == user2.id;
		}
		else{
			return false;
		}
	}
     /**
      * Adds each user to other user's friendship list.
      */
	public void addFriend(User other) {
           
		if (!friends.contains(other)) {
			friends.add(other);
			other.friends.add(this);
		}
	}
/**
 * Removes each user from other user's friendship list.
 */
	public void removeFriend(User other) {
          
		this.friends.remove(other);
		other.friends.remove(this);
	}
    /**
     * Checks whether this person and other person are friends.
     */
	public boolean isFriendsWith(User other) {
		return friends.contains(other);
	}
       /**
        * 
        * @param receiver 
        * @param body
        * @param time Time when the message is sent
        * @param server
        */
	public void sendMessage(User receiver, String body, int time, Server server) {
          
		  Message message = new Message(this,receiver,body);

          server.addMessage(message);
          this.outbox.addMessage(message);
          message.setTimeStampSent(time);

		  
          
	}

}
// DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

