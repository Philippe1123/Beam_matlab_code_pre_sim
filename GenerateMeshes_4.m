function [  ] = GenerateMeshes_3(  )
close all
Path="/home/philippe/Desktop/gmsh-4.4.1-Linux64/bin/gmsh"+" ";
Order=1;
EltOpts.nl='elastoplastic';
 %figure;
foldername="Mesh_Beam_4_p_ref";
numberoflevels_refinement=0;
numberoflevels_order=3;
higherOrder=true;
refinement=false;
switch Order
    case 1
        elementPlane='plane4';
    case 2
        elementPlane='plane9';
    case 3
        elementPlane='plane16';
    case 4
        elementPlane='plane25';
end


MeshName=foldername+"/Beam";
% MeshName="Mesh_Steep_6/versionfive_steeper";

 %Create Geo Unenrolled
  Input=strcat(Path,MeshName);
 Input=char(strcat(Input,'.geo -0'));
 [~,~]=system(Input);
%Generate Meshes
 
 Input=char(Path+" "+foldername+"/Generate_p -2 -save_topology");
 [~,~]=system(Input);


if(higherOrder==true)
 %   NumberOfGaussPoints=[2 3 4 5];

NumberOfGaussPoints=[2 3 4 7];

end


if(higherOrder==false&&refinement==true)
 if(exist(foldername+"/h_ref/")==7)
  rmdir(char(foldername+"/h_ref/"),'s')  
 end
 mkdir(char(foldername+"/h_ref/Julia/"))   
 mkdir(char(foldername+"/h_ref/Matlab/")) 
 
elseif(higherOrder==true&&refinement==false)

    
  if(exist(foldername+"/p_ref/")==7)
  rmdir(char(foldername+"/p_ref/"),'s')  
 end
 mkdir(char(foldername+"/p_ref/Julia/"))   
 mkdir(char(foldername+"/p_ref/Matlab/"))
 
 elseif(higherOrder==true&&refinement==true)
  if(exist(foldername+"/hp_ref/")==7)
  rmdir(char(foldername+"/hp_ref/"),'s')  
 end
 mkdir(char(foldername+"/hp_ref/Julia/"))   
 mkdir(char(foldername+"/hp_ref/Matlab/"))
end


for idRef=0:numberoflevels_refinement
    for idOrder=0:numberoflevels_order
model=gmshread(char(foldername+"/level_"+num2str(idRef)+num2str(idOrder)+".msh"),char(strcat(MeshName,'.geo_unrolled')));
model.Elements.setSectionID(1);
model.Elements.setMaterialID(1);

Nodes=model.getNodeMatrix(model.getNodes('surfaces'));
%Nodes=model.getNodeMatrix(model.getNodes('elements'));
if(idRef==0)
 interm=model.getElements('surfaces');
end
Elements=model.getElementMatrix(model.getElements('surfaces'));

Elements(:,2)=1;
Elements(:,1)=1:1:length(Elements(:,1));

if(size(Elements,2)==29)
    corrvec=[1:17, 21 18 22 19 23 20 24 25];
    El=Elements(:,5:end);
   Elements(:,5:end)=El(:,corrvec);
end

nElem=size(Elements,1);


El=Elements(:,5:end);
Point=Nodes(:,2:3);
Types={1 elementPlane EltOpts};
%  figure
%   hold on
%   plotelem(Nodes,Elements,Types,'numbering','off');
%   plotnodes(Nodes,'numbering','off');


if(higherOrder==false&&refinement==true)
 

PathNodes=foldername+"/h_ref/Julia/"+"Nodes_L_"+num2str(idRef)+num2str(idOrder)+".txt";
PathElements=foldername+"/h_ref/Julia/"+"Elements_L_"+num2str(idRef)+num2str(idOrder)+".txt";
 
dlmwrite(PathNodes,Point,'delimiter',' ','precision',15)
dlmwrite(PathElements,El,'delimiter',' ','precision',15)

PathNodes=foldername+"/h_ref/Matlab/"+"Nodes_L_"+num2str(idRef)+num2str(idOrder)+".txt";
PathElements=foldername+"/h_ref/Matlab/"+"Elements_L_"+num2str(idRef)+num2str(idOrder)+".txt";
 
dlmwrite(PathNodes,Nodes,'delimiter',' ','precision',15)
dlmwrite(PathElements,Elements,'delimiter',' ','precision',15)

elseif(higherOrder==true&&refinement==false)
    

    
 PathNodes=foldername+"/p_ref/Julia/"+"Nodes_L_"+num2str(idOrder)+".txt";
