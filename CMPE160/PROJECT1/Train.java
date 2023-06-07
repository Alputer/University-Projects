
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package vehicles;

import passengers.*;
import locations.*;
/**
 * Represents a Train object in PublicTransport Project
 * It has functional methods such as getPrice which returns different prices for different passenger types.
 * 
 * @author Alp Tuna
 */
public class Train extends PublicTransport{
	
	/**
	 * It does not have additional fields. So simply calling parent constructor is sufficient.
	 */
	public Train(int ID,double x1,double y1,double x2,double y2){
		
		super(ID,x1,y1,x2,y2);
	}
	
	
	/**
	 * After calculating the distance between the two locations we find the number of stops required to travel.
	 * Each stop increases the price and we calculate the price by given formula in the project. We also make necessary
	 * discounts for discounted passengers. 
	 * 
	 * @param p Represents the passenger who might travel between the two locations.
	 * @param departure Represents the departure location.
	 * @param arrival Represents the arrival location.
	 * @return the Price
	 */
	
	public static double getPrice(Passenger p, Location departure,Location arrival){
		int stop = 0;
		double distance = departure.getDistance(arrival);
		int distanceUtil = (int)Math.round(distance); //37km,33km,41km...
        stop += distanceUtil/15;
        if(distanceUtil%15>=8){
        	stop++;
        }
		double price = stop * 5.0;
		//%20 indirim.
		if(p instanceof DiscountedPassenger){
			return (price*4.0)/5;
		}
		else{
			return price;
		}
		
			}

	/**
	 * This method is similar to getPrice method, yet it does not accept passenger parameter which helped me during
	 * the implementation of the passenger class.
	 * 
	 * @param departure Represents the departure location.
	 * @param arrival Represents the arrival location.
	 * @return the price
	 */
	public static double getStandardPrice(Location departure,Location arrival){
		int stop = 0;
		double distance = departure.getDistance(arrival);
		int distanceUtil = (int)Math.round(distance); //37km,33km,41km...
        stop += distanceUtil/15;
        if(distanceUtil%15>=8){
        	stop++;
        }
		double price = stop * 5.0;
		return price;
	}
	/**
	 * This method is similar to getPrice method, yet it does not accept passenger parameter which helped me during
	 * the implementation of the passenger class.
	 * 
	 * @param departure Represents the departure location.
	 * @param arrival Represents the arrival location.
	 * @return the price
	 */
	public static double getDiscountedPrice(Location departure,Location arrival){
		int stop = 0;
		double distance = departure.getDistance(arrival);
		int distanceUtil = (int)Math.round(distance); //37km,33km,41km...
        stop += distanceUtil/15;
        if(distanceUtil%15>=8){
        	stop++;
        }
		double price = stop * 5.0;
		return (price*4.0)/5;
		
	}
	
}


//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

