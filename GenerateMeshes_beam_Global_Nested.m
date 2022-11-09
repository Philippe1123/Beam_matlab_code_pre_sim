function [  ] = GenerateMeshes_beam_Global_Nested(  )
% close all










Path="/home/philippe/Desktop/gmsh-4.4.1-Linux64/bin/gmsh"+" ";
Order=1;
EltOpts.nl='elastoplastic';
 %figure;
foldername="beam_Global_Nested";
numberoflevels_refinement=0;
numberoflevels_order=3;
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

% NumberOfGaussPoints=[5  9 11  15 17  21  25 27 ];
NumberOfGaussPoints=[5  9 11  15 ];

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

% ar=[477,469,460,470,478,261,253,244,254,262,18,10,1,11,19,288,280,271,281,289,504,496,487,497,505,645,639,631,627,622,628,632,640,646,483,465,466,484,267,249,250,268,159,153,145,141,136,142,146,154,160,24,6,7,25,186,180,172,168,163,169,173,181,187,294,276,277,295,510,492,493,511,672,666,658,654,649,655,659,667,673,637,638,475,476,429,423,421,415,411,406,412,416,422,424,430,259,260,151,152,16,17,178,179,286,287,456,450,448,442,438,433,439,443,449,451,457,502,503,664,665,701,699,693,691,685,681,677,676,678,682,686,692,694,700,702,647,623,624,648,485,461,462,486,431,407,408,432,269,245,246,270,161,137,138,162,53,51,45,43,37,33,29,28,30,34,38,44,46,52,54,26,2,3,27,80,78,72,70,64,60,56,55,57,61,65,71,73,79,81,188,164,165,189,296,272,273,297,458,434,435,459,512,488,489,513,674,650,651,675,728,726,720,718,712,708,704,703,705,709,713,719,721,727,729,687,688,633,634,471,472,417,418,323,321,315,313,309,307,303,299,298,300,304,308,310,314,316,322,324,255,256,147,148,39,40,12,13,66,67,174,175,282,283,350,348,342,340,336,334,330,326,325,327,331,335,337,341,343,349,351,444,445,498,499,660,661,714,715,695,683,684,696,641,629,630,642,539,537,533,531,529,525,523,521,519,515,514,516,520,522,524,526,530,532,534,538,540,479,467,468,480,425,413,414,426,317,305,306,318,263,251,252,264,215,213,209,207,205,201,199,197,195,191,190,192,196,198,200,202,206,208,210,214,216,155,143,144,156,47,35,36,48,20,8,9,21,74,62,63,75,182,170,171,183,242,240,236,234,232,228,226,224,222,218,217,219,223,225,227,229,233,235,237,241,243,290,278,279,291,344,332,333,345,452,440,441,453,506,494,495,507,566,564,560,558,556,552,550,548,546,542,541,543,547,549,551,553,557,559,561,565,567,668,656,657,669,722,710,711,723,697,679,680,698,643,625,626,644,593,591,589,587,585,583,579,577,575,573,571,569,568,570,572,574,576,578,580,584,586,588,590,592,594,535,517,518,536,481,463,464,482,427,409,410,428,319,301,302,320,265,247,248,266,211,193,194,212,157,139,140,158,107,105,103,101,99,97,93,91,89,87,85,83,82,84,86,88,90,92,94,98,100,102,104,106,108,49,31,32,50,22,4,5,23,76,58,59,77,134,132,130,128,126,124,120,118,116,114,112,110,109,111,113,115,117,119,121,125,127,129,131,133,135,184,166,167,185,238,220,221,239,292,274,275,293,346,328,329,347,454,436,437,455,508,490,491,509,562,544,545,563,620,618,616,614,612,610,606,604,602,600,598,596,595,597,599,601,603,605,607,611,613,615,617,619,621,670,652,653,671,724,706,707,725,689,690,635,636,581,582,527,528,473,474,419,420,377,375,373,371,369,367,365,363,361,359,357,355,353,352,354,356,358,360,362,364,366,368,370,372,374,376,378,311,312,257,258,203,204,149,150,95,96,41,42,14,15,68,69,122,123,176,177,230,231,284,285,338,339,404,402,400,398,396,394,392,390,388,386,384,382,380,379,381,383,385,387,389,391,393,395,397,399,401,403,405,446,447,500,501,554,555,608,609,662,663,716,717];
ar = [145,141,136,142,146,85,81,76,82,86,10,6,1,7,11,100,96,91,97,101,160,156,151,157,161,209,205,201,197,196,198,202,206,210,149,137,138,150,89,77,78,90,29,25,21,17,16,18,22,26,30,14,2,3,15,44,40,36,32,31,33,37,41,45,104,92,93,105,164,152,153,165,224,220,216,212,211,213,217,221,225,203,204,143,144,119,115,113,111,107,106,108,112,114,116,120,83,84,23,24,8,9,38,39,98,99,134,130,128,126,122,121,123,127,129,131,135,158,159,218,219,207,199,200,208,179,177,175,173,171,169,167,166,168,170,172,174,176,178,180,147,139,140,148,117,109,110,118,87,79,80,88,59,57,55,53,51,49,47,46,48,50,52,54,56,58,60,27,19,20,28,12,4,5,13,42,34,35,43,74,72,70,68,66,64,62,61,63,65,67,69,71,73,75,102,94,95,103,132,124,125,133,162,154,155,163,194,192,190,188,186,184,182,181,183,185,187,189,191,193,195,222,214,215,223];
x=gaussq(NumberOfGaussPoints(end));
 x=x(ar,:);
 x=x(1:(NumberOfGaussPoints(idOrder+1))^2,:);    
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

