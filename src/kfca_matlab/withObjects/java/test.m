javaaddpath ./bin/
mt=test.MatrixTests
m=rand(5,3);

mt.print()

mb=m>0.5
mt.transpose(mb)