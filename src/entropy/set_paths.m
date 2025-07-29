myhome = '/Users/carmen';
%%%para añadir funciones genericas
mymatlab_home=[myhome,'/datos']
path(mymatlab_home,path);
%para añadir toolkits que se están desarrollando
mymatlabsrc_home=[myhome,'/datos/experimentos']
path(mymatlabsrc_home,path);
%%%para añadir el toolkit de grafos
entropy_myhome = [mymatlabsrc_home,'/entropy_triangle']
path(entropy_myhome,path);