package test;

import es.uc3m.kfcatools.Concepts;

public class MatrixTests {

	public static void main (String args[]){
		MatrixTests mt=new MatrixTests();
		mt.print();
		System.out.println(">> javaaddpath /home/jose/thesis/matlab/svn_tsc/java/bin/ \n>> mt=test.MatrixTests ");
		
		int nr=5;
		int nc=3;
		double[][] m=new double[nr][nc];
		for (int i=1;i<nr;i++){
			for (int j=1;j<nc;j++){
				m[i][j]=i+j;				
			}
		}
		double [][] mout=mt.transpose(m);
		
		
	    boolean [][] I={{true,true,false,true,false,true,false},
	    				{true,true,false,true,true,false,false},
	    				{true,true,false,true,true,true,true,true},
	    				{true,false,true,false,true,true,false},
	    				{false,true,false,true,false,false,false},
	    				{true,false,false,false,false,true,false}};
	     
	     
	     
	     Concepts concept=new Concepts();
	     boolean[][] A=concept.getIntersectionExtents(I);
	     mt.printMatrix(A);
	     
		
		
	}
	public void print(){
		System.out.println("****MatrixTests*v1.1**");
	}
	
	public double add(double a,double b){
		return a+b;
	}
	
	public double[][] transpose(double [][] inPutMatrix ){
		int nr=inPutMatrix.length;
		int nc=inPutMatrix[0].length;
		double[][] rMatrix=new double[nc][nr];
		for (int i=0;i<nr;i++){
			for (int j=0;j<nc;j++){
				rMatrix[j][i]=inPutMatrix[i][j];
			}
		}
		
		
		return rMatrix;
	}
	
	public boolean[][] transpose(boolean [][] inPutMatrix ){
		int nr=inPutMatrix.length;
		int nc=inPutMatrix[0].length;
		boolean[][] rMatrix=new boolean[nc][nr];
		for (int i=0;i<nr;i++){
			for (int j=0;j<nc;j++){
				rMatrix[j][i]=inPutMatrix[i][j];
			}
		}
		
		
		return rMatrix;
	}
	public void printMatrix(boolean[][] m){
		for (int i=0;i<m.length;i++){
			for (int j=0;j<m[i].length;j++){
				if (m[i][j])
					System.out.print(" 1");
				else
					System.out.print(" 0");
			}
			System.out.println("");
		}
		
	}
}
