function [  ] = GenerateMeshes_12_closestgP(  )
close all


%x_full{4}=[-0.968160239507626,-0.968160239507626;-0.968160239507626,-0.836031107326636;-0.968160239507626,-0.613371432700590;-0.968160239507626,-0.324253423403809;-0.968160239507626,0;-0.968160239507626,0.324253423403809;-0.968160239507626,0.613371432700590;-0.968160239507626,0.836031107326636;-0.968160239507626,0.968160239507626;-0.836031107326636,-0.968160239507626;-0.836031107326636,-0.836031107326636;-0.836031107326636,-0.613371432700590;-0.836031107326636,-0.324253423403809;-0.836031107326636,0;-0.836031107326636,0.324253423403809;-0.836031107326636,0.613371432700590;-0.836031107326636,0.836031107326636;-0.836031107326636,0.968160239507626;-0.613371432700590,-0.968160239507626;-0.613371432700590,-0.836031107326636;-0.613371432700590,-0.613371432700590;-0.613371432700590,-0.324253423403809;-0.613371432700590,0;-0.613371432700590,0.324253423403809;-0.613371432700590,0.613371432700590;-0.613371432700590,0.836031107326636;-0.613371432700590,0.968160239507626;-0.324253423403809,-0.968160239507626;-0.324253423403809,-0.836031107326636;-0.324253423403809,-0.613371432700590;-0.324253423403809,-0.324253423403809;-0.324253423403809,0;-0.324253423403809,0.324253423403809;-0.324253423403809,0.613371432700590;-0.324253423403809,0.836031107326636;-0.324253423403809,0.968160239507626;0,-0.968160239507626;0,-0.836031107326636;0,-0.613371432700590;0,-0.324253423403809;0,0;0,0.324253423403809;0,0.613371432700590;0,0.836031107326636;0,0.968160239507626;0.324253423403809,-0.968160239507626;0.324253423403809,-0.836031107326636;0.324253423403809,-0.613371432700590;0.324253423403809,-0.324253423403809;0.324253423403809,0;0.324253423403809,0.324253423403809;0.324253423403809,0.613371432700590;0.324253423403809,0.836031107326636;0.324253423403809,0.968160239507626;0.613371432700590,-0.968160239507626;0.613371432700590,-0.836031107326636;0.613371432700590,-0.613371432700590;0.613371432700590,-0.324253423403809;0.613371432700590,0;0.613371432700590,0.324253423403809;0.613371432700590,0.613371432700590;0.613371432700590,0.836031107326636;0.613371432700590,0.968160239507626;0.836031107326636,-0.968160239507626;0.836031107326636,-0.836031107326636;0.836031107326636,-0.613371432700590;0.836031107326636,-0.324253423403809;0.836031107326636,0;0.836031107326636,0.324253423403809;0.836031107326636,0.613371432700590;0.836031107326636,0.836031107326636;0.836031107326636,0.968160239507626;0.968160239507626,-0.968160239507626;0.968160239507626,-0.836031107326636;0.968160239507626,-0.613371432700590;0.968160239507626,-0.324253423403809;0.968160239507626,0;0.968160239507626,0.324253423403809;0.968160239507626,0.613371432700590;0.968160239507626,0.836031107326636;0.968160239507626,0.968160239507626];
%x_full{3}=[-0.968160239507626,-0.968160239507626;-0.968160239507626,-0.836031107326636;-0.968160239507626,-0.324253423403809;-0.968160239507626,0;-0.968160239507626,0.324253423403809;-0.968160239507626,0.836031107326636;-0.968160239507626,0.968160239507626;-0.836031107326636,-0.968160239507626;-0.836031107326636,-0.836031107326636;-0.836031107326636,-0.324253423403809;-0.836031107326636,0;-0.836031107326636,0.324253423403809;-0.836031107326636,0.836031107326636;-0.836031107326636,0.968160239507626;-0.324253423403809,-0.968160239507626;-0.324253423403809,-0.836031107326636;-0.324253423403809,-0.324253423403809;-0.324253423403809,0;-0.324253423403809,0.324253423403809;-0.324253423403809,0.836031107326636;-0.324253423403809,0.968160239507626;0,-0.968160239507626;0,-0.836031107326636;0,-0.324253423403809;0,0;0,0.324253423403809;0,0.836031107326636;0,0.968160239507626;0.324253423403809,-0.968160239507626;0.324253423403809,-0.836031107326636;0.324253423403809,-0.324253423403809;0.324253423403809,0;0.324253423403809,0.324253423403809;0.324253423403809,0.836031107326636;0.324253423403809,0.968160239507626;0.836031107326636,-0.968160239507626;0.836031107326636,-0.836031107326636;0.836031107326636,-0.324253423403809;0.836031107326636,0;0.836031107326636,0.324253423403809;0.836031107326636,0.836031107326636;0.836031107326636,0.968160239507626;0.968160239507626,-0.968160239507626;0.968160239507626,-0.836031107326636;0.968160239507626,-0.324253423403809;0.968160239507626,0;0.968160239507626,0.324253423403809;0.968160239507626,0.836031107326636;0.968160239507626,0.968160239507626];
%x_full{2}=[-0.968160239507626,-0.968160239507626;-0.968160239507626,-0.324253423403809;-0.968160239507626,0;-0.968160239507626,0.324253423403809;-0.968160239507626,0.968160239507626;-0.324253423403809,-0.968160239507626;-0.324253423403809,-0.324253423403809;-0.324253423403809,0;-0.324253423403809,0.324253423403809;-0.324253423403809,0.968160239507626;0,-0.968160239507626;0,-0.324253423403809;0,0;0,0.324253423403809;0,0.968160239507626;0.324253423403809,-0.968160239507626;0.324253423403809,-0.324253423403809;0.324253423403809,0;0.324253423403809,0.324253423403809;0.324253423403809,0.968160239507626;0.968160239507626,-0.968160239507626;0.968160239507626,-0.324253423403809;0.968160239507626,0;0.968160239507626,0.324253423403809;0.968160239507626,0.968160239507626];
%x_full{1}=[-0.968160239507626,-0.968160239507626;-0.968160239507626,0;-0.968160239507626,0.968160239507626;0,-0.968160239507626;0,0;0,0.968160239507626;0.968160239507626,-0.968160239507626;0.968160239507626,0;0.968160239507626,0.968160239507626];















