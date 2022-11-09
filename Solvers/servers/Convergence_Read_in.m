function [ output_args ] = Convergence_Read_in( input_args )
%CONVERGENCE_READ_IN Summary of this function goes here
%   Detailed explanation goes here

Res_h={};

for id=1:4
    
Res_h{id}=dlmread(num2str(id));
%     Res_h{id}=Res_h{id}./1000;
end
res_p=dlmread("p1");




x=[1 1/2 1/4 1/8 1/16 1/32]

figure
loglog(x,x,'--')
hold on
loglog(x,x.^2,'--')
hold on
loglog([1 1/2 1/4 1/8 1/16 1/32 1/64 1/128],[1 1/2 1/4 1/8 1/16 1/32 1/64 1/128].^3,'--')
hold on
loglog(x,x.^4,'--')
hold on
loglog(x,x.^5,'--')

err_1=Res_h{1}-Res_h{4}(end);
loglog(x,abs(err_1))

err_2=Res_h{2}-Res_h{4}(end);
loglog([1 1/2 1/4 1/8 1/16 1/32 1/64 1/128],abs(err_2),'-*')

err_3=Res_h{3}-Res_h{4}(end);
loglog([1 1/2 1/4 1/8 1/16 1/32 1/64 1/128 1/256],abs(err_3),'*-')

err_4=Res_h{4}-Res_h{4}(end);
loglog([1 1/2 1/4 1/8 1/16 1/32 1/64 1/128],abs(err_4(1:end)),'*-')
end

