function [  ] = GenerateMeshes_h_Order_8(  )
close all
Path="/home/philippe/Desktop/gmsh-4.4.1-Linux64/bin/gmsh"+" ";
Order=1;
EltOpts.nl='elastoplastic';
 %figure;
foldername="Mesh_Beam_h_Order_8";
numberoflevels_refinement=2;
numberoflevels_order=0;
higherOrder=false;
refinement=true;
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
 
 Input=char(Path+" "+foldername+"/Generate_h -2 -save_topology");
 [~,~]=system(Input);


if(higherOrder==true)
 %   NumberOfGaussPoints=[2 3 4 5];

NumberOfGaussPoints=[11];

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
   
elseif(size(Elements,2)==40)  
 corrvec=[1:21, 25 26 22 27 28 23 29 30 24 31 32 33 34 35 36];
    El=Elements(:,5:end);
   Elements(:,5:end)=El(:,corrvec);  
   
   
   elseif(size(Elements,2)==53)  
 corrvec=[1:25, 29:31,26,32:34,27,35:37,28,38:41, 45, 42,46,43,47,44,48,49];
    El=Elements(:,5:end);
   Elements(:,5:end)=El(:,corrvec); 
   
      elseif(size(Elements,2)==68)  
 corrvec=[1:29,33:36,30,37:40,31,41:44,32,45:49,53:54,50,55:56,51,57:58,52,59:64];
    El=Elements(:,5:end);
   Elements(:,5:end)=El(:,corrvec); 
   
         elseif(size(Elements,2)==85)  
 corrvec=[1:33, 37:41,34,42:46,35,47:51,36,52:56,57,61:63,58,64:66,59,67:69,60,70:73,77,74,78,75,79,76,80,81];
    El=Elements(:,5:end);
   Elements(:,5:end)=El(:,corrvec); 
   
end

figure
el1=Elements(1,5:end);
Nodes(el1,:)
pt=ans(:,2:3)
t=pt
figure
for i=1:length(t)
plot(t(i,1),t(i,2),'r.')
text(t(i,1),t(i,2),num2str((i)))
i=i+1;
hold on;
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
 

PathNodes=foldername+"/h_ref/Julia/"+"Nodes_L_"+num2str(idRef)+".txt";
PathElements=foldername+"/h_ref/Julia/"+"Elements_L_"+num2str(idRef)+".txt";
 
dlmwrite(PathNodes,Point,'delimiter',' ','precision',15)
dlmwrite(PathElements,El,'delimiter',' ','precision',15)

PathNodes=foldername+"/h_ref/Matlab/"+"Nodes_L_"+num2str(idRef)+".txt";
PathElements=foldername+"/h_ref/Matlab/"+"Elements_L_"+num2str(idRef)+".txt";
 
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
%ar=[1 29 33 5 25 9 37 41 13 17 45 49 21 4 22 32 26 15 43 31 35 47 19 7 3 8 36 30 34 40 12 6 2 11 23 39 27 18 24 46 28 10 14 16 20 38 42 44 48];
%ar=[1 29 33 5 25 9 37 41 13 17 45 49 21 4 22 32 26 15 43 31 35 47 19 7 3 8 36 30 34 40 12 6 2 11 23 39 27 18 24 46 28 10 14 16 20 38 42 44 48];
%ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,67,76,44,45,77,68,36,35,10,2,19,3,46,6,55,7,30,29,13,22,38,39,23,14,15,16,17,18,24,25,26,27,33,34,42,43,47,48,49,50,53,54,56,57,58,59,62,63,65,66,69,70,74,75,78,79];
 
% ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,67,76,44,45,77,68,36,35,10,2,19,3,46,6,55,7,30,29,13,22,38,39,23,14,33, 17 65 49 58 74 26 42 43 27 75 59 50 66 18 34 15 47 56 24 25 57 48 16 69 53 62 78 79 63 54 70];
%ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,67,76,44,45,77,68,36,35,10,2,19,3,46,6,55,7,30,29,13,22,38,39,23,14,33, 58 43 50 34 49 42 59 17 74 27 66 18 65 26 75 69 62 79 54 70 53 78 63 16 47 24 57 15 56 25 48];
%ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,36 67 44 77 35 76 45 68 10 2 19 3 46 6 55 7 30 13 38 23 29 22 39 14,33, 58 43 50 34 49 42 59 17 74 27 66 18 65 26 75 69 62 79 54 70 53 78 63 16 47 24 57 15 56 25 48];

x=gaussq(NumberOfGaussPoints(end));
% x=x(ar,:);
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

[out,id]=sort(GaussPointsCoord(:,2));
GaussPointsCoord(:,2:3)=GaussPointsCoord(id,2:3); %SORT THEM

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

% 
% figure
%  hold on
%  plotelem(Nodes,Elements,Types,'numbering','off','GCS','off','LineWidth',3);
%  plotnodes(Nodes,'numbering','off','*r','GCS','off','LineWidth',3);
%  axis equal
% axis([0 5 0 1])
% set(gca,'xtick',[])
% set(gca,'ytick',[])

% plotnodes(Nodes);
  if(higherOrder==true)
 plotnodes(GaussPointsCoord,'*b');
  end
    end
end
end

