function [ output_args ] = Ploter( input_args )
%PLOTER Summary of this function goes here
%   Detailed explanation goes here

 close all
array90d={};

%arr=[7 9];
% arr=[5 9 13 17 21 25];
% arr=[5 9 13 17 21 25];
 arr=[5  9 11  15];

    x_or=gaussq(arr(end));
% x=x(ar,:);
t=x_or;
x=x_or;
% [s,srtpost]=sort(t(:,1),'Ascend');
% t(:,1:2)=t(srtpost,1:2);

% for fg=4:-1:1
for fg=length(arr):-1:1

x_l=gaussq(arr(fg));

% [s,srtpost]=sort(x_l(:,1),'Ascend');
% x_l(:,1:2)=x_l(srtpost,1:2);


dist=[];
% t(:,1)=t(:,1)-0.01
srt=[];
for id=1:length(t)
    
    for ix=1:length(x_l)
        
     dist(ix,id)=sqrt((t(id,1)-x_l(ix,1))^2+(t(id,2)-x_l(ix,2))^2);
        
        
    end
       
    
end





srt=[];
    
    for ix=1:length(x_l)
        
        added=false;
      while(added==false)  
     [val,minpos]=min(dist(ix,:));
     
     [srttd,psrrtd]=sort(dist(ix,:),'Ascend');
     numberofmin=sum(srttd==val);
     
     if(numberofmin==1)
         q=1;
     else
         h=1
      dist(:,psrrtd(2))=   dist(:,psrrtd(2))-srttd(2);

     end
     
     
     
     if(~ismember(minpos,srt))
         srt(ix)=minpos;
         added=true;
     else
      dist(ix,minpos)=   dist(ix,minpos)+minpos;
         
     end
    end
    end

figure
hold on
t=t(srt,:);

t=sortrows(t,[1 2]);
x_l=sortrows(x_l,[1 2]);



for i=1:length(t)
plot(t(i,1),t(i,2),'*b')
text(t(i,1),t(i,2),num2str((i)))

 plot(x_l(i,1),x_l(i,2),'vr')
 text(x_l(i,1),x_l(i,2),num2str((i)))


i=i+1;    
    
end

