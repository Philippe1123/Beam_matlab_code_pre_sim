function [ output_args ] = Dirk_Plotter( input_args )
%DIRK_PLOTTER Summary of this function goes here
%   Detailed explanation goes here
 close all
res=Dirk_Solver_L_JULIA_MATLAB_READ_IN_(1,0,0);
savefig('1_smooth')
 res=Dirk_Solver_L_JULIA_MATLAB_READ_IN_(2,0,0);
 savefig('2_smooth')
res=Dirk_Solver_L_JULIA_MATLAB_READ_IN_(3,0,0);
 savefig('3_smooth')

 res=Dirk_Solver_L_JULIA_MATLAB_READ_IN_(4,0,0);
 savefig('4_smooth')

res=Dirk_Solver_L_JULIA_MATLAB_READ_IN_(5,0,0);
 savefig('5_smooth')

end

