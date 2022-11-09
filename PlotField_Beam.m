function [ output_args ] = PlotField( )
%PLOTFIELD Summary of this function goes here
%   Detailed explanation goes here


%% Save nodes and elements


 Data="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/Testing_Fields/Data"
 Lvl="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/Testing_Fields/lvl"
 
 order=dlmread(Data);
 level=dlmread(Lvl);
 ll=dlmread(Lvl)+1;
 ar=[3 5 7 9];
 if(order==0)
     
 PathNodes_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/h_refinement/Nodes_L_"+level+".txt";
 PathElements_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/h_refinement/Elements_L_"+level+".txt";
 Nodes_Fines=dlmread(PathNodes_Fine);
 Elements_Fine=dlmread(PathElements_Fine);
 
 PathField_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/Testing_Fields/Fine";
 Field_Fine=dlmread(PathField_Fine);
%  
 level=level-1;
 if(level>0)
  PathNodes_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/h_refinement/Nodes_L_"+level+".txt";
 PathElements_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/h_refinement/Elements_L_"+level+".txt";
 Nodes_C=dlmread(PathNodes_Fine);
 Elements_C=dlmread(PathElements_Fine);
 
  
 PathField_Coarse="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/Testing_Fields/Coarse";
 Field_C=dlmread(PathField_Coarse);
 end
 
 
 % % %     file_nodes_centers_f="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/h_refinement/ElementsCenter_L_"+level+".txt";
% % %     nodes_centers_f=dlmread(file_nodes_centers_f);
% % % %    Field_Fine_centers=griddata(Nodes_Fines(:,2),Nodes_Fines(:,3),Field_Fine,nodes_centers_f(:,1),nodes_centers_f(:,2),'cubic');  % Cohesion in N/m^2
% % %      
% % % 
% % % %  
% % %  PathField_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/Testing_Fields/Fine";
% % %   Field_Fine_centers=dlmread(PathField_Fine);
 
 elseif(order==1)
      
 PathNodes_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/p_refinement/Nodes_L_"+"0"+".txt";
 PathElements_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/p_refinement/Elements_L_"+level+".txt";
 Nodes_l0=dlmread(PathNodes_Fine);
  PathNodes_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/p_refinement/GaussPoints_L_"+level+".txt";
 Nodes_Fines=dlmread(PathNodes_Fine);
 Elements_Fine=dlmread(PathElements_Fine);
 
 PathField_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/Testing_Fields/Fine";
 Field_Fine=dlmread(PathField_Fine);
%  
 level=level-1;
  if(level>0)

  PathNodes_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/p_refinement/GaussPoints_L_"+level+".txt";
 PathElements_Fine="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/p_refinement/Elements_L_"+level+".txt";
 Nodes_C=dlmread(PathNodes_Fine);
 Elements_C=dlmread(PathElements_Fine);
 
  
 PathField_Coarse="/home/philippe/.julia/dev/Applications/applications/SPDE/data/Mesh/Beam/Testing_Fields/Coarse";
 Field_C=dlmread(PathField_Coarse);
  end
 end


%%%%Field Read In


% % % vecx_F=min(nodes_centers_f(:,1)):(max(nodes_centers_f(:,1))-min(nodes_centers_f(:,1)))/(length(unique(nodes_centers_f(:,1)))-1):max(nodes_centers_f(:,1))
% % % vecy_F=min(nodes_centers_f(:,2)):(max(nodes_centers_f(:,2))-min(nodes_centers_f(:,2)))/(length(unique(nodes_centers_f(:,2)))-1):max(nodes_centers_f(:,2))
% % % 
% % % [xq,vq]=meshgrid(vecx_F,vecy_F);
% % % zq=griddata(nodes_centers_f(:,1),nodes_centers_f(:,2),Field_Fine_centers,xq,vq);
% % % 
% % %  figure
% % %  surf(xq,vq,zq);
% % % %   axis equal
% % % %  view(2)
% % % %  axis([0 5 0 1])


%%%%%%%Fine
if(order==0)
vecx_F=min(Nodes_Fines(:,2)):(max(Nodes_Fines(:,2))-min(Nodes_Fines(:,2)))/(length(unique(Nodes_Fines(:,2)))-1):max(Nodes_Fines(:,2))
vecy_F=min(Nodes_Fines(:,3)):(max(Nodes_Fines(:,3))-min(Nodes_Fines(:,3)))/(length(unique(Nodes_Fines(:,3)))-1):max(Nodes_Fines(:,3))

[xq,vq]=meshgrid(vecx_F,vecy_F);
zq=griddata(Nodes_Fines(:,2),Nodes_Fines(:,3),Field_Fine,xq,vq);

 figure
 g=surf(xq,vq,zq);
   set(g,'linestyle','none');

 axis equal
view(2)
axis([0 5 0 1])
set(gca,'xtick',[])
set(gca,'ytick',[])
else
vecx_F=min(Nodes_l0(:,2)):(max(Nodes_l0(:,2))-min(Nodes_l0(:,2)))/(ar(ll)*(length(unique(Nodes_l0(:,2)))-1.)):max(Nodes_l0(:,2));
vecy_F=min(Nodes_l0(:,3)):(max(Nodes_l0(:,3))-min(Nodes_l0(:,3)))/(ar(ll)*(length(unique(Nodes_l0(:,3)))-1.)):max(Nodes_l0(:,3));
 [xq,vq]=meshgrid(vecx_F,vecy_F);
zq=griddata(Nodes_Fines(:,2),Nodes_Fines(:,3),Field_Fine,xq,vq);
zq(end,:)=zq(end-1,:)
zq(:,end)=zq(:,end-1)
zq(1,:)=zq(2,:)
zq(:,1)=zq(:,2)

 figure
 g=surf(xq,vq,zq);
   set(g,'linestyle','none');

 axis equal
view(2)
axis([0 5 0 1])
 set(gca,'xtick',[])
 set(gca,'ytick',[])
    
end


%%%%%Coarse



vecx_F=min(Nodes_C(:,2)):(max(Nodes_C(:,2))-min(Nodes_C(:,2)))/(length(unique(Nodes_C(:,2)))-1):max(Nodes_C(:,2))
vecy_F=min(Nodes_C(:,3)):(max(Nodes_C(:,3))-min(Nodes_C(:,3)))/(length(unique(Nodes_C(:,3)))-1):max(Nodes_C(:,3))

[xq,vq]=meshgrid(vecx_F,vecy_F);
zq=griddata(Nodes_C(:,2),Nodes_C(:,3),Field_C,xq,vq);

 figure
 surf(xq,vq,zq);
 axis equal
view(2)
axis([0 5 0 1])
set(gca,'xtick',[])
set(gca,'ytick',[])

 %Name=char("level"+id);
% Plot2LaTeX(figure(id+1),Name)
%figure
%stem3(centers_coord(:,1),centers_coord(:,2),c_centers,'r')

end