% 
% 
x_l_90_d=[];
% x_l_n=t(t(:,1)<=0,:)
x_l_n_2=t
% mat=[cos(pi/2) -sin(pi/2) ; sin(pi/2) cos(pi/2)];
op=1;
% figure
% hold on
postsrtarray=[];
for j=1:length(x_l_n_2)
   x_l_90_d(op,:)= x_l_n_2(j,:);
   pt=x_l_90_d(op,:)';
   
   pos=(pt'==x);
    
    sumpos=sum(pos,2);
    
    posit=find(sumpos==2);
    if(~ismember(posit,postsrtarray))


     postsrtarray(op)=posit;
   
%    plot(pt(1,:),pt(2,:),'rv')
   op=op+1;
    end
%    for k=1:3
%     pt_prev=pt;   
%     pt=mat*pt;
%     
%     pt_x=interp1(unique(t(:,1)),unique(t(:,1)),pt(1),'nearest','extrap');
%     pt_y=interp1(unique(t(:,2)),unique(t(:,2)),pt(2),'nearest','extrap');
%     
%     
%     pt=[pt_x;pt_y];
%     
%     pos=(pt'==x);
%     
%     sumpos=sum(pos,2);
%     
%     posit=find(sumpos==2);
%     
% if(~ismember(posit,postsrtarray))
%      postsrtarray(op)=posit;
%      pt=x(posit,:)';
%     ss=sum(pt_prev == pt);
%     if(ss~=2)
% %      plot(pt(1,:),pt(2,:),'r*')
%      x_l_90_d(op,:)= pt';
%      op=op+1;
%     end
% end
%    end
    
end
array90d{fg}=postsrtarray;

tt=x(postsrtarray,:);
figure
hold on
for i=1:length(tt)
plot(tt(i,1),tt(i,2),'*b')
text(tt(i,1),tt(i,2),num2str((i)))

%  plot(x_l(i,1),x_l(i,2),'vr')
%  text(x_l(i,1),x_l(i,2),num2str((i)))


i=i+1;    
    
end



end






arrayfinal90d=[];

for iu=1:length(arr)
 
 if(iu==1)   
arrayfinal90d=array90d{iu};

 else
     
  [diff,pos]=setdiff(array90d{iu},arrayfinal90d,'stable');
  arrayfinal90d=[arrayfinal90d array90d{iu}(pos)];
  
  
     
     
 end
    
    
    
    
    
end

vec=arr;
x=x_or;
x_sortdor=x(arrayfinal90d,:);
for hj=1:length(vec)
 y=gaussq(vec(hj));
 y=sortrows(y,[1 2]);

x_sortd=x_sortdor(1:vec(hj)^2,:);
figure
hold on
for i=1:length(x_sortd)
plot(x_sortd(i,1),x_sortd(i,2),'*b')
text(x_sortd(i,1),x_sortd(i,2),num2str((i)))

%   plot(y(i,1),y(i,2),'vr')
%   text(y(i,1),y(i,2),num2str((i)))


i=i+1;    
    
end

end













x=x_or;
x_sortdor=x(arrayfinal90d,:);
sortgp={};
for fg=1:length(arr)
t=x_sortdor(1:arr(fg)^2,:);
x_l=gaussq(arr(fg));

% [s,srtpost]=sort(x_l(:,1),'Ascend');
% x_l(:,1:2)=x_l(srtpost,1:2);


dist=[];
% t(:,1)=t(:,1)-0.01
srt=[];
for id=1:length(t)
    
    for ix=1:length(x_l)
        
     dist(id,ix)=sqrt((t(id,1)-x_l(ix,1))^2+(t(id,2)-x_l(ix,2))^2);
        
        
    end
       
    
end





srt=[];
    
    for ix=1:length(x_l)
        
        added=false;
      while(added==false)  
     [val,minpos]=min(dist(ix,:));
     
     [srttd,psrrtd]=sort(dist(ix,:),'Ascend');
     numberofmin=sum(srttd==val);
     
     if(numberofmin==1)
         q=1;
     else
         h=1
      dist(:,psrrtd(2))=   dist(:,psrrtd(2))-srttd(2);

     end
     
     
     
     if(~ismember(minpos,srt))
         srt(ix)=minpos;
         added=true;
     else
      dist(ix,minpos)=   dist(ix,minpos)+minpos;
         
     end
    end
    end




sortgp{fg}=srt;



end

close all




vec=arr;
x=x_or;
x_sortdor=x(arrayfinal90d,:);
for hj=1:length(vec)
x_l=gaussq(vec(hj));
x_l=x_l(sortgp{hj},:);
x_sortd=x_sortdor(1:vec(hj)^2,:);
figure
hold on
for i=1:length(x_sortd)
plot(x_sortd(i,1),x_sortd(i,2),'*b')
%text(x_sortd(i,1),x_sortd(i,2),num2str((i)))

   plot(x_l(i,1),x_l(i,2),'vr')
%   text(x_l(i,1),x_l(i,2),num2str((i)))


i=i+1;    
    
end
plot(x_sortd(:,1),x_sortd(:,2),'*b')
plot(x_l(:,1),x_l(:,2),'vr')


x=[ -1 -1]
y=[ 1 -1]
plot(x,y,'--k','linewidth',2.0)
 x=[ 1 -1]
y=[ 1 1]
plot(x,y,'--k','linewidth',2.0)
 x=[ 1 1]
y=[ -1 1]
plot(x,y,'--k','linewidth',2.0)
 x=[ -1 1]
y=[-1 -1]
plot(x,y,'--k','linewidth',2.0)
axis equal
matlab2tikz('floatFormat','%.20f','beam.tex')

end




clc


end
