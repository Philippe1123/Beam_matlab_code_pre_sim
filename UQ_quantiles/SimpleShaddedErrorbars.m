function [ output_args ] = SimpleShaddedErrorbars( x,y,upperY,underY )
%Addapted from %
% Rob Campbell - November 2009
%ShadedErrorbar found on matlab repository.
%figure
% H.mainLine=plot(x,y,'k');
% mainLineColor=get(H.mainLine,'color');
% edgeColor=mainLineColor+(1-mainLineColor)*0.55;
blue=[2 78 255]/255;
H.mainLine=plot(x,y,'color',blue);
mainLineColor=get(H.mainLine,'color');
edgeColor=mainLineColor+(1-mainLineColor)*0.55;

patchSaturation=0.15;

        faceAlpha=patchSaturation;
        patchColor=mainLineColor;
        
     yP=[upperY,fliplr(underY)];
    xP=[x,fliplr(x)];
    
       H.patch=patch(xP,yP,1,'facecolor',patchColor, ...
                  'edgecolor','none', ...
                  'facealpha',faceAlpha);
              
%     H.edge(1)=plot(x,lE,'-','color',edgeColor);
%     H.edge(2)=plot(x,uE,'-','color',edgeColor);

end

