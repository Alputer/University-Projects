
public class Solution {
	public static void main(String[] args){
		
		int stickmanHeight = Integer.parseInt(args[0]);
		int stairHeight = Integer.parseInt(args[1]); 
	
	//frameNumber refers to in which frame we are starting from 1.
	for (int frameNumber = 1; frameNumber <= stairHeight + 1; frameNumber++) {
		BodyTop(frameNumber,stickmanHeight,stairHeight);
		BodyAndStairs(frameNumber,stickmanHeight,stairHeight);
		StairsDown(frameNumber,stickmanHeight,stairHeight);
	}
}
         
     /*This method prints the part of the body above the stairs
      in each frame. This part gets bigger as frameNumber increases.*/
	public static void BodyTop(int frameNumber,int stickmanHeight,int stairHeight) {
	//emptyLines refers to the number of the lines above the head in each frame.
	for(int emptyLines=stairHeight-frameNumber+1;emptyLines>0;emptyLines--){
	System.out.println();
	}
	
	//emptySpaces refers to the one third of the spaces before heads and torso in each loop.
	for (int emptySpaces = 1; emptySpaces < frameNumber; emptySpaces++) {
		System.out.print("   ");
	}
	
	System.out.print(" O \n");
	
	for (int emptySpaces = 1; emptySpaces < frameNumber; emptySpaces++) {
		System.out.print("   ");
	
	}
	System.out.print("/|\\");
	System.out.println("");
	
	//torsoRemaining is the number of the lines between headAndTorso and 
	// the part of the body which coincides stairs.
    for (int torsoRemaining  = stickmanHeight - stairHeight - 4 + frameNumber; torsoRemaining > 0; torsoRemaining--) {
				 
				//emptySpaces before each piece of torso.
				for (int emptySpaces = 1; emptySpaces < frameNumber; emptySpaces++) {
					System.out.print("   ");
				}
				
				System.out.print(" | ");
				System.out.println();
			}

}
 /*This method prints the stairs and the remaining body in each frame.
 Part of the stairs below stickman is not printed in this method.*/
 public static void BodyAndStairs(int frameNumber,int stickmanHeight,int stairHeight) {
	 // "j" refers to the number of the lines of body coinciding with the stairs
	//Legs are not included.
	for (int j = stairHeight; j >= frameNumber; j--) {
		 
		//emptySpaces refers to the number of the white spaces before "|"
		for (int emptySpaces = 1; emptySpaces < frameNumber; emptySpaces++) {
			System.out.print("   ");
		}
		
		System.out.print(" | ");
		 
		//Empty spaces between body and the stairs
		for (int emptySpaces = 0; emptySpaces < j - frameNumber + 1; emptySpaces++) {
			System.out.print("   ");
		} 
		
		System.out.print("___");
		System.out.print("|");
		
		// k is used to increase the number of the stars in each loop execution.
		for (int k = 0; k < stairHeight - j; k++) { 

			System.out.print("***");
		}
		
		System.out.print("|");
		System.out.println();
	}
	//Until here body excluding legs are printed.
	
	//Empty Spaces before legs
	for (int emptySpaces = 1; emptySpaces < frameNumber; emptySpaces++) {
		System.out.print("   ");
	}
	
	System.out.print("/ \\___|"); 
	
	//j is used to increase the number of the stars.
	for (int j = stairHeight; j - frameNumber >= 0; j--) {
		System.out.print("***");
	}
	System.out.println("|"); 

}
/* Part of the stairs below stickman and the 
   empty 3 lines are printed in this method. */
public static void StairsDown(int frameNumber,int stickmanHeight,int stairHeight) {
	   
	int z = frameNumber; //I needed a variable equals to the frameNumber and  
	// decreasing after second nested loop. I explained its function where i decreased it.
	
	int a = 0; //I needed a variable increasing after the third nested loop starting from 0.
	           //I explained its function where i increased it.
	
	 //stepNumber is used to control number of the stair lines below Stickman.
	for (int stepNumber = stairHeight - 1; stepNumber > stairHeight - frameNumber; stepNumber--) { 
																
		//emptySpaces is used to print white spaces below the Stickman. 
		for (int emptySpaces = 1; emptySpaces < z; emptySpaces++) {
			System.out.print("   ");
		}
		z--; // So when previous loop executes again there will be 3 less spaces.
		
		System.out.print("___|");

		// "k" is constant so "a" and "frameNumber" 
		// determines the number of the stars in each loop.
		for (int k = stairHeight; k > frameNumber - 2 - a; k--) { 

			System.out.print("***");
		} 
		a++; // So when previous loop executes again there will be 3 more stars.
		System.out.print("|");
		System.out.println();
	}
	
	System.out.println("\n\n"); //Empty 3 lines.
}
}

