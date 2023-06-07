
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package vehicles;

import locations.*;

/**
 * Represents a PublicTransport object in Transportation Project.
 * Since it is an abstract class, it facilitates implementing its child classes which are bus and train.
 * 
 * @author Alp Tuna
 */
public abstract class PublicTransport {
      
	/**
	 * Distinct number to each PublicTransport vehicle, starts from 0.
	 */
	private int ID;
	/**
	 * These four numbers represent two nonadjacent corners of the rectangle.
	 * This rectangular region identifies the operation range of the vehicle.
	 */
	private double x1,y1,x2,y2;
	
	/**
	 * Initializes the PublicTransport object with given parameters.
	 * All parameters corresponds to each field.
	 */
	public PublicTransport(int ID,double x1,double y1,double x2,double y2){
		this.ID = ID;
		this.x1 = x1; //Bunlar operation range'leri için.
		this.y1 = y1;
		this.x2 = x2;
		this.y2 = y2;
		
		
	}
	/**
	 * This function checks if the PublicTransport vehicle is able to ride between the given locations
	 * By looking at the coordinates' of the locations.
	 * 
	 * @param departure Departure location
	 * @param arrival   Arrival location
	 * @return  Whether travel is possible.       
	 */
	public boolean canRide(Location departure,Location arrival){
	return departure.getLocationX()>= Math.min(this.x1,this.x2)&&departure.getLocationX()<= Math.max(this.x1,this.x2)
		&& departure.getLocationY()>= Math.min(this.y1,this.y2)&&departure.getLocationY()<= Math.max(this.y1,this.y2)
		&& arrival.getLocationX()>= Math.min(this.x1, this.x2)&& arrival.getLocationX()<=Math.max(this.x1, this.x2)
		&& arrival.getLocationY()>= Math.min(this.y1, this.y2)&& arrival.getLocationY()<=Math.max(this.y1,this.y2);
	}
	
	
	
	
	
	
}
     


//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE





