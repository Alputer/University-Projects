
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package locations;
import passengers.*;
import java.util.*;

/**
 * Represents a location in Transportation project.
 * 
 * @author Alp Tuna
 */
public class Location{
	
	/**
	 * A unique number to each location. Starts from 0(First location).
	 */
	private int ID;
	/**
	 * X coordinate of the location.
	 */
	private double locationX;
	/**
	 * Y coordinate of the location.
	 */
	private double locationY;
	/**
	 * Keeps the list of passengers who have visited this location. 
	 */
	private ArrayList<Passenger> history = new ArrayList<Passenger>(); 
	/**
	 * Keeps the list of passengers who are currently at this location. 
	 */
	private ArrayList<Passenger> current = new ArrayList<Passenger>();	
	
	/**
	 * Initializes the location with the given parameters.
	 * 
	 * @param ID
	 * @param locationX
	 * @param locationY
	 */
	public Location(int ID,double locationX,double locationY){
		this.ID = ID;
		this.locationX = locationX;
		this.locationY = locationY;
	}
	 /**
	  * Calculates the distance between the two locations.
	  * 
	  * @param other Represents the second location.
	  * @return  The distance between the two locations.
	  */
	public double getDistance(Location other){
		return Math.sqrt(Math.pow(this.locationX-other.locationX, 2)+ Math.pow(this.locationY-other.locationY, 2));
	}
	/**
	 * Adds the incoming passenger to the appropriate lists.
	 * 
	 * @param p Represents the incoming passenger.
	 */
	public void incomingPassenger(Passenger p){
		current.add(p);
		if(!history.contains(p))
			history.add(p);
	}
	/**
	 *  Removes the passenger from the current list.
	 *  
	 * @param p Represents the outgoing passenger.
	 */
	public void outgoingPassenger(Passenger p){
		
		current.remove(p);
		if(!history.contains(p)) 
			history.add(p);
		
	}
	/**
	 * Getter method of the locationX field.
	 * 
	 * @return x coordinate of the location.
	 */
	public double getLocationX(){
		return this.locationX;
	}
	/**
	 *  Getter method of the locationY field.
	 *  
	 * @return y coordinate of the location.
	 */
	public double getLocationY(){
		return this.locationY;
	}
	
	
	 /**
	  * Checks whether the given object parameter is equal to the location.
	  */
	public  boolean equals(Object o){
		if(o instanceof Location){
		Location loc = (Location)o;
		return (this.ID==loc.ID);
		}
		else{
			return false;
		}
	}
}


//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE


