
function [u_out] = Solver_NL_JULIA_MATLAB(Lx,Ly,he,E,nu,fy,t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

m = Ly/he;
n = Lx/he;

nely=m;
nelx=n;

EltOpts.nl='elastoplastic';
Types = {1 'plane4' EltOpts};   % {EltTypID EltName EltOpts} 
Sections = [1 t];               % [SecID t] 

    Options=struct;
 %   Options.verbose=false;

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
E_in=200E3;
for k = 1:nElem, Materials(k,:) = {k 'elastoplastic' {'isotropic' [Ek(k) nu] 'vm' [fy] 'multilinear' [1 fy+E_in/20]}}; end

%  figure;
%  plotnodes(Nodes);
% 
%  figure;
%  plotelem(Nodes,Elements,Types);
% pause(10)
%% DOFs
DOF = getdof(Elements,Types);
sdof = [0.03;0.04;0.05;0.06;[Edge2;Edge4]+0.01;[Edge2;Edge4]+0.02]; 
DOF = removedof(DOF,sdof);
sdog_algo=unique(floor(sdof));


%% Load
seldof = find(Nodes(:,2)==Lx/2 & Nodes(:,3)==Ly & round(Nodes(:,4)*1000)/1000==0)+0.02;
Node=Ly-he;
while Node>=0
sel = find(Nodes(:,2)==Lx/2 & Nodes(:,3)==Node & round(Nodes(:,4)*1000)/1000==0)+0.02;
    
seldof=[seldof sel]  ; 
  Node=Node-he;
  
end
seldof;

    Force=135*(0:1:100);
    PLoad=Force;
P = nodalvalues(DOF,seldof,[-1*0.5 -1*ones(1,size(seldof,2)-2) -1*0.5]./m);

%% Compute displacements
U=solver_nr(Nodes,Elements,Types,Sections,Materials,DOF,P,PLoad,Options);
[K,L]=size(U);

%fprintf('before loop')

for ik=1:L

u=U(:,ik);
% u=u';
        matxDir=zeros(nely+1,nelx+1);
        matyDir=zeros(nely+1,nelx+1);
        x=1;  y=1;  z=2;  t=1;v=1;
        while(x<=(nelx+1))
            y=1;
            while(y<=(nely+1))
                if(sum(ismember(v,sdog_algo))==0)
                    matxDir(y,x)=u(t);
                    matyDir(y,x)=u(z);
                    z=z+2;  t=t+2;
                else
                    matxDir(y,x)=0;
                    matyDir(y,x)=0;
                end
                v=v+1;
                y=y+1;
            end
            x=x+1;
        end
        Matx=matxDir;
        Maty=matyDir;
        
        [n,m]=size(matxDir);
    maxNdof=2*(nelx+1)*(nely+1);    
            Pc=zeros(maxNdof,1);
            x=1;
            i=1;
            y=1;
            while(y<=m)
                x=1;
                while(x<=n)
                    
                    
                    Pc(i)=matxDir(x,y);
                    Pc(i+1)=matyDir(x,y);
                    i=i+2;
                    x=x+1;
                end
                y=y+1;
            end 
            
            if(ik==1)
            u_new=Pc;
            else
            u_new=[u_new Pc];    
            
            end
end

u_out=u_new;


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


