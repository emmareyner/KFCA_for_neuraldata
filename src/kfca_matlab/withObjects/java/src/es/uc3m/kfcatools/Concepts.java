package es.uc3m.kfcatools;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

public class Concepts {
//javaaddpath /home/jose/thesis/matlab/svn_tsc/java/bin/ 
//c=es.uc3m.kfcatools.Concepts
	
	public void print(){
		System.out.println("****es.uc3m.kfcatools.Concepts**");
	}	
	
	
	public boolean[][] getIntersectionExtents(boolean [][] inputMatrix ){

		int numG=inputMatrix.length;
		
		int[] pending=sumCols(inputMatrix);
		int[] m=sortByCols(pending);
	//	boolean It[][]=transpose(inputMatrix);
		Iterator<boolean[]> it;
		ArrayList<boolean[]> A=new ArrayList<boolean[]>();
		int maximal;
		//for (int maximal=0;maximal<m.length;maximal++){
		for (int k=0;k<m.length;k++){
			maximal=m[k];
		    if (pending[maximal] == 0) break; //end%may be erased by previous exploration
		    
//		    cand=I(:,maximal);%candidate column to be explored

//		    %full extent cannot be in pending cols
//		    lA=size(A,2);
//		    nomatch = any(xor(A(:,2:end),my.logical.mtimes(cand,true(1,lA-1))));%one less columns than A!!
		
		    
		    boolean[] cand=new boolean[numG];
		    for (int i=0; i<numG; i++){
		    	cand[i]=inputMatrix[i][maximal];
	    	}
		    
		//    boolean[] cand=It[maximal];
		    
		    boolean nomatch=true;
		    it=A.iterator();
		    while(it.hasNext()){
		    	boolean[] Acol=it.next();
		    	if (Arrays.equals(Acol, cand)){
		    		nomatch=false;
		    		break;		    				    		
		    	}
		    }
		    if (nomatch){
		    	
		    	boolean[][] nextents=new boolean[A.size()][numG];		    	
		    	it=A.iterator();
		    	int i=0;
		    	while(it.hasNext()){
			    	boolean[] Acol=it.next();
			    	boolean[] extent=nextents[i];
			    	for (int j=0;j<cand.length;j++){
			    		extent[j]=Acol[j]&cand[j];
			    	}
			    	i++;	  					    				    	
			    }
		    	
		    	A.add(cand);
		    	boolean addCol;
		    	for (boolean[] nCol:nextents){
		    		addCol=true;
		    		it=A.iterator();
		    		while(it.hasNext()){
		    			if (Arrays.equals(nCol, it.next())){
		    				addCol=false;
		    				break;
		    			}
		    		}
		    		if (addCol){
		    			A.add(nCol);
		    		}
		    	}		    	
		    }		    		  

		}

		boolean[] topConcept=new boolean[numG];
		Arrays.fill(topConcept, 0, numG, true);
		A.add(0, topConcept);
		
		boolean[][] A_Matrix=new boolean[0][0];//=new boolean[numG][A.size()];
		A_Matrix=A.toArray(A_Matrix);
		/*
		boolean[][] A_Matrix=new boolean[numG][A.size()];
		it=A.iterator();
		int i=0,j=0;
		while(it.hasNext()){
			boolean[] A_col=it.next();
			for (i=0;i<numG;i++){
				A_Matrix[i][j]=A_col[i];
			}
			j++;
		}
		*/
		
		return A_Matrix;
	}

	public int[] sortByCols(int[] inputMatrix){
		int n=inputMatrix.length;
		
		int[] indxMatrix=new int[n];
		int[] sortMatrix=new int[n];
		
		int i,j,aux;
		for (i=0;i<n;i++){
			indxMatrix[i]=i;
			sortMatrix[i]=inputMatrix[i];
		}
		
		for (i=0;i<(n-1);i++){
			
			for (j=(i+1);j<n;j++){
				if (sortMatrix[i]<sortMatrix[j]){
					aux=sortMatrix[i];
					sortMatrix[i]=sortMatrix[j];
					sortMatrix[j]=aux;
					
					aux=indxMatrix[i];
					indxMatrix[i]=indxMatrix[j];
					indxMatrix[j]=aux;
				}
			}
		}
		
		
		return indxMatrix;
	}

	
	public int[] sumCols(boolean[][] inputMatrix){
		int g=inputMatrix.length;
		int m=inputMatrix[0].length;
		int[] sumMatrix=new int[m];
		
		int i;
		for (int j=0;j<m;j++){
			sumMatrix[j]=0;
			for (i=0;i<g;i++){										
				if (inputMatrix[i][j])	sumMatrix[j]++;				
			}
		}
		
		
		return sumMatrix;
	}
	
	public int[] sumRows(boolean[][] inputMatrix){
		int g=inputMatrix.length;
		int m=inputMatrix[0].length;
		int[] sumMatrix=new int[g];
		
		for (int i=0;i<g;i++){
			sumMatrix[i]=0;		
			for (int j=0;j<m;j++){				
				if (inputMatrix[i][j])	sumMatrix[i]++;				
			}
		}				
		return sumMatrix;
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

}
