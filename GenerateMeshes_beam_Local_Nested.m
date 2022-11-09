function [  ] = GenerateMeshes_beam_Local_Nested(  )
% close all




Path="/home/philippe/Desktop/gmsh-4.4.1-Linux64/bin/gmsh"+" ";
Order=1;
EltOpts.nl='elastoplastic';
 %figure;
foldername="beam_Local_Nested";
numberoflevels_refinement=0;
numberoflevels_order=7;
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

NumberOfGaussPoints=[25 27];

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

    
% ar=[31,40,41,32,28,4,37,5,1,33,58,43,50,49,42,59,34,51,60,61,52,46,6,55,7,29,22,39,14,13,38,23,30,11,20,21,12,15,56,25,48,10,2,19,3,47,24,57,16,35,76,45,68,17,74,27,66,67,44,77,36,65,26,75,18,71,80,81,72,69,62,79,54,64,8,73,9,53,78,63,70];
%     ar=[155,168,169,156,144,12,157,13,1,147,64,161,52,51,160,65,148,43,56,57,44,40,4,53,5,151,116,165,104,103,164,117,152,99,112,113,100,95,60,109,48,92,8,105,9,47,108,61,96,145,38,159,26,93,34,107,22,41,30,55,18,25,158,39,146,21,106,35,94,17,54,31,42,15,28,29,16,14,2,27,3,153,142,167,130,129,166,143,154,127,140,141,128,125,114,139,102,121,62,135,50,119,36,133,24,118,10,131,11,101,138,115,126,49,134,63,122,23,132,37,120,149,90,163,78,123,88,137,76,97,86,111,74,77,162,91,150,75,136,89,124,73,110,87,98,71,84,85,72,69,58,83,46,67,32,81,20,66,6,79,7,45,82,59,70,19,80,33,68];
% ar=[221,240,241,222,210,12,229,13,1,215,126,235,108,107,234,127,216,101,120,121,102,96,6,115,7,341,360,361,342,335,246,355,228,329,132,349,114,324,18,343,19,227,354,247,336,113,348,133,330,261,280,281,262,259,242,279,224,255,166,275,148,223,278,243,260,211,50,231,32,147,274,167,256,97,44,117,26,31,230,51,212,25,116,45,98,337,284,357,266,325,56,345,38,265,356,285,338,249,52,269,34,248,14,267,15,37,344,57,326,33,268,53,250,21,40,41,22,20,2,39,3,331,170,351,152,291,130,311,112,217,164,237,146,151,350,171,332,145,236,165,218,141,160,161,142,139,122,159,104,135,46,155,28,134,8,153,9,111,310,131,292,103,158,123,140,27,154,47,136,339,322,359,304,303,358,323,340,301,320,321,302,299,282,319,264,297,244,317,226,293,168,313,150,287,54,307,36,286,16,305,17,263,318,283,300,225,316,245,298,213,88,233,70,149,312,169,294,69,232,89,214,35,306,55,288,327,94,347,76,289,92,309,74,253,128,273,110,251,90,271,72,137,84,157,66,109,272,129,254,99,82,119,64,75,346,95,328,73,308,93,290,71,270,91,252,65,156,85,138,63,118,83,100,61,80,81,62,59,42,79,24,58,4,77,5,23,78,43,60,333,208,353,190,295,206,315,188,257,204,277,186,219,202,239,184,189,352,209,334,187,314,207,296,185,276,205,258,183,238,203,220,181,200,201,182,179,162,199,144,177,124,197,106,175,86,195,68,173,48,193,30,172,10,191,11,143,198,163,180,105,196,125,178,67,194,87,176,29,192,49,174];
% ar=[477,504,505,478,469,288,497,262,460,18,487,19,261,496,289,470,253,280,281,254,244,10,271,11,1,645,672,673,646,639,510,667,484,631,294,659,268,627,186,655,160,622,24,649,25,483,666,511,640,465,180,493,154,267,658,295,632,249,172,277,146,159,654,187,628,153,492,181,466,145,276,173,250,141,168,169,142,136,6,163,7,637,456,665,430,475,450,503,424,429,664,457,638,423,502,451,476,421,448,449,422,415,286,443,260,411,178,439,152,406,16,433,17,259,442,287,416,151,438,179,412,701,728,729,702,699,674,727,648,693,512,721,486,691,458,719,432,685,296,713,270,681,188,709,162,677,80,705,54,676,26,703,27,647,726,675,700,623,78,651,52,485,720,513,694,461,72,489,46,431,718,459,692,407,70,435,44,269,712,297,686,245,64,273,38,161,708,189,682,137,60,165,34,53,704,81,678,51,650,79,624,45,488,73,462,43,434,71,408,37,272,65,246,33,164,61,138,29,56,57,30,28,2,55,3,687,350,715,324,633,348,661,322,471,342,499,316,417,340,445,314,323,714,351,688,321,660,349,634,315,498,343,472,313,444,341,418,309,336,337,310,307,282,335,256,303,174,331,148,299,66,327,40,298,12,325,13,255,334,283,308,147,330,175,304,39,326,67,300,695,566,723,540,683,242,711,216,641,564,669,538,629,240,657,214,539,722,567,696,537,668,565,642,533,560,561,534,531,506,559,480,529,452,557,426,525,344,553,318,523,290,551,264,521,236,549,210,519,182,547,156,515,74,543,48,514,20,541,21,479,558,507,532,467,234,495,208,425,556,453,530,413,232,441,206,317,552,345,526,305,228,333,202,263,550,291,524,251,226,279,200,215,710,243,684,213,656,241,630,209,548,237,522,207,494,235,468,205,440,233,414,201,332,229,306,199,278,227,252,197,224,225,198,195,170,223,144,191,62,219,36,190,8,217,9,155,546,183,520,143,222,171,196,47,542,75,516,35,218,63,192,697,620,725,594,679,134,707,108,643,618,671,592,625,132,653,106,593,724,621,698,591,670,619,644,589,616,617,590,587,562,615,536,585,508,613,482,583,454,611,428,579,346,607,320,577,292,605,266,575,238,603,212,573,184,601,158,571,130,599,104,569,76,597,50,568,22,595,23,535,614,563,588,517,128,545,102,481,612,509,586,463,126,491,100,427,610,455,584,409,124,437,98,319,606,347,580,301,120,329,94,265,604,293,578,247,118,275,92,211,602,239,576,193,116,221,90,157,600,185,574,139,114,167,88,107,706,135,680,105,652,133,626,103,598,131,572,101,544,129,518,99,490,127,464,97,436,125,410,93,328,121,302,91,274,119,248,89,220,117,194,87,166,115,140,85,112,113,86,83,58,111,32,82,4,109,5,49,596,77,570,31,110,59,84,689,404,717,378,635,402,663,376,581,400,609,374,527,398,555,372,473,396,501,370,419,394,447,368,377,716,405,690,375,662,403,636,373,608,401,582,371,554,399,528,369,500,397,474,367,446,395,420,365,392,393,366,363,338,391,312,361,284,389,258,359,230,387,204,357,176,385,150,355,122,383,96,353,68,381,42,352,14,379,15,311,390,339,364,257,388,285,362,203,386,231,360,149,384,177,358,95,382,123,356,41,380,69,354];
%ar=[477,469,460,470,478,261,253,244,254,262,18,10,1,11,19,288,280,271,281,289,504,496,487,497,505,645,639,631,627,622,628,632,640,646,483,465,466,484,267,249,250,268,159,153,145,141,136,142,146,154,160,24,6,7,25,186,180,172,168,163,169,173,181,187,294,276,277,295,510,492,493,511,672,666,658,654,649,655,659,667,673,637,638,475,476,429,423,421,415,411,406,412,416,422,424,430,259,260,151,152,16,17,178,179,286,287,456,450,448,442,438,433,439,443,449,451,457,502,503,664,665,701,699,693,691,685,681,677,676,678,682,686,692,694,700,702,647,623,624,648,485,461,462,486,431,407,408,432,269,245,246,270,161,137,138,162,53,51,45,43,37,33,29,28,30,34,38,44,46,52,54,26,2,3,27,80,78,72,70,64,60,56,55,57,61,65,71,73,79,81,188,164,165,189,296,272,273,297,458,434,435,459,512,488,489,513,674,650,651,675,728,726,720,718,712,708,704,703,705,709,713,719,721,727,729,687,688,633,634,471,472,417,418,323,321,315,313,309,307,303,299,298,300,304,308,310,314,316,322,324,255,256,147,148,39,40,12,13,66,67,174,175,282,283,350,348,342,340,336,334,330,326,325,327,331,335,337,341,343,349,351,444,445,498,499,660,661,714,715,695,683,684,696,641,629,630,642,539,537,533,531,529,525,523,521,519,515,514,516,520,522,524,526,530,532,534,538,540,479,467,468,480,425,413,414,426,317,305,306,318,263,251,252,264,215,213,209,207,205,201,199,197,195,191,190,192,196,198,200,202,206,208,210,214,216,155,143,144,156,47,35,36,48,20,8,9,21,74,62,63,75,182,170,171,183,242,240,236,234,232,228,226,224,222,218,217,219,223,225,227,229,233,235,237,241,243,290,278,279,291,344,332,333,345,452,440,441,453,506,494,495,507,566,564,560,558,556,552,550,548,546,542,541,543,547,549,551,553,557,559,561,565,567,668,656,657,669,722,710,711,723,697,679,680,698,643,625,626,644,593,591,589,587,585,583,579,577,575,573,571,569,568,570,572,574,576,578,580,584,586,588,590,592,594,535,517,518,536,481,463,464,482,427,409,410,428,319,301,302,320,265,247,248,266,211,193,194,212,157,139,140,158,107,105,103,101,99,97,93,91,89,87,85,83,82,84,86,88,90,92,94,98,100,102,104,106,108,49,31,32,50,22,4,5,23,76,58,59,77,134,132,130,128,126,124,120,118,116,114,112,110,109,111,113,115,117,119,121,125,127,129,131,133,135,184,166,167,185,238,220,221,239,292,274,275,293,346,328,329,347,454,436,437,455,508,490,491,509,562,544,545,563,620,618,616,614,612,610,606,604,602,600,598,596,595,597,599,601,603,605,607,611,613,615,617,619,621,670,652,653,671,724,706,707,725,689,690,635,636,581,582,527,528,473,474,419,420,377,375,373,371,369,367,365,363,361,359,357,355,353,352,354,356,358,360,362,364,366,368,370,372,374,376,378,311,312,257,258,203,204,149,150,95,96,41,42,14,15,68,69,122,123,176,177,230,231,284,285,338,339,404,402,400,398,396,394,392,390,388,386,384,382,380,379,381,383,385,387,389,391,393,395,397,399,401,403,405,446,447,500,501,554,555,608,609,662,663,716,717];


