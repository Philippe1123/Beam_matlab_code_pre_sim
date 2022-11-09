function [ output_args ] = Dirk_Plotter_3( input_args )
%DIRK_PLOTTER Summary of this function goes here
%   Detailed explanation goes here
 close all
res={};
res{1}=Dirk_Solver_L_JULIA_MATLAB_READ_IN_3(1,0,0);
 res{2}=Dirk_Solver_L_JULIA_MATLAB_READ_IN_3(2,0,0);
res{3}=Dirk_Solver_L_JULIA_MATLAB_READ_IN_3(3,0,0);

 res{4}=Dirk_Solver_L_JULIA_MATLAB_READ_IN_3(4,0,0);

res{5}=Dirk_Solver_L_JULIA_MATLAB_READ_IN_3(5,0,0);

for id=1:5
    
    plot(res{id}(:,1),res{id}(:,2),'*')
    hold on
end
legend('1','2','3','4','5')
end

