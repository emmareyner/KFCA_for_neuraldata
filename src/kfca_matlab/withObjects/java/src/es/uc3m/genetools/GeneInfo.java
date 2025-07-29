package es.uc3m.genetools;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;

public class GeneInfo {
	
	final static String COL="\"";
	final static String SEP="\",\"";
	final static String EMPTY="---";
	final static String SEP_GO1=" /// ";
	final static String SEP_GO2=" // ";
	
	public GeneInfo(){		
	}
	
	public HashMap<String,Object[]> getGeneDescription(String fileName,String strGeneNames[]){
		HashMap<String,Object[]> geneDescriptions=new HashMap<String,Object[]>();
		
		ArrayList<String> listGeneNames=new ArrayList<String>(Arrays.asList(strGeneNames));

		
		try{
			FileInputStream fstream = new FileInputStream(fileName);
			// Get the object of DataInputStream
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
			String probeSetID;
			String[] M;
            String description; //Target Description
            String geneID; //Representative Public ID
            String agiName; //AGI
            String geneTitle; //Gene Title
            String geneSymbol; //Gene Symbol
            
			//Read File Line By Line
			while ((strLine = br.readLine()) != null)   {
			  // Print the content on the console
				if (strLine.length()>100){
					probeSetID=strLine.substring(1, strLine.indexOf(COL, 2));
					if (listGeneNames.remove(probeSetID)){
						M=strLine.substring(1, strLine.length()-2).split(SEP);
												
			            description=M[7]; //Target Description
			            geneID=M[8]; //Representative Public ID
			            agiName=M[25]; //AGI
			            geneTitle=M[13]; //Gene Title
			            geneSymbol=M[14]; //Gene Symbol
/*
			            String[][] goBP=getGO(M[30]); //Gene Ontology Biological Process
			            String[][] goCC=getGO(M[31]); //Gene Ontology Cellular Component
			            String[][] goMF=getGO(M[32]); //Gene Ontology Molecular Function
			            
			            String pathway=M[33]; //Pathway
			            */            
			            Object[] data={description,geneID,agiName,geneTitle,geneSymbol};
			            geneDescriptions.put(probeSetID,data);
			            
			           
																		
					}
				
				}
				
			}
			//Close the input stream
			in.close();
		  }catch (Exception e){//Catch exception if any
			  System.err.println("Error: " + e.getMessage());
		  }
		  
		
		

		
		return geneDescriptions;		
	}

	private String[][] getGO(String goStr){
		String[][] goArray=null;
		if (!EMPTY.equals(goStr)){
		    String[] goEntry=goStr.split(SEP_GO1);
		    goArray=new String[goEntry.length][];
		    for (int i=0;i<goEntry.length;i++){
		        goArray[i]=goEntry[i].split(SEP_GO2);
		    }
		}
		return goArray;
	}
	
	
	
	
	public String[] getGODescription(String fileName,String goID){
		String[] goDescriptions=null;
		String id_goID="id: "+goID;
		try{
			FileInputStream fstream = new FileInputStream(fileName);
			// Get the object of DataInputStream
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
			while ((strLine = br.readLine()) != null)   {
				if (strLine.startsWith("[Term]")){
					String goTermID = br.readLine();
					if (goTermID!=null && goTermID.startsWith(id_goID)){
						GeneOntology go=GeneOntology.parseGO(goID,br);
						goDescriptions=go.getAsArray();
						/*
						goDescriptions=new String[4];
						goDescriptions[0]=br.readLine();
						goDescriptions[1]=br.readLine();						
						goDescriptions[2]=br.readLine();
						if (goDescriptions[2].startsWith("alt_id:")){
							goDescriptions[2]=br.readLine();	
						}
						goDescriptions[3]=br.readLine();
						*/
						break;
					}				
				}
			}		
		in.close();
		}catch (Exception e){//Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}
		return goDescriptions;
		
	}
	
	public String[] getGOOnlyChilds(String fileName,String goIDs[]){
		if (goIDs==null || goIDs.length<=0)
			return new String[0];
		
		ArrayList<GeneOntology> goIDsNoChilds=new ArrayList<GeneOntology>();
		ArrayList<GeneOntology> parsedGOs=new ArrayList<GeneOntology>();
		
		
		ArrayList<String> goIDsInput=new ArrayList<String>(Arrays.asList(goIDs));
		
		try{
			FileInputStream fstream = new FileInputStream(fileName);
			// Get the object of DataInputStream
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
			while ((strLine = br.readLine()) != null)   {
				if (strLine.startsWith("[Term]")){
					String goTermID = br.readLine();
					if (goTermID!=null){
						Iterator<String> it=goIDsInput.iterator();
						
						while(it.hasNext()){
							String goID=it.next();					
							if (goTermID.startsWith("id: "+goID)){
								GeneOntology go=GeneOntology.parseGO(goID,br);
								parsedGOs.add(go);
								
								
								goIDsInput.remove(goID);
								break;
							}
						}						
					}
				}
			}
			in.close();
		}catch (Exception e){//Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}
		
		Iterator<GeneOntology> it=parsedGOs.iterator();
		while(it.hasNext()){
			GeneOntology go=it.next();
			goIDsNoChilds.add(go);
		}
		
		it=parsedGOs.iterator();
		while(it.hasNext()){
			GeneOntology go=it.next();
			if (go.getIs_a()!=null) {
				Iterator<String> its=go.getIs_a().iterator();
				while(its.hasNext()){
					String parentID=its.next();
					goIDsNoChilds.remove(new GeneOntology(parentID));
				}
			}
		}
		
		
		return GeneOntology.extractArrayIDs(goIDsNoChilds);
		
	}
	
}