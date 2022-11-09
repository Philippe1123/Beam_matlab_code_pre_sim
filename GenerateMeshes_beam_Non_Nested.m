function [  ] = GenerateMeshes_beam_Non_Nested(  )
% close all



Path="/home/philippe/Desktop/gmsh-4.4.1-Linux64/bin/gmsh"+" ";
Order=1;
EltOpts.nl='elastoplastic';
 %figure;
foldername="beam_Non_Nested";
numberoflevels_refinement=0;
numberoflevels_order=7;
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

NumberOfGaussPoints=[5  9 11  15 17  21  25 27 ];

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
   
            elseif(size(Elements,2)==104)  
 corrvec=[1:37,41:46,38,47:52,39,53:58,40,59:65,69:72,66,73:76,67,77:80,68,81:85,89:90,86,91:92,87,93:94,88,95:100];
    El=Elements(:,5:end);
   Elements(:,5:end)=El(:,corrvec); 
   
      
            elseif(size(Elements,2)==125)  
 corrvec=[1:41,45:51,42,52:58,43,59:65,44,66:73,77:81,74,82:86,75,87:91,76,92:97,101:103,98,104:106,99,107:109,100,110:113,117,114,118,115,119,116,120,121];
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

x=gaussq(NumberOfGaussPoints(idOrder+1));
 
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
   GaussPointsCoord=[GaussPointsCoord ;GaussPoints_Global ]; %%changed for
%   sort
%    GaussPointsCoord=[GaussPointsCoord ;GaussPoints_Global ones(length(GaussPoints_Global),1).*idx];

  
    
end

GaussPointsCoord=[[1:1:length(GaussPointsCoord)]',GaussPointsCoord,zeros(length(GaussPointsCoord),1)];
if(higherOrder==true&&refinement==false)
PathGaussPoints=foldername+"/p_ref/Matlab/"+"GaussPoints_L_"+num2str(idOrder)+".txt";
PathSortVec=foldername+"/p_ref/Matlab/"+"SortVec_L_"+num2str(idOrder)+".txt";

    elseif(higherOrder==true&&refinement==true)

PathGaussPoints=foldername+"/hp_ref/Matlab/"+"GaussPoints_L_"+num2str(idOrder)+".txt";

end

%%%vhanged for sort
%  orig=GaussPointsCoord(:,2:3);
%  [out,id]=sort(GaussPointsCoord(:,2));
%  [out,unsrtid]=sort(id);
%  v=[1:length(id)]';
%  unsrtid=v(unsrtid);
%  GaussPointsCoord(:,2:4)=GaussPointsCoord(id,2:4); %SORT THEM
% orig2=GaussPointsCoord(unsrtid,2:3);
% dlmwrite(PathSortVec,unsrtid,'delimiter',' ','precision',15)

%%%%%%%%%
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
%  plotnodes(GaussPointsCoord,'*b');
  end
    end
end
end

