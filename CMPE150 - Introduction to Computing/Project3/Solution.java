import java.io.*; 
import java.util.*;

public class Project3Solution {
	public static void main(String[] args) throws FileNotFoundException {

		int mode = Integer.parseInt(args[0]); // 0,1,2,3
		String InputFile = args[1]; // input.ppm
		String Filter = args[2]; // filter.txt(4.part) ya da range(5.part)
									// verilecek.

		if (mode == 0) {
			int[][][] numbers = arrayCreating(InputFile);
			fileCreating(numbers, "output.ppm"); // heralde bunu recursion
													// yapıcaz.
		}
		if (mode == 1) {
			int[][][] numbers = arrayCreating(InputFile);
			gettingAverage(InputFile,"black-and-white.ppm"); // file creating yapıyor bu.
		}
		if (mode == 2) {
			int[][][] numbers = arrayCreating(InputFile);
			
			convolution(InputFile,numbers,Filter); // convolution
			gettingAverage("convolution.ppm","convolution.ppm");
		}
		if(mode == 3){
			int[][][] numbers = arrayCreating(InputFile);
			int range = Integer.parseInt(Filter);
			quantization(numbers,range); //Filter range oluyor.
		}

	}

	
	public static void gettingAverage(String InputFile,String target)
			throws FileNotFoundException {
		int[][][] numbers = arrayCreating(InputFile);
		for (int i = 0; i < numbers.length; i++) {
			for (int j = 0; j < numbers[i].length; j++) {
				int average = 0;
				for (int k = 0; k < 3; k++) {
					average += numbers[i][j][k];
					if (k == 2) {
						numbers[i][j][0] = average / 3;
						numbers[i][j][1] = average / 3;
						numbers[i][j][2] = average / 3;
					}
				}
			}
		}
		fileCreating(numbers, target);

	}

	public static void convolution(String InputFile,int[][][]numbers,String Filter)throws FileNotFoundException{
		
		
		Scanner conv = new Scanner(new File(Filter));
		String s = conv.next();
		s = s.substring(0,1);
		int m = Integer.parseInt(s);
		int n = m;
		conv.nextLine();
		int[][] filter = new int[m][n];
		for(int i=0;i<m;i++){
			for(int j=0;j<n;j++){
				filter[i][j] = conv.nextInt();
				
			}
		} //filter oluşturuldu.
		int row = numbers.length-2;
		int column = numbers.length-2;
		int[][][] convoluted = new int[row][column][3];
		for(int k=0;k<3;k++){ 
		for(int i=0;i<row;i++){
			for(int j=0;j<column;j++){
				int convedvalue = 0;
				for(int a=0;a<3;a++){
					for(int b=0;b<3;b++){
						convedvalue += numbers[i+a][j+b][k]*filter[a][b];
					}
				}
				convoluted[i][j][k]=convedvalue; //convoluted array oluştu.
				if(convoluted[i][j][k]<0){
					convoluted[i][j][k]=0;
				}
				if(convoluted[i][j][k]>255){
					convoluted[i][j][k]=255;
				}
			}
		} 
	}// son for
		fileCreating(convoluted,"convolution.ppm");
		
	
	}
	public static void quantization(int[][][]quant,int range)throws FileNotFoundException{
		int i = quant.length;
		int j = quant[0].length;
		int[][][] sol = new int[i][j][3];
		boolean[][][] check = new boolean[i][j][3];
		for(int a=0;a<check.length;a++){
			for(int b=0;b<check[a].length;b++){
				for(int c=0;c<3;c++){
				 check[a][b][c]= true;
				}
			}
		}
		
		
		
		
		for(int k=0;k<3;k++){
		for(int m=0;m<quant.length;m++){
			for(int n=0;n<quant[0].length;n++){
				
				     int basepixel=0;
				     if(sol[m][n][k]==0){
					 basepixel= quant[m][n][k];}
				     if(sol[m][n][k]!=0){
				    	  basepixel= sol[m][n][k];}
					quantizationUtil(quant,range,m,n,k,sol,check,basepixel);
					
				}
		    }
		}
		 //solution array oluştu.
		                                             
		fileCreating(sol,"quantization.ppm");
		}
	public static void quantizationUtil(int[][][]quant,int range,int x,int y,int z,int[][][]sol,boolean[][][] check,int basepixel){
		
		
		if(isSafe(quant,check,x,y,z,range,basepixel)){ //indexler doğru mu, daha önce değişmiş mi.
			sol[x][y][z] = basepixel;
			check[x][y][z] = false;
			
			
			quantizationUtil(quant,range,x+1,y,z,sol,check,basepixel); //sıraları önemli değil.
			quantizationUtil(quant,range,x-1,y,z,sol,check,basepixel);
			quantizationUtil(quant,range,x,y+1,z,sol,check,basepixel);
			quantizationUtil(quant,range,x,y-1,z,sol,check,basepixel);
			quantizationUtil(quant,range,x,y,z+1,sol,check,basepixel);
			quantizationUtil(quant,range,x,y,z-1,sol,check,basepixel);
			
			
		}
		
	}
	public static boolean isSafe(int[][][]quant,boolean[][][]check,int x,int y,int z,int range,int basepixel){
		return(x>=0 &&x< quant.length &&y>=0 && y<quant[0].length &&z>=0 &&z<3 && check[x][y][z]&&Math.abs(basepixel-quant[x][y][z])<=range);
	}

	// Part1 gibi düşünebiliriz.
	// File'den array dönüyor.
	public static int[][][] arrayCreating(String InputFile)
			throws FileNotFoundException {
		File f = new File(InputFile);
		Scanner input = new Scanner(f);

		input.nextLine();
		int i = input.nextInt(); // 128
		int j = input.nextInt(); // 128

		input.nextInt(); // max quantayı geçmek için.
		int numbers[][][] = new int[i][j][3];

		for (int m = 0; m < numbers.length; m++) { // rowu donuyor.
			for (int n = 0; n < numbers[m].length; n++) {
				for (int k = 0; k < 3; k++) {
					numbers[m][n][k] = input.nextInt();
				}

			}
		}
		return numbers;
	}
	// Part2.Girilen file'ın kopyasını oluşturuyor.
		public static void fileCreating(int[][][] numbers, String name)
				throws FileNotFoundException {

			int i = numbers.length;
			int j = numbers[1].length; // nur topu gibi array'imiz var.

			PrintStream output = new PrintStream(new File(name)); // output file
																	// oluştu.
			output.println("P3");
			output.println(i + " " + j);
			output.println("255");
			for (int m = 0; m < numbers.length; m++) { // rowu donuyor.
				for (int n = 0; n < numbers[m].length; n++) {
					for (int k = 0; k < 3; k++) {
						output.print(numbers[m][n][k]);
						if (k != 2) {
							output.print(" ");
						} else {
							output.print("\t");
						}
					}
				}
			}

		}


		
	}
