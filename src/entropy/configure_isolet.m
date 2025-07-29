%% Analisis de matrices de confusion de deteccion de eventos acústicos para
%%INTERSPEECH 2011
clear all
close all
cd ~/datos/experimentos/confusion_matrices/data/isolet_sira/MFCC/clean-clean/

%create all variables
MFCC_cc_2000_5000
MFCC_cc_200_1200
MFCC_cc_200_2500
MFCC_cc_200_300
MFCC_cc_200_400
MFCC_cc_200_5000
MFCC_cc_200_600
MFCC_cc_200_6500
MFCC_cc_2500_5000
MFCC_cc_3000_5000
MFCC_cc_4500_5000
matrices{8}=uint16(MFCC_cc_2000_5000Hz);
matrices{4}=uint16(MFCC_cc_200_1200Hz);
matrices{5}=uint16(MFCC_cc_200_2500Hz);
matrices{1}=uint16(MFCC_cc_200_300Hz);
matrices{2}=uint16(MFCC_cc_200_400Hz);
matrices{6}=uint16(MFCC_cc_200_5000Hz);
matrices{3}=uint16(MFCC_cc_200_600Hz);
matrices{7}=uint16(MFCC_cc_200_6500Hz);
matrices{9}=uint16(MFCC_cc_2500_5000Hz);
matrices{10}=uint16(MFCC_cc_3000_5000Hz);
matrices{11}=uint16(MFCC_cc_4500_5000Hz);


m=11;

%% Start the processing
colours=['b','b','b','b','b','b','b','r','r','r','r','k','k','b','b','b','b','b'];
shapes=['+','x','s','d','*','p','h','+','x','s','d','*','p','+','x','s','d','*','p'];
h1=entropy_triangle(matrices{1},'color',colours(1),'linestyle',shapes(1));
h2=entropy_triangle(matrices{1},'split','color',colours(1),'linestyle',shapes(1));
h3=entropy_triangle(matrices{1},'3D','color',colours(1),'linestyle',shapes(1));
for i=2:m
    entropy_triangle(matrices{i},'incremental',h1,'color',colours(i),'linestyle',shapes(i));
    %legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
    entropy_triangle(matrices{i},'incremental',h2,'split','color',colours(i),'linestyle',shapes(i));
    %legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
    entropy_triangle(matrices{i},'incremental',h3,'3D','color',colours(i),'linestyle',shapes(i));
    %legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
end

%legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
