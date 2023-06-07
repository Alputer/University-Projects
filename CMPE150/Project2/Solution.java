import java.util.Scanner;

	public class Solution { 
		
		public static void main(String[] args) {
			Scanner console = new Scanner(System.in);
			// I take the inputs.
			String s1 = console.nextLine();
			String s2 = console.nextLine();
			String s3 = console.nextLine();
			String s  = console.nextLine();
			
			
			s = deletingSpaces(s); // I delete the spaces in string. 
			s = inputAlma(s1,s2,s3,s); // I put the values into the variables.
			s = parantez(s); //I calculate the results of the expressions in parantheses..
			s = carpmaVeBolme(s); // Firstly I calculate the multiplications and divisions.
			s = toplamaCikarma(s); // Lastly i calculate the summation and subtraction.
			System.out.println(s); // I print the result.
		}
		public static String toplamaCikarma(String str) {
		     String result = str;
			 int i = 0;       
			int st6 = 1;
			 int p =0; //This will be the last index of the first number.
			while(isDouble(str.charAt(p))){
				
				p++;
			 }
			 
			 double first = Double.parseDouble(str.substring(0,p)); //First number.
			 
			 double sum = first;
		     while(i<str.length()){
		    	 if(str.charAt(i)=='+'){ //index 1 = i+1
		    	  	int index1 = i+1;
		    		 int j = i+1; //j will be the last index of the second
		    		             //number later.
		    	  	
		    		 while(isDouble(str.charAt(j))) {
		    	 
		    			 j++;
		    		 }
		    		 int index2 = j; //Now it is the last index.
		    		 String adds = str.substring(index1,index2); //Second number.
		    		 double add = Double.parseDouble(adds); //Representation of it as double.
		    		                                       //If everyting is int i handle this later.
		    		 sum += add;
		    	 }
		    	 if(str.charAt(i)=='-'){ //Same logic with above. Only i subtract them instead of
		    		                    // summing them. Therefore i did not explain this if statement.
		     	  	int index1 = i+1;
		     		 int j = i+1;
		     	  	
		     		 while(isDouble(str.charAt(j))) {
		     	 
		     			 j++;
		     		 }
		     		 int index2 = j;
		     		 String adds = str.substring(index1,index2);
		     		 double add = Double.parseDouble(adds);
		     		 sum -= add;
		    	 }
		    	 i++;
		     }
		     if(str.contains(".")){ //If it is double i return its value as double.
		    	 result = Double.toString(sum);
		     }
		     else{  //If it is integer i return its value as integer.
		    	 int sumNext = (int)sum ;
		    	 result = Integer.toString(sumNext);
		     }
			
			return result;
			}
		
		public static String carpmaVeBolme(String str){
			String result = str;
			int i =0; // To use in while loop, i increased it at the very end
			while(i<str.length()){ // 
				if(str.charAt(i)=='*'){
				// I will use these indexes to find the numbers which will be multiplicated.
				int index1 = 0; //Not useful for now.
				int index2 = i; //Index2 is created.
				int index3 = 0; //Not useful for now.
				for(int j=i-1;;j--){   
					if(j<=0||j>=str.length()){ break;}
					if(!isDouble(str.charAt(j))){
				     index1 = j+1; //Index1 created(Beginning of the first number.)
				     break;
					}                     
				}                         
				for(int k=i+1;;k++){
					if(k==str.length()-1){ 
					 index3= k; break;	 //Index3 created(End of the first number.)
					}
					else if(!isDouble(str.charAt(k))){
						index3 = k; break; //Index3 created(End of the second number.)
					}
				}
				
				String s1 = str.substring(index1,index2); //First number
				String s2 = str.substring(index2+1,index3); //Second number
				String replaced = s1+"*"+s2; //Substring which will be replaced with its value.
				String mults = ""; //It will be the value.
				if(!s1.contains(".")&&!s2.contains(".")){ //If it is not double.
				 int mult = Integer.parseInt(s1)*Integer.parseInt(s2);
				 mults = Integer.toString(mult); //Value of the operation.
				}
				else { //If it is double.
					double mult = Double.parseDouble(s1)*Double.parseDouble(s2);
					mults = Double.toString(mult); //Value of the operation.
				}
				result = str.replace(replaced,mults); //I replace the expression with its value.
				result = deletingSpaces(result); // I delete spaces if there is.
				str = result;
				i=0;
				}        // If bitti
				if(str.charAt(i)=='/'){ //Same logic with multiplication.Same commands.
					                   //Except for multiplying the numbers, divide them.This is the
					                   // Only difference. Therefore i did not explain their meanings.
					int index1 = 0;
					int index2 = i; 
					int index3 = 0;
					for(int j=i-1;;j--){   
						if(j<=0||j>=str.length()){ break;}
						if(!isDouble(str.charAt(j))){
					     index1 = j+1;
					     break;
						}                     
					}                        
					for(int k=i+1;;k++){
						if(k==str.length()-1){ 
						 index3= k; break;	
						}
						else if(!isDouble(str.charAt(k))){
							index3 = k; break;
						}
					}
					
					String s1 = str.substring(index1,index2);
					String s2 = str.substring(index2+1,index3);
					String replaced = s1+"/"+s2;
					String mults = "";
					if(!s1.contains(".")&& !s2.contains(".")){
					int mult = Integer.parseInt(s1)/ Integer.parseInt(s2);	
					mults = Integer.toString(mult);
					}
					else{
					double mult = Double.parseDouble(s1)/Double.parseDouble(s2);
					
					mults = Double.toString(mult);   }
					
					
					result = str.replace(replaced,mults);
					result = deletingSpaces(result);
					str = result;
					i=0;
				}
				i++;
				
			}
			return result;
			
		}
		 // In this method i calculate the expressions in the string.
		public static String parantez(String str)	{ 
			 int count = 0; //It will be the number of the parantheses.
				for(int i =0;i<str.length();i++){
				if(str.charAt(i)=='('){
					count ++; //Here it gets its actual value.
				}
				}
			 
		for(int j =0;j<count;j++){  //In each for iteration i calculate 1 parantheses.)
			                       // It works for nested parantheses as well.
		int index1 = str.lastIndexOf('('); //I find the index of last parantheses.
		String next = str.substring(index1);
		int index2 = next.indexOf(')');
		String modified = next.substring(1,index2); //String between parantheses.
		modified += ";"; // To circumvent outOfBounds error.
		modified = carpmaVeBolme(modified); //First step for its value.
		modified += ";"; // To circumvent outOfBounds error.
		                 
		modified = toplamaCikarma(modified); //Second and last step of its value.
		int lastindex = str.length()-1; 
		System.out.print(""); // To be honest i don't know its function but
		                     // it prevented an error at some part. And it doesn't hurt
		                    // my code and does not change the result.
		for(int i =index1;;i++){ // To find the index of the ")".
		if(str.charAt(i)==')'){
			 lastindex = i;
			 break;
		
		}
		
			}
String substring = str.substring(index1,lastindex+1); // String including parantheses
                                                      // and expression inside them.
		
		str = str.replace(substring,modified); // Change the expression with its value.
		}
		
		
		return str;
		
		 }
    // In this method I take the variables' values.
public static String inputAlma(String s1,String s2,String s3,String s){
		s1 = deletingSpaces(s1); // I delete the spaces in the strings.
		s2 = deletingSpaces(s2);
		s3 = deletingSpaces(s3);
		String substring1 = ""; //These 3 strings  
		String substring2 = ""; //will be the
		String substring3 = ""; //variable names.
				
		int index1 = s1.lastIndexOf("="); // I take these indexes to divide
		int lasts1 = s1.indexOf(";"); // the string into variable and its value
		int index2 = s2.lastIndexOf("=");
		int lasts2 = s2.indexOf(";");
		int index3 = s3.lastIndexOf("=");
		int lasts3 = s3.indexOf(";");
		
		if(s1.contains("double")){ //If it is double i start from 7th character until 
			//the index of "=" to read its name.
            substring1 = s1.substring(6,index1); // variable1 name
			
		}
		//If it is int i start from 4th character until the index of "=" 
        // to read its name. I do the same things for other strings as well.
		else{ 
			substring1 = s1.substring(3,index1); 
		}
		if(s2.contains("double")){
			substring2 = s2.substring(6,index2); 
			
		}
		else{ 
			substring2 = s2.substring(3,index2);
		}
		if(s3.contains("double")){
			substring3 = s3.substring(6,index3);
		}
		else{ 
			substring3 = s3.substring(3,index3); //same until here.
		}
		String newString1 = s1.substring(index1+1,lasts1); //Value of 1st variable
		String newString2 = s2.substring(index2+1,lasts2); //Value of 2nd variable
		String newString3 = s3.substring(index3+1,lasts3); //Value of 3rd variable
		//These if statements add ".0" if double does not contain decimals like double a = 6;
		if(s1.contains("double")&&!s1.contains(".")){
			newString1 += ".0";
		}
		if(s2.contains("double")&&!s2.contains(".")){
			newString2 += ".0";
		}
		if(s3.contains("double")&&!s3.contains(".")){
			newString3 += ".0";
		}
		
		
		s = s.replace(substring1,newString1); // Finally i change the variable with its value.
		s = s.replace(substring2,newString2);
		s = s.replace(substring3,newString3); 
		
			 
		 return s; 
    }
		//This method deletes the spaces in the given string.
		public static String deletingSpaces(String s){
			String result = "";
			for(int i=0;i<s.length();i++)
			if(s.charAt(i)!= ' '){
				
				result += s.charAt(i);
			}
			
			
			return result;
			
		}
		// This method returns true if char contains a number or dot.("1","2","3"...,"9" or ".")
		public static boolean isDouble(char ch1){
			boolean result = false;
			if(ch1>=48 && ch1<=57){
				result = true;
				
			}
			else if (ch1=='.'){
				result = true;
			}
			
				return result;
			
			}
	}




