myhome = '/Users/carmen';
%%%para a�adir funciones genericas
mymatlab_home=[myhome,'/datos']
path(mymatlab_home,path);
%para a�adir toolkits que se est�n desarrollando
mymatlabsrc_home=[myhome,'/datos/experimentos']
path(mymatlabsrc_home,path);
%%%para a�adir el toolkit de grafos
entropy_myhome = [mymatlabsrc_home,'/entropy_triangle']
path(entropy_myhome,path);