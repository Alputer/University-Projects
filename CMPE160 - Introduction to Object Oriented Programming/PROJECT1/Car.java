
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package vehicles;
/**
 * Represents a car object in Transportation Project.
 * 
 * @author Alp Tuna
 */
public class Car {
	/**
	 * Owner's ID number, since no one can have more than 1 cars, they are distinct to each car.
	 */
	private int ownerID;
	/**
	 * Current amount of the fuel.
	 */
	private double fuelAmount;
	/**
	 * Fuel consumption rate of the car.
	 */
	private double fuelConsumption;
	
	/**
	 * Initializes the Car object with the given parameters.
	 * @param ID
	 * @param fuelConsumption
	 */
	public Car(int ID,double fuelConsumption){
		this.ownerID = ID;
		this.fuelConsumption = fuelConsumption;
		
	}
	/**
	 * Increases the fuelAmount field by given amount.
	 * 
	 * @param amount
	 */
	public void refuel(double amount){
		this.fuelAmount += amount;
	}
	/**
	 * Setter method of the fuelConsumption field.
	 * @param fuelConsumption
	 */
	public void setFuelConspumtion(double fuelConsumption){
		this.fuelConsumption = fuelConsumption;
		}
	/**
	 * Getter method of the fuelConsumption field.
	 * @return
	 */
	public double getFuelConsumption(){
		return this.fuelConsumption;
	}
	/**
	 *  Getter method of the fuelAmount field.
	 * @return 
	 */
	public double getFuelAmount(){
		return this.fuelAmount;
	}
	/**
	 * Setter method of the fuelAmount field.
	 * @param fuelAmount
	 */
	public void setFuelAmount(double fuelAmount){
		this.fuelAmount = fuelAmount;
		}
	
	
	
}

//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

