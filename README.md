# KFCA_for_neuraldata
This repository performs  a full analysis of chemosensory responses in C. elegans using K-FCA

This code corresponds to the analysis performed by Emma Reyner-Fuentes, Carmen Peláez-Moreno and Francisco J. Valverde-Albacete for the paper "Cracking the C. elegans Neural Code: A Conceptual Map of Sensory Processing", currently submitted for review in PLOS Computational Biology.

To run this code, you will need the toolboxes "kfca_matlab", and "Maxminplus_toolbox" that you can find in [FJValverde's profile](https://github.com/FJValverde). 

This code utilizes one function for NaN imputation written by Jicong Fan, 09/2019. E-mail: jf577@cornell.edu from the following paper: Factor Group-Sparse Regularization for Efficient Low-Rank Matrix Recovery. Jicong Fan, Lijun Ding, Yudong Chen, Madeleine Udell. NeurIPS 2019. Written by Jicong Fan, 09/2019. E-mail: jf577@cornell.edu. It also used some scripts from the former toolbox "phonmat", written by Dinoj Surendran, dinoj@cs.uchicago.edu (no longer available online) that are included in the src folder of this repository.

As for the data, to replicate our analysis you will need to download the data from the paper Lin A, Qin S, Casademunt H, Wu M, Hung W, Cain G, Tan NZ, Valenzuela R, Lesanpezeshki L, Venkatachalam V, Pehlevan C, Zhen M, Samuel ADT. Functional imaging and quantification of multineuronal olfactory responses in C. elegans. Sci Adv. 2023 Mar;9(9):eade1249. doi: 10.1126/sciadv.ade1249. Epub 2023 Mar 1. PMID: 36857454; PMCID: PMC9977185. Their repository is in [zenodo](https://zenodo.org/records/7563053, DOI: zenodo.7563053) and the specific data we used is in 
CElegans Chemosensory Data/Compiled Neural Data. You should download the concentrations 4, 5 and 6 and place them in data/input/Compiled Neural Data. The main script automatically downloads the data and places it in the proper folder.

However, feel free to use the livescript with your own data, since the method we here present allows for the analysis of any graded matrix.
