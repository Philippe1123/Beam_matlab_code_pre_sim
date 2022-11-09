out_p=zeros(8,1)
dof_p=[210,738,1586,2754,4242,6050,4089*2,5313*2]
for id = 0:7

test=dlmread(("full_"+char(num2str(id))+".txt"));
[v1,b1]=find(test==0);
[v,b]=find(test==2.5);
pos = intersect(v1,v);
out_p(id+1)=test(pos,end);

end
figure()
loglog(dof_p,abs(out_p-out_p(end))/abs(out_p(end)),'-*')


out_h=zeros(6,1)
dof_h=[210,738,2754,10626,20865*2,82689*2]
for id = 0:5

test=dlmread(("/home/philippe/Desktop/Beam_matlab/1-thesis/h_ref_res/full_"+char(num2str(id))+".txt"));
[v1,b1]=find(test==0);
[v,b]=find(test==2.5);
pos = intersect(v1,v);
out_h(id+1)=test(pos,end);

end
hold on
loglog(dof_h,abs(out_h-out_p(end))/abs(out_p(end)),'-*')
xlabel("Number of DOF's [/]")
ylabel("relative error [/]")
legend("p-refinement","h-refinement")


grid on
matlab2tikz('floatFormat','%.20f','convergence_beam')

out