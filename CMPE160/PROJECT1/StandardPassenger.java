
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package passengers;
import vehicles.Bus;
import vehicles.PublicTransport;
import vehicles.Train;
import locations.*;

/**
 * Represents a standard passenger. I didn't implement additional methods to the project in this class.
 * 
 * @author Alp Tuna
 */
public class StandardPassenger extends Passenger {
	
	/**
	 * Calls parent constructor since no additional field exists in this class.
	 * Constructor of the passenger who does not have car.
	 */
	public StandardPassenger(int ID,boolean hasDriversLicense,Location l){
		super(ID,hasDriversLicense,l);
		
	}
	/**
	 * Calls the parent constructor
	 * Constructor of the passenger who has a car.
	 */
	public StandardPassenger(int ID,Location l,double fuelConsumption){
		super(ID,l,fuelConsumption);
		
	}
	
	/**
	 * This method does necessary actions for standard passenger if the passenger wants to use public transport
	 * to travel. It checks whether (s)he has enough card balance and validity of the vehicle bu calling canRide method.
	 * Different implementations for bus and train!
	 */
		public void ride(PublicTransport p, Location l){
			if(p instanceof Bus){
	    if(p.canRide(this.currentLocation,l)&&this.cardBalance>=Bus.getStandardPrice(this.currentLocation,l)){
				this.cardBalance -= Bus.getStandardPrice(this.currentLocation,l);
				this.currentLocation = l;
	           }
			}
			if(p instanceof Train){
		if(p.canRide(this.currentLocation,l)&&this.cardBalance>=Train.getStandardPrice(this.currentLocation,l)){
				this.cardBalance -= Train.getStandardPrice(this.currentLocation,l);
				this.currentLocation = l;
				}
			}
			
		}
	
	
	
	
	
}


//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

