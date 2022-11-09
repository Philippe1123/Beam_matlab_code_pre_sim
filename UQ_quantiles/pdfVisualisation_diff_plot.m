function [ output_args ] = pdfVisualisation_diff_plot(x, pdfSamples,omegaVec ,Foldername)
%PDFVISUALISATION Summary of this function goes here
%   Detailed explanation goes here
% close all
% clc
% clear all
% pdfSample = load('pdfSample');
% pdfSample=pdfSample.pdfSample;


% pdfSample=rand(1,100000);

upperVec=zeros(10,size(pdfSamples,1));
underVec=zeros(10,size(pdfSamples,1));
MostProbableValue=zeros(1,size(pdfSamples,1));

% figure
    f=0;
divider=10;
complete=false;

x_values_cell={};
y_values_cell={};

if(omegaVec==-1)

MeanB=[];
VarB=[];


for id=1:size(pdfSamples,1)
    
complete=false;
divider=10;

while complete==false
    
    if(omegaVec==-1)
        omega=x(id);
    else

 omega=omegaVec(id);
    end
pdfSample=pdfSamples(id,:);
MeanB(id)=mean(pdfSample);
VarB(id)=var(pdfSample);
% figure
% histogram(pdfSample);

 expo=ceil(abs(log(min((pdfSample)))/log(10)))+2;


pdfSample=pdfSample';
pdfSample=abs(pdfSample);
ValMax=abs(max(pdfSample));
ValMin=abs(min(pdfSample));

if(ValMax>ValMin)
Val=ValMax;
else
Val=ValMin;
end

% x_values=min(pdfSample)-abs(max(pdfSample)):10^-expo:max(pdfSample)+abs(max(pdfSample));
% x_values=min(pdfSample):10^-expo:max(pdfSample);
%  x_values=min(pdfSample)-abs(max(pdfSample)/divider):5^-expo:max(pdfSample)+abs(max(pdfSample)/divider);
 x_values=min(pdfSample)-Val/divider:10^-expo:max(pdfSample)+Val/divider;
x_values_cell{id}=x_values;
% x_values=min(pdfSample):10^-expo:max(pdfSample);
%     omega
 %    pd = fitdist(pdfSample,'Kernel','Kernel','normal');
    mmin=min(pdfSample)*.98;
    mmax=max(pdfSample)*1.02;
     pd = fitdist(pdfSample, 'Kernel', 'Kernel', 'epanechnikov', 'support',[mmin, mmax]);
%     
%     pd = fitdist(pdfSample,'Kernel','BandWidth',0.075);
%         pd = fitdist(pdfSample,'Kernel','BandWidth',0.045);% not that good
%         pd = fitdist(pdfSample,'Kernel','BandWidth',0.085);%
%         pd = fitdist(pdfSample,'Kernel','BandWidth',0.095);%

    y = pdf(pd,x_values);
    y_values_cell{id}=y;

    y=y./max(y);
    

%  g=1;
%  if(omegaVec==-1)
%      figure
%  else
%       figure(id)
%  subplot(1,4,4)
%  end
% plot(x_values,y)
% str = sprintf('PDF for frequency %d Hz ', omega);
% title(str);
% xlabel('log_{10} base'); 

Norm_N=y;

if(~isempty(x_values) )

% figure
% plot(x_values,Norm_N)


edges1=x_values(1:find(Norm_N==1));
edges2=x_values(find(Norm_N==1):end);

[Norm1, index1] = unique(Norm_N(1:find(Norm_N==1))); 
[Norm2, index2] = unique(Norm_N(find(Norm_N==1):end)); 

evalPoint=[0.001 0.1:0.1:1];


vq1=interp1(Norm1,edges1(index1),evalPoint);
vq2=interp1(Norm2,edges2(index2),evalPoint);
MostProbableValue(1,id)=x_values((find(Norm_N==1)));

clear x_values
clear pd
clear y
clear Norm_N
%  hold on
%  plot(vq1,evalPoint,'*r');
%  plot(vq2,evalPoint,'*g');
%  hold off

else
   vq2=zeros(11,1) ;
   vq1=zeros(11,1) ;
   MostProbableValue(1,id)=0;
end

upperVec(:,id)=vq2(1,2:end);
underVec(:,id)=vq1(1,2:end);
f=f+1;
% g=g+1;

% if(any(upperVec(:,id)==0) || any(underVec(:,id)==0))
% if(any(isnan(upperVec(:,id))==1) || any(isnan(underVec(:,id))==1))
if(any(isnan(vq2)==1) || any(isnan(vq1)==1))
    if(divider>1)
        divider=divider-1;
    elseif(divider<=1)
        divider=divider-0.1;
        if(divider==0.1)
            divider=0.1;
            complete=true;
        end
    elseif(divider<=0)
        divider=0.1;
        complete=true;
    end
else
    complete=true;
end

end
% str2=sprintf('Fig for frequency %d Hz ', omega);
% str3=strcat(strcat(Foldername,'/'),str2);
% savefig(strcat(str3,'.fig'))
% print(str3,'-dpng')

end

% 
% figure
% subplot(1,2,1)
% for i=1:10
% 
% 
% upperY=upperVec(i,:);
% underY=underVec(i,:);
% 
% upperY(isnan(upperY))=0;
% underY(isnan(underY))=0;
% 
% % upperY=smoothdata(upperY,size(upperY,2));
% % underY=smoothdata(underY,size(upperY,2));
% % x=smoothdata(x,size(upperY,2));
% 
% SimpleShaddedErrorbars( x,-MostProbableValue,-upperY,-underY )
% hold on
% %end
% end
% x1=[x(80)*ones(1,6)];
% y1=[-0.05:0.01:0];
% plot(x1,y1,'-r')
% txt = '\leftarrow A';
% text(x1(1),y1(1)+0.001,txt,'color','red','FontSize',15)
% 
% txt = '\leftarrow B';
% text(x1(end),y1(end)-0.001,txt,'color','red','FontSize',15)
% xlabel('Point Number');
% ylabel('Deflection [/]');
% 
% subplot(1,2,2)
% plot(x_values_cell{80},y_values_cell{80})
% hold on
% x2=[-0.1 -6*10^-3]
% y2=[51 51]
% plot(x2,y2)
% axis([-0.1 -0.005 0 52])
% 
% txt = '\uparrow A';
% text(x2(1)+0.0005,y2(1)-0.9,txt,'color','red','FontSize',15)
% 
% txt = '\uparrow B';
% text(x2(end)-0.005,y2(end)-0.9,txt,'color','red','FontSize',15)
% xlabel('Deflection [/]');
% ylabel('PDF [/]');
% 


figure
for i=1:10


upperY=upperVec(i,:);
underY=underVec(i,:);

upperY(isnan(upperY))=0;
underY(isnan(underY))=0;

% upperY=smoothdata(upperY,size(upperY,2));
% underY=smoothdata(underY,size(upperY,2));
% x=smoothdata(x,size(upperY,2));

SimpleShaddedErrorbars( x,-MostProbableValue,-upperY,-underY )
hold on
%end
end

plot(x,-MeanB,'-','Color', [1.0, 0.5, 0.17],'LineWidth',3)
hold on

plot(x,-(MeanB+sqrt(VarB)),'--','Color', [1.0, 0.5, 0.17],'LineWidth',3)

plot(x,-(MeanB-sqrt(VarB)),'--','Color', [1.0, 0.5, 0.17],'LineWidth',3)



else


% xlabel("Position on Beam [m]")
% ylabel("Deflection [m]")
% matlab2tikz('floatFormat','%.15f','Beam_78.tex')




end

axis([0 5 -0.03 0])
end

