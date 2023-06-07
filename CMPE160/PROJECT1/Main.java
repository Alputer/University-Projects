
//DO_NOT_EDIT_ANYTHING_ABOVE_THIS_LINE

package main;

import java.util.*;
import java.io.*;
import vehicles.*;
import passengers.*;
import locations.*;
/**
 * Main class of the Transportation Project. 
 * Reading from the file and writing to the target file is done in this class.
 * While doing this, i implemented additional methods to the project such as creatingPassenger and passengerTravelling. 
 * 
 * @author Alp Tuna
 */
public class Main {
	/**
	 * Main method of the project.
	 * Scanner object is created and read the input file.
	 * PrintStream object is created and wrote to the output file.
	 * Necessary actions are done according to the input format.
	 * According to the first number of the line different methods are called.
	 * Lastly produceOutput method is called.
	 */
	public static void main(String[] args) throws FileNotFoundException {

		Scanner input = new Scanner(new File(args[0]));
		PrintStream output = new PrintStream(new File(args[1]));
		
		
		

		ArrayList<Passenger> passengers = new ArrayList<Passenger>();
		ArrayList<Location> locations = new ArrayList<Location>();
		ArrayList<PublicTransport> vehicles = new ArrayList<PublicTransport>();
		
		
		
		  Location l = new Location(0, 0, 0); // The first location is always (0,0).
		  locations.add(l);
		
		  int operations = input.nextInt();
		
		
		for(int i=0;i<operations;i++){
			int action = input.nextInt();
			
			if(action==1){
				creatingPassenger(input,passengers,locations);
			}
			if(action==2){
				createLocation(input,locations);
			}
			if(action==3){
				createPublicTransport(input,vehicles);
			}
			if(action==4){
				passengerTravelling(input,passengers,locations,vehicles);
			}
			if(action==5){
				purchasingCar(input,passengers);
			}
			if(action==6){
				refuelCar(input,passengers);
			}
			if(action==7){
				refillCard(input,passengers);
			}
		}
		
		
	   produceOutput(output,passengers,locations);
	
	  
	   }
	
	/**
	 * Passenger is created in this method.
	 * I read the line by scanner and did necessary actions in if statements.
	 * There was 4 possibilities, so i implemented 4 if statements.
	 * 
	 * @param input Represents the scanner object
	 * @param passengers Represents the passengers arrayList field.
	 * @param locations Represents the locations arrayList field.
	 */
  public static void creatingPassenger(Scanner input,ArrayList<Passenger> passengers,ArrayList<Location>locations){
		String passengerType = input.next();
		int hasDriversLicense = input.nextInt();
		int hasCar = input.nextInt();
		
		
		if(hasCar==0&&passengerType.equals("S")){
StandardPassenger thePassenger = new StandardPassenger(passengers.size(),hasDriversLicense==1,locations.get(0));
locations.get(0).incomingPassenger(thePassenger);
passengers.add(thePassenger);
		}
		if(hasCar==0&&passengerType.equals("D")){
DiscountedPassenger thePassenger = new DiscountedPassenger(passengers.size(),hasDriversLicense==1,locations.get(0));
locations.get(0).incomingPassenger(thePassenger);
passengers.add(thePassenger);
		}
		if(hasCar==1&&passengerType.equals("S")){
			double fuelConsumption = input.nextDouble();
StandardPassenger thePassenger = new StandardPassenger(passengers.size(),locations.get(0),fuelConsumption);
thePassenger.setHasDriversLicense(hasDriversLicense==1);
locations.get(0).incomingPassenger(thePassenger);
passengers.add(thePassenger);
			}
		if(hasCar==1&&passengerType.equals("D")){
		double fuelConsumption = input.nextDouble();
DiscountedPassenger thePassenger = new DiscountedPassenger(passengers.size(),locations.get(0),fuelConsumption);
thePassenger.setHasDriversLicense(hasDriversLicense==1);
locations.get(0).incomingPassenger(thePassenger);
passengers.add(thePassenger);		
		}
		
		
		
		}
  
  /**
   * I created a location in this function.
   * locationX and locationY fields are read from the scanner.
   * 
   * @param input Represents the scanner object
   * @param locations Represents the locations arrayList field.
   */
  public static void createLocation(Scanner input,ArrayList<Location>locations){
	  double locationX = input.nextDouble();
	  double locationY = input.nextDouble();
	  int locationID = locations.size();
	  Location l = new Location(locationID,locationX,locationY);
	  locations.add(l);
	  
	  
  }
  
  /**
   * I created a bus or train according to the number given in the input file.
   * Using polymorphism concept, i added these vehicles to the PublicTransportation arrayList.
   * 
   * @param input Represents the scanner object
   * @param vehicles Represents the vehicles arrayList field.
   */
  public static void createPublicTransport(Scanner input,ArrayList<PublicTransport>vehicles){
	  int vehicleType = input.nextInt();
	  double x1 = input.nextDouble();
	  double y1 = input.nextDouble();
	  double x2 = input.nextDouble();
	  double y2 = input.nextDouble();
	  if(vehicleType==1){
		  Bus bus = new Bus(vehicles.size(),x1,y1,x2,y2);
		  vehicles.add(bus);
	  }
	  if(vehicleType==2){
		  Train train = new Train(vehicles.size(),x1,y1,x2,y2);
		  vehicles.add(train);
	  }
	  
	  
	  
      }
     
