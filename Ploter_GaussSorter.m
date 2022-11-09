function [ output_args ] = Ploter( input_args )
%PLOTER Summary of this function goes here
%   Detailed explanation goes here

% close all

%ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,67,76,44,45,77,68,36,35,10,2,19,3,46,6,55,7,30,29,13,22,38,39,23,14,    15,16,17,18,24,25,26,27,33,34,42,43,47,48,49,50,53,54,56,57,58,59,62,63,65,66,69,70,74,75,78,79];
ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,67,76,44,45,77,68,36,35,10,2,19,3,46,6,55,7,30,29,13,22,38,39,23,14,33, 17 65 49 58 74 26 42 43 27 75 59 50 66 18 34 15 47 56 24 25 57 48 16 69 53 62 78 79 63 54 70];
ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,67,76,44,45,77,68,36,35,10,2,19,3,46,6,55,7,30,29,13,22,38,39,23,14,33, 58 43 50 34 49 42 59 17 74 27 66 18 65 26 75 69 62 79 54 70 53 78 63 16 47 24 57 15 56 25 48];
ar=[31,40,41,32,71,80,81,72,1,11,20,21,12,51,60,61,52,28,4,37,5,64,8,73,9,36 67 44 77 35 76 45 68 10 2 19 3 46 6 55 7 30 13 38 23 29 22 39 14,33, 58 43 50 34 49 42 59 17 74 27 66 18 65 26 75 69 62 79 54 70 53 78 63 16 47 24 57 15 56 25 48];

x=gaussq(9);
x=x(ar,:);
t=x;
x_l=gaussq(5);
dist=[];
% t(:,1)=t(:,1)-0.01
srt=[];
for id=1:length(x_l)
    
    for ix=1:length(x_l)
        
     dist(id,ix)=sqrt((t(id,1)-x_l(ix,1))^2+(t(id,2)-x_l(ix,2))^2);
        
        
    end
    
%       added=false;
%       while(added==false)  
%     
%     [val,minpos]=min(dist(id,:));
%     
%     
%     [srttd,psrrtd]=sort(dist(id,:),'Ascend');
%      numberofmin=sum(srttd==val);
%      
%      if(numberofmin==1)
%          q=1;
%      else
%          h=1
%          dist(id,psrrtd(2))=   dist(id,psrrtd(2))-10;
%      end
% 
%         
%      if(~ismember(minpos,srt))
%          srt(id)=minpos;
%          added=true;
%      else
%       dist(id,minpos)=   dist(id,minpos)+10;
%          
%      end
%     end
    
    
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
x=t;
t=x_l(srt,:);

for i=1:length(t)
plot(t(i,1),t(i,2),'vr')
text(t(i,1),t(i,2),num2str((i)))

 plot(x(i,1),x(i,2),'*b')
 text(x(i,1),x(i,2),num2str((i)))


i=i+1;    
    
end

end