Path="/home/philippe/Desktop/gmsh-4.4.1-Linux64/bin/gmsh"+" ";
Order=1;
EltOpts.nl='elastoplastic';
 %figure;
foldername="Mesh_Beam_12_p_ref";
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

NumberOfGaussPoints=[3 5 7 9];

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

    
ar=[31,40,41,32,28,4,37,5,1,33,58,43,50,49,42,59,34,51,60,61,52,46,6,55,7,29,22,39,14,13,38,23,30,11,20,21,12,15,56,25,48,10,2,19,3,47,24,57,16,35,76,45,68,17,74,27,66,67,44,77,36,65,26,75,18,71,80,81,72,69,62,79,54,64,8,73,9,53,78,63,70];
    

x=gaussq(NumberOfGaussPoints(end));
 x=x(ar,:);
 x=x(1:(NumberOfGaussPoints(idOrder+1))^2,:);    
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

% [out,id]=sort(GaussPointsCoord(:,2));
% GaussPointsCoord(:,2:3)=GaussPointsCoord(id,2:3); %SORT THEM

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
 plotelem(Nodes,Elements,Types,'numbering','off','GCS','off','LineWidth',3);
 plotnodes(Nodes,'numbering','off','*r','GCS','off','LineWidth',3);
 axis equal
axis([0 5 0 1])
set(gca,'xtick',[])
set(gca,'ytick',[])

% plotnodes(Nodes);
  if(higherOrder==true)
 plotnodes(GaussPointsCoord,'*b');
  end
    end
end
end

