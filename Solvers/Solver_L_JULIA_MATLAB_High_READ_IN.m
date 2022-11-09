function [] = Solver_L_JULIA_MATLAB_High_READ_IN(ProcID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



str="/home/philippe/.julia/dev/MultilevelEstimators/applications/SPDE/data/Interm/";
str="/home/philippeb/.julia/packages/MultilevelEstimators/l8j9n/applications/SPDE/data/Interm/";

fileLx=strcat(str,strcat("Lx_",num2str(ProcID)));
fileLy=strcat(str,strcat("Ly_",num2str(ProcID)));
filehe=strcat(str,strcat("he_",num2str(ProcID)));
fileE=strcat(str,strcat("E_",num2str(ProcID)));
fileLev=strcat(str,strcat("Lev_",num2str(ProcID)));
fileRES=strcat(str,strcat("Res_",num2str(ProcID)));
t=1000;
nu=0.15;

Lx=dlmread(fileLx);
Ly=dlmread(fileLy);
he=dlmread(filehe);
E=dlmread(fileE);
level=dlmread(fileLev);

m = Ly/he;
n = Lx/he;

nely=m;
nelx=n;


if(level==0)
    casus='plane4';
    factor=1;
elseif(level==1)
    casus='plane9';
        factor=2;
elseif(level==2)
    casus='plane16';
        factor=3;
elseif(level==3)
    casus='plane25';
        factor=4;
elseif(level==4)
    casus='plane36';
        factor=5;
end



EltOpts.nl='linear';
EltOpts.bendingmodes=false;
Types = {1 casus EltOpts};   % {EltTypID EltName EltOpts} 
Sections = [1 t];               % [SecID t] 

    Options=struct;
     Options.verbose=false;

%% Mesh
Line1 = [0 0 0; Lx 0 0];
Line2 = [Lx 0 0; Lx Ly 0];
Line3 = [Lx Ly 0; 0 Ly 0];
Line4 = [0 Ly 0; 0 0 0];

[Nodes,Elements,Edge1,Edge2,Edge3,Edge4,Normals] = makemesh(Line1,Line2,Line3,Line4,m,n,Types(1,:),1,1);
Nodes(:,4) = 0;
nElem=size(Elements,1);
Elements(:,4) = 1:nElem;


if(size(E,2)==1)
Ek = E*ones(nElem,1);
else
%[j,k]=size(E);
%size(E)
%nElem
Ek = reshape(E,[nElem,1]);
end
Materials = cell(nElem,3);
%for k = 1:nElem, Materials(k,:) = {k 'elastoplastic' {'isotropic' [Ek(k) nu] 'vm' [fy] 'multilinear' [1 fy+E_in/20]}}; end
for k = 1:nElem, Materials(k,:) = {k 'linear' {'isotropic' [Ek(k) nu] }}; end

% figure;
% plotnodes(Nodes);

% figure;
% plotelem(Nodes,Elements,Types);

%% DOFs
DOF = getdof(Elements,Types);
sdof = [0.03;0.04;0.05;0.06;[Edge2;Edge4]+0.01;[Edge2;Edge4]+0.02]; 
DOF = removedof(DOF,sdof);
sdog_algo=unique(floor(sdof));


%% Load
seldof = find(Nodes(:,2)==Lx/2 & Nodes(:,3)==Ly & round(Nodes(:,4)*1000)/1000==0)+0.02;
Node=Ly-he/factor;
while Node>=-1
    sel = find(round(Nodes(:,2),5)==round(Lx/2,5) & round(Nodes(:,3),5)==round(Node,5) & round(Nodes(:,4)*1000)/1000==0)+0.02;
    
    seldof=[seldof sel]  ;
    Node=Node-he/factor;
    
end

    Force=10000000*(0:1:1);
    PLoad=Force;
P = nodalvalues(DOF,seldof,[-1*0.5 -1*ones(1,size(seldof,2)-2) -1*0.5]./(m*factor));

%% Compute displacements
U=solver_nr(Nodes,Elements,Types,Sections,Materials,DOF,P,PLoad,Options);

u=U(:,end);
u_out=min(u);
dlmwrite(fileRES,u_out,'delimiter',' ','precision',15);

% [K,L]=size(U);
% 
% %fprintf('before loop')
% 
% for ik=1:L
% 
% u=U(:,ik);
% % u=u';
%         matxDir=zeros(nely+1,nelx+1);
%         matyDir=zeros(nely+1,nelx+1);
%         x=1;  y=1;  z=2;  t=1;v=1;
%         while(x<=(nelx+1))
%             y=1;
%             while(y<=(nely+1))
%                 if(sum(ismember(v,sdog_algo))==0)
%                     matxDir(y,x)=u(t);
%                     matyDir(y,x)=u(z);
%                     z=z+2;  t=t+2;
%                 else
%                     matxDir(y,x)=0;
%                     matyDir(y,x)=0;
%                 end
%                 v=v+1;
%                 y=y+1;
%             end
%             x=x+1;
%         end
%         Matx=matxDir;
%         Maty=matyDir;
%         
%         [n,m]=size(matxDir);
%     maxNdof=2*(nelx+1)*(nely+1);    
%             Pc=zeros(maxNdof,1);
%             x=1;
%             i=1;
%             y=1;
%             while(y<=m)
%                 x=1;
%                 while(x<=n)
%                     
%                     
%                     Pc(i)=matxDir(x,y);
%                     Pc(i+1)=matyDir(x,y);
%                     i=i+2;
%                     x=x+1;
%                 end
%                 y=y+1;
%             end 
%             
%             if(ik==1)
%             u_new=Pc;
%             else
%             u_new=[u_new Pc];    
%             
%             end
% end
% 
% u_out=u_new;
% 



end


