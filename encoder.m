function [H,W,encsig,dict,mbDCT_quantout] =encoder(gray_image,ql)
% 
%% Make image size divisible by 8(N)

N = 8;
[X,Y] = size(gray_image);
if mod(X,N)~=0
    row1 = floor(X/N)*N;  % cut off the extra rows if not divisible by N
    row = row1 +8 ;
    need_row = (row-X)/2 ;
else
    row = X;             % else keep as it is
    need_row = 0 ;
end
if mod(Y,N)~=0
    col1 = floor(Y/N)*N;   % cut off the extra cols if not divisible by N
    col=col1+8 ;
    need_col = (col-Y)/2;
else
    col = Y;              % else Keep as it is
    need_col = 0 ;
end
img = double(padarray(gray_image,[need_row need_col],'replicate','both'));

%%
[H,W]=size(img);
f1=ones(1,W/8);
f2=ones(1,H/8);
f1=f1*8;
f2=f2*8;
mb=mat2cell(img,f2,f1);

%% Discreet cosine transform
xx = zeros(8,8);
r2 = 1;
for i=1:H/8% rows 
   c2=0;
    for j=1:W/8 % columns
        xx = dct2(double(mb{i,j}));
        c2 = c2+1;
        mbDCT{r2,c2} = xx;
    end
        r2 = r2+1;
        
end
mbDCTout = cell2mat(mbDCT);
% figure;
% imshow(mbDCTout);

%% vector quantization 

quantmat = [16 11 10 16 24 40 51 61; 
      12 12 14 19 26 58 60 55;
      14 13 16 24 40 57 69 56;
      14 17 22 29 51 87 80 62; 
      18 22 37 56 68 109 103 77;
      24 35 55 64 81 104 113 92;
      49 64 78 87 103 121 120 101; 
      72 92 95 98 112 100 103 99]; %% quantization matrix
  
%   if ql == 1
%       qm = quantmat*1.5;
%   elseif ql == 2
%       qm = quantmat;
%   elseif ql == 3
%       qm = quantmat*0.5;
%   end
%   

if (ql < 50)
    q = 5000/ql;
else
    q = 200 - 2*ql;
end

Q = floor((q*quantmat + 50) / 100);
Q(Q == 0) = 1; % Prevent divide by 0 error
    
r3 =1;
for i=1:H/8% rows 
   c3=0;
    for j=1:W/8 % columns
        xx2 = double(mbDCT{i,j})./Q;
        xx2_rounded = round(xx2);
        c3 = c3+1;
        mbDCT_quant{r3,c3} = xx2_rounded;
    end
        r3 = r3+1;
        
end   
  
 mbDCT_quantout = cell2mat(mbDCT_quant);
% figure;
% imshow(mbDCT_quantout);

%% probability 

[g,~,intensity_val]=grp2idx(mbDCT_quantout(:));
frequency = accumarray(g,1);% frequency thresholds
[intensity_val frequency];
[rows,columns] = size(mbDCTout);
prob = frequency./(rows*columns) ;
T = table(intensity_val,frequency,prob);
Array_probability=table2array(T(:,3));
Array_intensity=table2array(T(:,1));

%% huffman encoding for quantized image

[dict,avglen] = huffmandict(Array_intensity,Array_probability);
encsig = huffmanenco(mbDCT_quantout(:),dict);

end