  /**
   * If the passenger wanted to travel, this method is called. Trasportation type is given by different numbers in the input file.
   * So according to different 3 numbers the passenger used bus,train or his/her own car. I handled this by 3 if statements.
   * In each if statement i called ride/drive functions which are implemented in passengers package.
   * Since most of the actions are done in those methods simply calling these methods on passenger solved the problem.
   * 
   * @param input Represents the scanner object
   * @param passengers Represents the passengers arrayList field.
   * @param locations Represents the locations arrayList field.
   * @param vehicles Represents the vehicles arrayList field.
   */
     public static void passengerTravelling(Scanner input,ArrayList<Passenger>passengers,ArrayList<Location>locations,ArrayList<PublicTransport>vehicles){
    	 int passengerID = input.nextInt();
    	 Passenger thePassenger = passengers.get(passengerID);
    	 Location initial = thePassenger.getLocation(); // initial location.
    	 int locationID = input.nextInt();
    	 Location loc = locations.get(locationID);
    	 int transportationType = input.nextInt();
    	 
    	 //If initial and loc are equal no action is necessary.
    	 if(initial.equals(loc)){
    		 return;
    	 }
    	 
    	 //For location arrayLists.
		 initial.outgoingPassenger(thePassenger);
		 loc.incomingPassenger(thePassenger);
    	 
    	 if(transportationType ==1){
    	int vehicleID =	input.nextInt();
    	if(vehicles.get(vehicleID)instanceof Bus){
    	Bus bus = (Bus)vehicles.get(vehicleID);
    		thePassenger.ride(bus,loc); 
    		
    	}
    	}
    	 
    	 if(transportationType==2){
    		 int vehicleID = input.nextInt();
    		 if(vehicles.get(vehicleID)instanceof Train){
    		Train train = (Train)vehicles.get(vehicleID);
    		 thePassenger.ride(train,loc);
    		 }
    	 }
    	 
    	 if(transportationType==3){
    		 thePassenger.drive(loc);
    	 }
    	   
    	 
    	 
     }
    
     /**
      * This method does necessary actions if the passenger wants to purchase a car.
      * Most of the validity checks are done in the "purchaseCar" method of the passenger class.
      * Therefore simply calling that method was sufficient.
      * 
      * @param input Represents the scanner object
      * @param passengers Represents the passengers arrayList field.
      */
  public static void purchasingCar(Scanner input,ArrayList<Passenger>passengers){
	  int passengerID = input.nextInt();
	  double fuelConsumptionRate = input.nextDouble();
	  Passenger thePassenger = passengers.get(passengerID);
	  thePassenger.purchaseCar(fuelConsumptionRate); 
	  
	  
	 
  }
  
  
  /**
   * If the passenger wanted to refuel his/her car, this method is called.
   * Since its actual implementation is done in passenger class, simply calling that method was sufficient.
   * 
   * @param input Represents the scanner object
   * @param passengers Represents the passengers arrayList field.
   */
  public static void refuelCar(Scanner input,ArrayList<Passenger>passengers){
	  int passengerID = input.nextInt();
	  double addFuelAmount = input.nextDouble();
	  Passenger thePassenger = passengers.get(passengerID);
	  thePassenger.refuel(addFuelAmount);
	  
	  
	  
  }
  /**
   * If the passenger wanted to refill his/her card this method is called.
   * Since its actual implementation is done in passenger class, simply calling that method was sufficient.
   * 
   * @param input Represents the scanner object
   * @param passengers Represents the passengers arrayList field.
   */
  public static void refillCard(Scanner input,ArrayList<Passenger>passengers){
	  int passengerID = input.nextInt();
	  double addCard = input.nextDouble();
	  Passenger thePassenger = passengers.get(passengerID);
	  thePassenger.refillCard(addCard);
	  
	  
	  
  }
  /**
   * This method is used for writing to the output file.
   * I traversed over locations and passengers arraylist's and 
   * printed them to output file according to the project description rules.
   * 
   * @param output An object to write to an output file.
   * @param passengers List of the all passengers created.
   * @param locations List of the all locations created.
   */
  public static void produceOutput(PrintStream output,ArrayList<Passenger>passengers,ArrayList<Location>locations){
	  for(int i=0;i<locations.size();i++){
output.printf("Location %d: (%.2f, %.2f)\n",i,locations.get(i).getLocationX(),locations.get(i).getLocationY());
		 for(int j=0;j<passengers.size();j++){
			if(passengers.get(j).getLocation().equals(locations.get(i))){
			  
			  if(passengers.get(j).getCar()==null){
				output.printf("Passenger %d: %.2f\n",j,passengers.get(j).getCardBalance());
			  }
			  else{
				  double wrongInitial = passengers.get(j).getCar().getFuelAmount();
				  double result = (Math.floor(wrongInitial*100)/100);
				  output.printf("Passenger %d: %.2f\n",j,result);
			  }
				
			}
		 }
	  }
  }

}


//DO_NOT_EDIT_ANYTHING_BELOW_THIS_LINE

