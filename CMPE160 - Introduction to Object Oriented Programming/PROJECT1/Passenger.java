
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package passengers;
import locations.*;
import vehicles.*;
import interfaces.*;

/**
 * Represents a passenger who might take several actions throughout the Transportation project
 * such as driving to a location or using public transportation. Corresponding methods are implemented in this class.
 * 
 * @author Alp Tuna
 */
public class Passenger implements ownCar,usePublicTransport{
	
	 /**
	 * A unique number to each passenger starting from 0.
	 */
	private int ID;
	/**
	 * Keeps the information of whether the passenger has drivers license.
	 */
	private boolean hasDriversLicense;
	/**
	 * Keeps the card balance of the passenger.
	 */
	double cardBalance; 
	/**
	 * Represents the passenger's car. It is null if the passenger does not have var.
	 */
	Car car; 
	/**
	 * Represents the passenger's current location.
	 */
	Location currentLocation; 
	
	/**
	 * Initializes the passenger who does not have car with given parameters.
	 */
	public Passenger(int ID, boolean hasDriversLicense, Location l){
		this.ID = ID;
		this.hasDriversLicense = hasDriversLicense;
		this.currentLocation = l;
		
	}
	/**
	 * Initializes the passenger object with the given parameters if (s)he has car.
	 * Also its drivers license changed as true as written in project description.
	 */
	public Passenger(int ID,Location l,double fuelConsumption){
	this.ID = ID;
	this.currentLocation = l;
	this.car = new Car(this.ID,fuelConsumption);
	
    }
	
	
	
	/**
	 * This method is overriden in its child classes.
	 */
	public void ride(PublicTransport p, Location l) {
		
	    }
	     
	   /**
	    * Passenger's card balance is increased by given amount.
	    */
	public void refillCard(double amount) {
		this.cardBalance += amount;
		
		
	}
	/**
	 * If the person has a car this method increases the person's car's fuelAmount by given amount.
	 * This is done via calling refuel method of the car class.
	 */
	public void refuel(double amount) {
		if(this.car!=null){
		this.car.refuel(amount);
		}
		
	}
	
	/**
	 * This method is called if the passenger wants to drive to the given location.
	 * If the passenger does not have a car or drivers license, it is not allowed.
	 * Also if the car does not have enough fuelAmount before the journey, it is not allowed.
	 * If these conditions are satisfied travel occurs and car's fuelAmount decreases and 
	 * passenger's location is changed. 
	 */
	public void drive(Location l) {
		if(this.car!=null &&this.hasDriversLicense){
		if(this.car.getFuelAmount()>=car.getFuelConsumption()* this.currentLocation.getDistance(l)){
		
		double initial = this.car.getFuelAmount();
		double consumption = this.car.getFuelConsumption()*this.currentLocation.getDistance(l);
		this.car.setFuelAmount(initial-consumption);
		this.currentLocation = l; //Bunun sirasi farkli oldugu icin bayagi bir tricky olmus.
		}
		}
		
	}
	/**
	 * If a passenger wants to purchase a car, this method is called. 
	 * His/her car field is initialized and the passenger is given a drivers license.
	 * 
	 * @param fuelConsumption rate is the car's fuel consumption rate.
	 */
	public void purchaseCar(double fuelConsumption) {
	    this.car = new Car(this.ID,fuelConsumption);
	    this.hasDriversLicense = true;
		
	}
	/**
	 *  Getter method of the cardBalance field.
	 * @return cardBalance field.
	 */
	public double getCardBalance(){
		return this.cardBalance;
	}
	/**
	 *  Getter method of the car field.
	 * @return car field.
	 */
	public Car getCar(){
		if(this.car==null){
			return null;
		}
		else{
			return this.car;
		}
		
	}
	/**
	 * Getter method of the currentLocation field.
	 * @return currentLocation field.
	 */
	public Location getLocation(){
		return this.currentLocation;
	}
	
	public void setHasDriversLicense(boolean result){
		this.hasDriversLicense = result;
	}
	
}




//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

