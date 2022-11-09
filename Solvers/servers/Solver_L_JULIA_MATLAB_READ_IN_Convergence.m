
function [results] = Solver_L_JULIA_MATLAB_READ_IN_Convergence(Order,Maxlevel,HigherOrder)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
NumberOfGaussPoints=[9 25 49 81 121];
str_folder="/home/philippe/.julia/dev/Applications/applications/SPDE/data/";
%str_folder="/home/philippeb/.julia/packages/MultilevelEstimators/l8j9n/applications/SPDE/data/";
%str_folder="/vsc-hard-mounts/leuven-user/330/vsc33032/.julia/packages/MultilevelEstimators/KoRDo/applications/SPDE/data/";
NQoI=1;

str_interm=str_folder+"Interm/Beam/";

%Order=5
%Maxlevel=5
%HigherOrder=0
%fileLevel=strcat(str_interm,strcat("Index_",num2str(ProcID)));
%level=dlmread(fileLevel);
%HigherOrderHandle=strcat(str_interm,strcat("HighOrder_",num2str(ProcID)));
%HigherOrder=dlmread(HigherOrderHandle);

t=250;
nu=0.15;
results=[];

if(HigherOrder==0)

switch Order

    case 1
Mesh="Mesh/Beam/h_refinement/bilinear/";
    case 2
Mesh="Mesh/Beam/h_refinement/biquadratic/";
    case 3
Mesh="Mesh/Beam/h_refinement/bicubic/";
    case 4
Mesh="Mesh/Beam/h_refinement/biquartic/";
    case 5
Mesh="Mesh/Beam/h_refinement/biquintic/";
end

else
   Mesh="Mesh/Beam/p_refinement/"; 
end

fileRES=strcat(str_folder,strcat(Mesh,num2str(Order)));


for indx=0:Maxlevel
level=indx;
level_num=level;

%dores=dlmread(filedoRestriction);




if(length(level)==1)
    
    str=strcat('_',num2str(level(1)));
    level=str;
    
    
    if(HigherOrder==0) %Pure h refinement
%         Order=1;
        
        str_elements=strcat(str_folder,Mesh);
        
        
        files_elements=strcat(str_elements,"Elements_L",level,".txt");
        Elements=dlmread(files_elements);
        
        nElem=size(Elements,1);
    elseif(HigherOrder==1) %Pure p refinement
        EltOpts.GP='1';

        Order=level_num+1;
        str_elements=str_folder+"Mesh/Beam/p_refinement/";
        
        
        files_elements=strcat(str_elements,"Elements_L",level,".txt");
        Elements=dlmread(files_elements);
        
        nElem=size(Elements,1);
        EltOpts.GP_k_dp=1;
        %nelem TODO
    end
else
    
    if(HigherOrder==3) %MultiIndex hp refinement
        Order=level(2)+1;
        str_elements=str_folder+"Mesh/Beam/hp_refinement/";
        str='_';
        for len=1:length(level)
            str=strcat(str,num2str(level(len)));
            
        end
        
        files_elements=strcat(str_elements,"Elements_L",str,".txt");
        Elements=dlmread(files_elements);
        
        nElem=size(Elements,1);
        EltOpts.GP_k_dp=1;
        level=str;
        
    end
end

%fileE=strcat(str_interm,"E",level,"_",num2str(ProcID));
%E=dlmread(fileE);
file_nodes=strcat(str_elements,"Nodes_L",level,".txt");


switch Order
    case 1
        elementPlane='plane4';
    case 2
        elementPlane='plane9';
    case 3
        elementPlane='plane16';
    case 4
        elementPlane='plane25';
    case 5
        elementPlane='plane36';
        
end

EltOpts.nl='linear';
EltOpts.bendingmodes=false;
Types = {1 elementPlane EltOpts};   % {EltTypID EltName EltOpts} 
Sections = [1 t];               % [SecID t] 

    Options=struct;
    Options.verbose=false;

%% Mesh
% Line1 = [0 0 0; Lx 0 0];
% Line2 = [Lx 0 0; Lx Ly 0];
% Line3 = [Lx Ly 0; 0 Ly 0];
% Line4 = [0 Ly 0; 0 0 0];
% 
% [Nodes,Elements,Edge1,Edge2,Edge3,Edge4,Normals] = makemesh(Line1,Line2,Line3,Line4,m,n,Types(1,:),1,1);
% Nodes(:,4) = 0;
if(HigherOrder==0)


Ek=ones(length(Elements),1)*3e4;
else
    Ek=ones(nElem,NumberOfGaussPoints(Order))*3e4;
end

