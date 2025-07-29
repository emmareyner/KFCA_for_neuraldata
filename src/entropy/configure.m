%% Analisis de matrices de confusion de deteccion de eventos acústicos para
%%INTERSPEECH 2011
clear all
close all
cd ~/datos/experimentos/confusion_matrices/data/audioAsen/

%create all variables
audio_conf%script that loads the variables. CPM-made!
matrices=cell(1,5);
matrices{1} = uint16(Metodo1_M_DS);%media y desviación
matrices{2} = uint16(Metodo1_M_DS_A);%media, desviación y asimetría
matrices{3} = uint16(Metodo1_M_DS_C);%media, desviación y Kurtosis
matrices{4} = uint16(Metodo2);%filtros estáticos
matrices{5} = uint16(Metodo5);%concatenación filtors estáticos+M_DS_A
m=5;

%% Start the processing
colours=['b','b','b','r','k','k'];
shapes=['+','x','s','d','*','p'];
h1=entropy_triangle(matrices{1},'color',colours(1),'linestyle',shapes(1));
h2=entropy_triangle(matrices{1},'split','color',colours(1),'linestyle',shapes(1));
h3=entropy_triangle(matrices{1},'3D','color',colours(1),'linestyle',shapes(1));
for i=2:m
    entropy_triangle(matrices{i},'incremental',h1,'color',colours(i),'linestyle',shapes(i));
    legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
    entropy_triangle(matrices{i},'incremental',h2,'split','color',colours(i),'linestyle',shapes(i));
    legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
    entropy_triangle(matrices{i},'incremental',h3,'3D','color',colours(i),'linestyle',shapes(i));
    legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
end

%legend(gca,'Metodos1-M-DS','Metodo1-M-DS-A','Metodo1-M-DS-C','Metodo2','Metodo5','Location','NorthWest');