x=gaussq(NumberOfGaussPoints(end));
ar=[701,699,697,695,693,691,687,685,683,681,679,677,676,678,680,682,684,686,688,692,694,696,698,700,702,647,645,643,641,639,637,633,631,629,627,625,623,622,624,626,628,630,632,634,638,640,642,644,646,648,593,591,589,587,585,583,579,577,575,573,571,569,568,570,572,574,576,578,580,584,586,588,590,592,594,539,537,535,533,531,529,525,523,521,519,517,515,514,516,518,520,522,524,526,530,532,534,536,538,540,485,483,481,479,477,475,471,469,467,465,463,461,460,462,464,466,468,470,472,476,478,480,482,484,486,431,429,427,425,423,421,417,415,413,411,409,407,406,408,410,412,414,416,418,422,424,426,428,430,432,323,321,319,317,315,313,309,307,305,303,301,299,298,300,302,304,306,308,310,314,316,318,320,322,324,269,267,265,263,261,259,255,253,251,249,247,245,244,246,248,250,252,254,256,260,262,264,266,268,270,215,213,211,209,207,205,201,199,197,195,193,191,190,192,194,196,198,200,202,206,208,210,212,214,216,161,159,157,155,153,151,147,145,143,141,139,137,136,138,140,142,144,146,148,152,154,156,158,160,162,107,105,103,101,99,97,93,91,89,87,85,83,82,84,86,88,90,92,94,98,100,102,104,106,108,53,51,49,47,45,43,39,37,35,33,31,29,28,30,32,34,36,38,40,44,46,48,50,52,54,26,24,22,20,18,16,12,10,8,6,4,2,1,3,5,7,9,11,13,17,19,21,23,25,27,80,78,76,74,72,70,66,64,62,60,58,56,55,57,59,61,63,65,67,71,73,75,77,79,81,134,132,130,128,126,124,120,118,116,114,112,110,109,111,113,115,117,119,121,125,127,129,131,133,135,188,186,184,182,180,178,174,172,170,168,166,164,163,165,167,169,171,173,175,179,181,183,185,187,189,242,240,238,236,234,232,228,226,224,222,220,218,217,219,221,223,225,227,229,233,235,237,239,241,243,296,294,292,290,288,286,282,280,278,276,274,272,271,273,275,277,279,281,283,287,289,291,293,295,297,350,348,346,344,342,340,336,334,332,330,328,326,325,327,329,331,333,335,337,341,343,345,347,349,351,458,456,454,452,450,448,444,442,440,438,436,434,433,435,437,439,441,443,445,449,451,453,455,457,459,512,510,508,506,504,502,498,496,494,492,490,488,487,489,491,493,495,497,499,503,505,507,509,511,513,566,564,562,560,558,556,552,550,548,546,544,542,541,543,545,547,549,551,553,557,559,561,563,565,567,620,618,616,614,612,610,606,604,602,600,598,596,595,597,599,601,603,605,607,611,613,615,617,619,621,674,672,670,668,666,664,660,658,656,654,652,650,649,651,653,655,657,659,661,665,667,669,671,673,675,728,726,724,722,720,718,714,712,710,708,706,704,703,705,707,709,711,713,715,719,721,723,725,727,729,689,690,635,636,581,582,527,528,473,474,419,420,377,375,373,371,369,367,365,363,361,359,357,355,353,352,354,356,358,360,362,364,366,368,370,372,374,376,378,311,312,257,258,203,204,149,150,95,96,41,42,14,15,68,69,122,123,176,177,230,231,284,285,338,339,404,402,400,398,396,394,392,390,388,386,384,382,380,379,381,383,385,387,389,391,393,395,397,399,401,403,405,446,447,500,501,554,555,608,609,662,663,716,717]


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
