function [recon_img] = decoder(encsig,dict,H,W,ql)

decosig = huffmandeco(encsig,dict);
rows = H;
columns = W;
image_decoded=reshape(decosig,[rows,columns]);

%% unquantizing
quantmat = [16 11 10 16 24 40 51 61; 
      12 12 14 19 26 58 60 55;
      14 13 16 24 40 57 69 56;
      14 17 22 29 51 87 80 62; 
      18 22 37 56 68 109 103 77;
      24 35 55 64 81 104 113 92;
      49 64 78 87 103 121 120 101; 
      72 92 95 98 112 100 103 99]; %% quantization matrix
  
if (ql < 50)
    q = 5000/ql;
else
    q = 200 - 2*ql;
end

Q = floor((q*quantmat + 50) / 100);
Q(Q == 0) = 1; % Prevent divide by 0 error

  
f1=ones(1,W/8);
f2=ones(1,H/8);
f1=f1*8;
f2=f2*8;
unquant_img = mat2cell(image_decoded,f2,f1);

r4 =1;
for i=1:H/8% rows 
   c4=0;
    for j=1:W/8 % columns
        xx3 = double(unquant_img{i,j}).*Q;
        c4 = c4+1;
        mbDCT_dequant{r4,c4} = xx3;
    end
        r4 = r4+1;
        
end 
mbDCT_dequant_img = cell2mat(mbDCT_dequant);
% figure;
% imshow(mbDCT_dequant_img);

%% Inverse discreet cosine transform

r5 =1;
for i=1:H/8% rows 
   c5=0;
    for j=1:W/8 % columns
        xx4 = idct2(mbDCT_dequant{i,j});
        c5 = c5+1;
        MB_idct{r5,c5} = xx4;
    end
        r5 = r5+1;
        
end 
recon_img = cell2mat(MB_idct)/255;
end