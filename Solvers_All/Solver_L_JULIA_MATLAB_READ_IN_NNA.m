
function [] = Solver_L_JULIA_MATLAB_READ_IN_NNA(ProcID)
%   Detailed explanation goes here
%ProcID=2
%NumberOfGaussPoints=[9 25 49 81]; % paper
NumberOfGaussPoints=[25    81   121   225   289   441   625   729];

str_folder="/vsc-hard-mounts/leuven-user/330/vsc33032/.julia/dev/MultilevelEstimators/applications/SPDE/data/";


str_interm=str_folder+"Interm3/Beam/";

fileQoI=strcat(str_interm,strcat("NQoI"));
fileMaxLevelI=strcat(str_interm,strcat("MaxLVL"));

MaxLVL=dlmread(fileMaxLevelI);
NQoI=dlmread(fileQoI);

fileRES=strcat(str_interm,strcat("Res_",num2str(ProcID)));
fileLevel=strcat(str_interm,strcat("Index_",num2str(ProcID)));
level=dlmread(fileLevel);
level_num=level;
HigherOrderHandle=strcat(str_interm,strcat("HighOrder_",num2str(ProcID)));
HigherOrder=dlmread(HigherOrderHandle);
%filedoRestriction=strcat(str_interm,strcat("doRestriction_",num2str(ProcID)));

t=250;
nu=0.15;





%dores=dlmread(filedoRestriction);




if(length(level)==1)
    
    str=strcat('_',num2str(level(1)));
    level=str;
    
    
    if(HigherOrder==0) %Pure h refinement
        Order=1;
        
        str_elements=str_folder+"Mesh/Beam/h_refinement/";
        
        
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

fileE=strcat(str_interm,"E",level,"_",num2str(ProcID));
E=dlmread(fileE);
file_nodes=strcat(str_elements,"Nodes_L",level,".txt");
% file_sort=strcat(str_elements,"SortVec_L",level,".txt");
% srt=dlmread(file_sort);
% E=E(srt);


switch Order
    case 1
        elementPlane='plane4';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(1));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(1);
    case 2
        elementPlane='plane9';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(2));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(2);
    case 3
        elementPlane='plane16';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(3));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(3);
    case 4
        elementPlane='plane25';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(4));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(4);
    case 5
        elementPlane='plane36';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(5));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(5);
    case 6
        elementPlane='plane49';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(6));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(6);
    case 7
        elementPlane='plane64';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(7));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(7);
    case 8
        elementPlane='plane81';
        EltOpts.nXi=sqrt(NumberOfGaussPoints(8));
        EltOpts.Sort_nXi=1:NumberOfGaussPoints(8);
    case 9
        elementPlane='plane100';
%not used at the moment
end

EltOpts.nl='linear';
EltOpts.bendingmodes=false;
Types = {1 elementPlane EltOpts};   % {EltTypID EltName EltOpts}
Sections = [1 t];               % [SecID t]

Options=struct;
Options.verbose=false;

%% Mesh
if(HigherOrder==0)
    Nodes=dlmread(file_nodes);
    file_nodes_centers=strcat(str_elements,"ElementsCenter_L",level,".txt");
    nodes_centers=dlmread(file_nodes_centers);
    % Ek=griddata(Nodes(:,2),Nodes(:,3),E,nodes_centers(:,1),nodes_centers(:,2),'cubic');  % Cohesion in N/m^2
    F=scatteredInterpolant(Nodes(:,2),Nodes(:,3),E);
    Ek=F(nodes_centers(:,1),nodes_centers(:,2));
    %   Ek=E;
else
    %  c=reshape(c,nElem,NumberOfGaussPoints(Order));
    Ek=transpose(reshape(E,NumberOfGaussPoints(Order),nElem));
    % Ek=ones(nElem,NumberOfGaussPoints(Order))*3e4;
end

file_nodes=strcat(str_elements,"Nodes_L",level,".txt");
files_elements=strcat(str_elements,"Elements_L",level,".txt");
Elements=dlmread(files_elements);
Nodes=dlmread(file_nodes);


filesNodesMax=strcat(str_elements,"Nodes_L_",num2str(MaxLVL),".txt");
NodesMax=dlmread(filesNodesMax);
%
% nElem=size(Elements,1);
% Elements(:,4) = 1:nElem;
%
%
% if(size(E,2)==1)
% Ek = E*ones(nElem,1);
% else
% %[j,k]=size(E);
% %size(E)
% %nElem
% Ek = reshape(E,[nElem,1]);
% end


Materials = cell(nElem,3);
for k = 1:nElem, Materials(k,:) = {k 'linear' {'isotropic' [Ek(k,:) nu] }}; end


%% DOFs
LeftNodes=selectnode(Nodes,-1e-6,-inf,-inf,1e-6,inf,inf);
RightNodes=selectnode(Nodes,max(Nodes(:,2))-1e-6,-inf,-inf,max(Nodes(:,2))+1e-6,inf,inf);
DOF = getdof(Elements,Types);
sdof = [0.03;0.04;0.05;0.06;LeftNodes(:,1)+0.01;RightNodes(:,1)+0.01;LeftNodes(:,1)+0.02;RightNodes(:,1)+0.02];
DOF = removedof(DOF,sdof);
sdog_algo=unique(floor(sdof));



yposNodes=uniquetol(sort(Nodes(:,3)),10^-5);
% yposNodes=yposNodes([2,4,6]);%%%%%%%%%%%%debug
% ary=[0:2*pi/(length(yposNodes)-1):2*pi];
seldof=[];
vec=[];


for id=1:length(yposNodes)

forceNodes=selectnode(Nodes,min(Nodes(:,2))-1e-6,yposNodes(id)-1e-6,-inf,max(Nodes(:,2))+1e-6,yposNodes(id)+1e-6,inf);
forceNodes=forceNodes(:,1);
[posy,srt]=sort(Nodes(forceNodes,2),'ascend');
forceNodes=forceNodes(srt);
ar=[0:2*pi/(length(forceNodes)-1):2*pi];
% vec_int=(-cos(ar)+1)/sum((-cos(ar)+1)).*(-cos(ary(id))+1)/sum((-cos(ary)+1));
vec_int=(-cos(ar)+1)/sum((-cos(ar)+1)).*1/length(yposNodes);



forceNodes=forceNodes+0.02;
seldof_int=forceNodes';

seldof=[seldof seldof_int];
vec=[vec vec_int];

end


%% Load

Force=10000000*(0:1:1);


    PLoad=Force;
% % % % % % % % ar=[0:2*pi/(length(forceNodes)-1):2*pi];
% % % % % % % % vec=(-cos(ar)+1)/sum((-cos(ar)+1));
P = nodalvalues(DOF,seldof,vec);

%% Compute displacements
U=solver_nr(Nodes,Elements,Types,Sections,Materials,DOF,P,PLoad,Options,[],[],[],[],[]);
[K,L]=size(U);


U=abs(U);
if(NQoI==1)
    

    res_node=selectnode(Nodes,(max(Nodes(:,2)))/2-1e-6,min(Nodes(:,3))-1e-6,-inf,(max(Nodes(:,2)))/2+1e-6,min(Nodes(:,3))+1e-6,inf);
    u_out=selectdof(DOF,res_node(1)+0.02)*U(:,end);

 

dlmwrite(fileRES,u_out,'delimiter',' ','precision',15);
    
    
else

    
    
    dlmwrite(fileRES,u_out,'delimiter',' ','precision',15);
    
end




clear all;
clc;
close all;

end


