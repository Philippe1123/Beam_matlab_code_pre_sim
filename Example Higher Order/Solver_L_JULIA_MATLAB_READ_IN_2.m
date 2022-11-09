
function [out] = Solver_L_JULIA_MATLAB_READ_IN_2(Order,Maxlevel,HigherOrder)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
NumberOfGaussPoints=[9 25 49 81 121];
str_folder="";
%str_folder="/home/philippeb/.julia/packages/MultilevelEstimators/l8j9n/applications/SPDE/data/";
%str_folder="/vsc-hard-mounts/leuven-user/330/vsc33032/.julia/packages/MultilevelEstimators/KoRDo/applications/SPDE/data/";
NQoI=1;


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
            Mesh="Mesh/Order_1/";
        case 2
            Mesh="Mesh/Order_2/";
        case 3
            Mesh="Mesh/Order_3/";
        case 4
            Mesh="Mesh/Order_4/";
        case 5
            Mesh="Mesh/Order_5/";
        case 6
            Mesh="Mesh/Order_6/";
        case 7
            Mesh="Mesh/Order_7/";
        case 8
            Mesh="Mesh/Order_8/";
        case 9
            Mesh="Mesh/Order_9/";
        case 10
            Mesh="Mesh/Order_10/";
    end
    
else
    Mesh="Mesh/Beam/p_refinement/";
end

fileRES=strcat(str_folder,strcat(Mesh,num2str(Order)));


level=Maxlevel;
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
    case 6
        elementPlane='plane49';
    case 7
        elementPlane='plane64';
    case 8
        elementPlane='plane81';
    case 9
        elementPlane='plane100';
    case 10
        elementPlane='plane121';
        
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


%
% forceNodes=selectnode(Nodes,max(Nodes(:,2))/2-1e-6,-inf,-inf,max(Nodes(:,2))/2+1e-6,inf,inf);
% forceNodes=forceNodes(:,1);
% [posy,srt]=sort(Nodes(forceNodes,3),'descend');
% forceNodes=forceNodes(srt);
% forceNodes=forceNodes(1);

forceNodes=selectnode(Nodes,min(Nodes(:,2))-1e-6,max(Nodes(:,3))-1e-6,-inf,max(Nodes(:,2))+1e-6,max(Nodes(:,3))+1e-6,inf);
forceNodes=forceNodes(:,1);
[posy,srt]=sort(Nodes(forceNodes,2),'ascend');
forceNodes=forceNodes(srt);




forceNodes=forceNodes+0.02;
seldof=forceNodes';
%% Load

Force=10000000000*(0:1:1);
%         Force=10000000000*(0:1:1);

PLoad=Force;
% P = nodalvalues(DOF,seldof,[-1*ones(1,size(seldof,2))]);
ar=[0:2*pi/(length(forceNodes)-1):2*pi];
vec=(-cos(ar)+1)/sum((-cos(ar)+1));
P = nodalvalues(DOF,seldof,vec);
%% Compute displacements
U=solver_nr(Nodes,Elements,Types,Sections,Materials,DOF,P,PLoad,Options);
[K,L]=size(U);

res_node=selectnode(Nodes,max(Nodes(:,2))/2-1e-6,min(Nodes(:,3))-1e-6,-inf,max(Nodes(:,2))/2+1e-6,min(Nodes(:,3))+1e-6,inf);
u_out=selectdof(DOF,res_node(:,1)+0.02)*U(:,end)

switch Order
    case 1
        String="Order 1";
    case 2
        String="Order 2";
        
    case 3
        String="Order 3";
    case 4
        String="Order 4";
    case 5
        String="Order 5";
        
end

U=abs(U);
% figure
% subplot(2,2,1);
% u_out=selectdof(DOF,Nodes(:,1)+0.02)*U(:,end);
% x=Nodes(:,2);
% y=Nodes(:,3);
% scatter(x,y,[],u_out,'filled')
% hold on
% plotelem(Nodes,Elements,Types,'numbering','off','GCS','off','LineWidth',1);
% xlabel("x position beam")
% ylabel("y position beam")
% title(strcat(String," Computed"))
% colormap jet;
% axis([0 5 0 1.0]);
% % % % % % % % % % %
% % % % % % % % % % % x=-1:0.05:1;
% % % % % % % % % % % [X,Y]=meshgrid(x,x);
% % % % % % % % % % % pt=[reshape(X,1,size(X,2)*size(X,1));reshape(Y,1,size(Y,2)*size(Y,1));ones(1,size(Y,2)*size(Y,1));2*ones(1,size(Y,2)*size(Y,1))];
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % % TriangleCoordLocal=[[-1;-1;1;2],[1;-1;1;2],[1;1;1;1],[-1;1;1;2]];
% % % % % % % % % % %
% % % % % % % % % % % pts=[];
% % % % % % % % % % % Res=[];
% % % % % % % % % % % for idx=1:nElem
% % % % % % % % % % %
% % % % % % % % % % %   TriangleVertices=Nodes(Elements(idx,5:8),2:3);
% % % % % % % % % % %   TriangleVertices=TriangleVertices';
% % % % % % % % % % %   TriangleVertices=[TriangleVertices;[1 1 1 1];[2 2 2 2]];
% % % % % % % % % % %   TransformationMatrix=TriangleVertices*inv(TriangleCoordLocal);
% % % % % % % % % % %   pt_global=TransformationMatrix*pt;
% % % % % % % % % % %
% % % % % % % % % % %  pts=[pts; pt_global(1:2,:)'];
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % %  for jx=1:length(pt)
% % % % % % % % % % %
% % % % % % % % % % %  Nod=Elements(idx,5:end);
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % %  switch Order
% % % % % % % % % % %     case 1
% % % % % % % % % % %  Nwres(jx)=sh_qs4(pt(1,jx),pt(2,jx))'*selectdof(DOF,Nod+0.02)*U(:,end);
% % % % % % % % % % %      String="Order 1";
% % % % % % % % % % %     case 2
% % % % % % % % % % %  Nwres(jx)=sh_qs9(pt(1,jx),pt(2,jx))'*selectdof(DOF,Nod+0.02)*U(:,end);
% % % % % % % % % % %       String="Order 2";
% % % % % % % % % % %
% % % % % % % % % % %     case 3
% % % % % % % % % % %  Nwres(jx)=sh_qs16(pt(1,jx),pt(2,jx))'*selectdof(DOF,Nod+0.02)*U(:,end);
% % % % % % % % % % %        String="Order 3";
% % % % % % % % % % %     case 4
% % % % % % % % % % %  Nwres(jx)=sh_qs25(pt(1,jx),pt(2,jx))'*selectdof(DOF,Nod+0.02)*U(:,end);
% % % % % % % % % % %        String="Order 4";
% % % % % % % % % % %     case 5
% % % % % % % % % % %  Nwres(jx)=sh_qs36(pt(1,jx),pt(2,jx))'*selectdof(DOF,Nod+0.02)*U(:,end);
% % % % % % % % % % %        String="Order 5";
% % % % % % % % % % %
% % % % % % % % % % % end
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % %  end
% % % % % % % % % % %   Res=[Res;  Nwres'];
% % % % % % % % % % % end
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % % idx=find(pts(:,1)==2.5);
% % % % % % % % % % %
% % % % % % % % % % %
% % % % % % % % % % % out=[pts(idx,2) Res(idx)]
% % % % % % % % % % %



out=u_out;



end