PathElements=foldername+"/p_ref/Julia/"+"Elements_L_"+num2str(idOrder)+".txt";
 
dlmwrite(PathNodes,Point,'delimiter',' ','precision',15)
dlmwrite(PathElements,El,'delimiter',' ','precision',15)

PathNodes=foldername+"/p_ref/Matlab/"+"Nodes_L_"+num2str(idOrder)+".txt";
PathElements=foldername+"/p_ref/Matlab/"+"Elements_L_"+num2str(idOrder)+".txt";
 
dlmwrite(PathNodes,Nodes,'delimiter',' ','precision',15)
dlmwrite(PathElements,Elements,'delimiter',' ','precision',15) 

elseif(higherOrder==true&&refinement==true)
 PathNodes=foldername+"/hp_ref/Julia/"+"Nodes_L_"+num2str(idRef)+num2str(idOrder)+".txt";
PathElements=foldername+"/hp_ref/Julia/"+"Elements_L_"+num2str(idRef)+num2str(idOrder)+".txt";
 
dlmwrite(PathNodes,Point,'delimiter',' ','precision',15)
dlmwrite(PathElements,El,'delimiter',' ','precision',15)

PathNodes=foldername+"/hp_ref/Matlab/"+"Nodes_L_"+num2str(idRef)+num2str(idOrder)+".txt";
PathElements=foldername+"/hp_ref/Matlab/"+"Elements_L_"+num2str(idRef)+num2str(idOrder)+".txt";
 
dlmwrite(PathNodes,Nodes,'delimiter',' ','precision',15)
dlmwrite(PathElements,Elements,'delimiter',' ','precision',15) 

    
end




if(higherOrder==true)
%x=x(1:NumberOfGaussPoints(idOrder+1),:);
% ar=[1 21 25 5 13 7 17 19 9 11 23 15 3 8 12 18  6 14  22 20 4 2 16 24 10];
ar=[1 29 33 5 25 9 37 41 13 17 45 49 21 4 22 32 26 15 43 31 35 47 19 7 3 8 36 30 34 40 12 6 2 11 23 39 27 18 24 46 28 10 14 16 20 38 42 44 48];
 x=gaussq(NumberOfGaussPoints(end));
 x=x(ar,:);
 x=x(1:(NumberOfGaussPoints(idOrder+1))^2,:);
 %x=gaussq(NumberOfGaussPoints(idOrder+1));
x=x';
GaussPoints_Local=[x;ones(1,length(x));ones(1,length(x))];
TriangleCoordLocal=[[-1;-1;1;2],[1;-1;1;2],[1;1;1;1],[-1;1;1;2]];
GaussPointsCoord=[];

for idx=1:nElem
    
  TriangleVertices=Nodes(Elements(idx,5:8),2:3);
  TriangleVertices=TriangleVertices';
  TriangleVertices=[TriangleVertices;[1 1 1 1];[2 2 2 2]];  
  TransformationMatrix=TriangleVertices*inv(TriangleCoordLocal);
  
  GaussPoints_Global=TransformationMatrix*GaussPoints_Local;
  GaussPoints_Global=GaussPoints_Global(1:2,:)';
  GaussPointsCoord=[GaussPointsCoord ;GaussPoints_Global];
  
  
    
end

GaussPointsCoord=[[1:1:length(GaussPointsCoord)]',GaussPointsCoord,zeros(length(GaussPointsCoord),1)];
if(higherOrder==true&&refinement==false)
PathGaussPoints=foldername+"/p_ref/Matlab/"+"GaussPoints_L_"+num2str(idOrder)+".txt";

    elseif(higherOrder==true&&refinement==true)

PathGaussPoints=foldername+"/hp_ref/Matlab/"+"GaussPoints_L_"+num2str(idOrder)+".txt";

end

dlmwrite(PathGaussPoints,GaussPointsCoord,'delimiter',' ','precision',15)

end
% Check mesh

switch idOrder+1
    case 1
        elementPlane='plane4';
    case 2
        elementPlane='plane9';
    case 3
        elementPlane='plane16';
    case 4
        elementPlane='plane25';
end
Types={1 elementPlane EltOpts};


figure
 hold on
 plotelem(Nodes,Elements,Types,'numbering','off');
 plotnodes(Nodes,'numbering','off','*b');

% plotnodes(Nodes);
  if(higherOrder==true)
 plotnodes(GaussPointsCoord,'*r');
  end
    end
end
end