file_nodes=strcat(str_elements,"Nodes_L",level,".txt");
files_elements=strcat(str_elements,"Elements_L",level,".txt");
Elements=dlmread(files_elements);
Nodes=dlmread(file_nodes);


%filesNodesMax=strcat(str_elements,"Nodes_L_",num2str(MaxLVL),".txt");
%NodesMax=dlmread(filesNodesMax);


Materials = cell(nElem,3);
for k = 1:nElem, Materials(k,:) = {k 'linear' {'isotropic' [Ek(k,:) nu] }}; end

%% DOFs
LeftNodes=selectnode(Nodes,-1e-6,-inf,-inf,1e-6,inf,inf);
RightNodes=selectnode(Nodes,max(Nodes(:,2))-1e-6,-inf,-inf,max(Nodes(:,2))+1e-6,inf,inf);
DOF = getdof(Elements,Types);
sdof = [0.03;0.04;0.05;0.06;LeftNodes(:,1)+0.01;RightNodes(:,1)+0.01;LeftNodes(:,1)+0.02;RightNodes(:,1)+0.02]; 
DOF = removedof(DOF,sdof);
sdog_algo=unique(floor(sdof));



%forceNodes=selectnode(Nodes,max(Nodes(:,2))/2-1e-6,max(Nodes(:,3))-1e-6,-inf,max(Nodes(:,2))/2+1e-6,max(Nodes(:,3))+1e-6,inf);
forceNodes=selectnode(Nodes,max(Nodes(:,2))/2-1e-6,-inf,-inf,max(Nodes(:,2))/2+1e-6,inf,inf);

forceNodes=forceNodes(:,1);

[posy,srt]=sort(Nodes(forceNodes,3),'descend');
forceNodes=forceNodes(srt);
% forceNodes=forceNodes(1:(end-1));
forceNodes=forceNodes(1);

forceNodes=forceNodes+0.02;
seldof=forceNodes';
%% Load

    Force=10000000*(0:1:1);
    PLoad=Force;
% P = nodalvalues(DOF,seldof,[-1*0.5 -1*ones(1,size(seldof,2)-2) -1*0.5]./(size(seldof,2)-1));
P = nodalvalues(DOF,seldof,[-1*ones(1,size(seldof,2))]);

%% Compute displacements
U=solver_nr(Nodes,Elements,Types,Sections,Materials,DOF,P,PLoad,Options);
[K,L]=size(U);


U=abs(U);
if(NQoI==1)

res_node=selectnode(Nodes,max(Nodes(:,2))/2-1e-6,min(Nodes(:,3))-1e-6,-inf,max(Nodes(:,2))/2+1e-6,min(Nodes(:,3))+1e-6,inf);
u_out=selectdof(DOF,res_node(:,1)+0.02)*U(:,end);

% dlmwrite(fileRES,u_out,'delimiter',' ','precision',15);

results(indx+1)=u_out;
else
res_node=selectnode(Nodes,-inf,min(Nodes(:,3))-1e-6,-inf,inf,min(Nodes(:,3))+1e-6,inf);

[Nodes_x,I]=sort(res_node(:,2));

u_out=selectdof(DOF,res_node(I,1)+0.02)*U(:,end); 



res_node_max=selectnode(NodesMax,-inf,min(NodesMax(:,3))-1e-6,-inf,inf,min(NodesMax(:,3))+1e-6,inf);

Nodes_x_max=sort(res_node_max(:,2));

Nodes_y_max=res_node_max(:,3);

u_out=interp1(Nodes_x,u_out,Nodes_x_max);

    
dlmwrite(fileRES,u_out,'delimiter',' ','precision',15);
    
end

end
results=results';

dlmwrite(fileRES,results,'delimiter',' ','precision',20);


% [Matx,Maty] = Extract_matrix_Displacements_From_Vector(U,nelx,nely);
%% Plot displacements
% figure
% plotdisp(Nodes,Elements,Types,DOF,U(:,end))
% 
% figure;
% animdisp(Nodes,Elements,Types,DOF,U)
% 
% figure;
% seldof = find(Nodes(:,2)==Lx/2 & Nodes(:,3)==0 & round(Nodes(:,4)*1000)/1000==0)+0.02;
% plot(selectdof(DOF,seldof)*U,PLoad)
% xlabel('Displacement [mm]')
% ylabel('Force [N]')
% hold on


% seldof = find(Nodes(:,2)==Lx/2 & Nodes(:,3)==Ly & round(Nodes(:,4)*1000)/1000==0)+0.02;
% plot(selectdof(DOF,seldof)*U,PLoad)
% xlabel('Displacement [mm]')
% ylabel('Force [N]')
% legend('Lower level','Upper level')

end


