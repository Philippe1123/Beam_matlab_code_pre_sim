function [ output_args ] = Run(  )
%DIRK_PLOTTER Summary of this function goes here
%   Detailed explanation goes here
 close all
res=[];
res(1)=Solver_L_JULIA_MATLAB_READ_IN_2(1,0,0);
 res(2)=Solver_L_JULIA_MATLAB_READ_IN_2(2,0,0);
res(3)=Solver_L_JULIA_MATLAB_READ_IN_2(3,0,0);

 res(4)=Solver_L_JULIA_MATLAB_READ_IN_2(4,0,0);

res(5)=Solver_L_JULIA_MATLAB_READ_IN_2(5,0,0);

res(6)=Solver_L_JULIA_MATLAB_READ_IN_2(6,0,0);
res(7)=Solver_L_JULIA_MATLAB_READ_IN_2(7,0,0);
res(8)=Solver_L_JULIA_MATLAB_READ_IN_2(8,0,0);
res(9)=Solver_L_JULIA_MATLAB_READ_IN_2(9,0,0);
res(10)=Solver_L_JULIA_MATLAB_READ_IN_2(10,0,0);

diff=[]

diff(1)=res(end)-res(end-1)
diff(2)=res(end-1)-res(end-2)
diff(3)=res(end-2)-res(end-3)
diff(4)=res(end-3)-res(end-4)
diff(5)=res(end-4)-res(end-5)
diff(6)=res(end-5)-res(end-6)
diff(7)=res(end-6)-res(end-7)
diff(8)=res(end-7)-res(end-8)
diff(9)=res(end-8)-res(end-9)


figure
semilogy(res,'-*')
figure
semilogy(diff,'-*')
end

