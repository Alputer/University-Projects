
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package vehicles;
import passengers.*;
import locations.*;

/**
 * Represents a bus object in PublicTransport Project
 * It has functional methods such as getPrice which returns different prices for different passenger types.
 * 
 * @author Alp Tuna
 */
public class Bus extends PublicTransport{
	
	/**
	 * It does not have additional fields. So simply calling parent constructor is sufficient.
	 */
	public Bus(int ID,double x1,double y1,double x2,double y2){
		
		super(ID,x1,y1,x2,y2);
		
	}
	 
    /**
     * Calculates the price of the journey considering passenger type.
     * 
     * @param p Represents the passenger object.
     * @return the price of the travel.
     */
	public static double getPrice(Passenger p){
		if(p instanceof DiscountedPassenger){
			return 1.0;
		}
		else{
			return 2.0;
		}
		
		
	}
	/**
	 * This method is similar to getPrice method, yet it does not accept passenger parameter which helped me during
	 * the implementation of the passenger class.
	 * 
	 * @param departure Represents the departure location.
	 * @param arrival Represents the arrival location.
	 * @return the price of the travel.
	 */
	public static double getStandardPrice(Location departure,Location arrival){
		return 2.0;
	}
	/**
	 * This method is similar to getPrice method, yet it does not accept passenger parameter which helped me during
	 * the implementation of the passenger class.
	 * 
	 * @param departure Represents the departure location.
	 * @param arrival Represents the arrival location.
	 * @return the price of the travel.
	 */
    public static double getDiscountedPrice(Location departure,Location arrival){
		return 1.0;
	}
	
}

//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

