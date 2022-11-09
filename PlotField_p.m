function [ output_args ] = PlotField( )
%PLOTFIELD Summary of this function goes here
%   Detailed explanation goes here


%% Save nodes and elements

proc=3;

for id=3:3
 
 

%%%%Field Read In
 PathNodes="/home/philippe/Desktop/Beam_matlab/Mesh_Beam_3_p_ref/p_ref/Matlab/GaussPoints_L_"+id+".txt";
 PathElements="/home/philippe/Desktop/Beam_matlab/Mesh_Beam_3_p_ref/p_ref/Matlab/Elements_L_"+id+".txt";
Field="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Interm/Beam/E_"+id+"_"+proc;

 Elements=dlmread(PathElements);
 Nodes=dlmread(PathNodes);
Field=dlmread(Field);

vecx=min(Nodes(:,2)):(max(Nodes(:,2))-min(Nodes(:,2)))/(length(unique(Nodes(:,2)))-1):max(Nodes(:,2))
vecy=min(Nodes(:,3)):(max(Nodes(:,3))-min(Nodes(:,3)))/(length(unique(Nodes(:,3)))-1):max(Nodes(:,3))

[xq,vq]=meshgrid(vecx,vecy);
zq=griddata(Nodes(:,2),Nodes(:,3),Field,xq,vq);

 figure
 surf(xq,vq,zq);
 axis equal
view(2)
axis([0 2.5 0 0.25])
 %Name=char("level"+id);
% Plot2LaTeX(figure(id+1),Name)
end
%figure
%stem3(centers_coord(:,1),centers_coord(:,2),c_centers,'r')

end

