%% code 3 optional
%% for 50% of image quality
clear all;
close all; clc;
N =8;
W =16;

%% input frames
frm = cell(1,12);
frm{1,1} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00001.jpg'));
frm{1,2} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00011.jpg'));
frm{1,3} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00021.jpg'));
frm{1,4} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00031.jpg'));
frm{1,5} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00041.jpg'));
frm{1,6} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00051.jpg'));
frm{1,7} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00061.jpg'));
frm{1,8} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00071.jpg'));
frm{1,9} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00081.jpg'));
frm{1,10} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00091.jpg'));
frm{1,11} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00101.jpg'));
frm{1,12} = rgb2gray(imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00111.jpg'));


%%
[height width]=size(uint8(frm{1,1}));

%% encode and reconstrcut ref frame
%[frame1Encode , dictionary1] = fullEncode359( frames{1,1},N , q_mtrx); %TX

[h1,w1,ensig1,dict1,~] = encoder(frm{1,1},50);

% reconstructed ref. frame
recon_Ifrm = decoder(ensig1,dict1,h1,w1,50);

%%
n = 12;
N=8; W =16;
xmotionv=cell(1,n);
ymotionv=cell(1,n);
residualsCollected=cell(1,n);
rec = cell(1,n);
pred = cell(1,n);
for k=2:n
[xx,yy] = Mvec(recon_Ifrm,frm{1,k},N,W);%TX
xmotionv{1,k} = xx;
ymotionv{1,k}=yy;
%[~,~,frameresidual] = reconstruct(reconstructed_I_frame,frames{1,k},xx,yy,N,W);%TX
[pre,rec,frameresidual] = ReconstructI(recon_Ifrm,frm{1,k},xx,yy,N,W);
residualsCollected{1,k}=frameresidual;
recons{1,k} = rec;
pred{1,k} = pre;
clear xx; clear yy; clear frameresidual;
end

% % Encode motion vectors
% for e=2:numberofFrames
%     [hufx ,DICTx] = justHufEncode359(xmotionv{1,e});
%     [hufy ,DICTy] = justHufEncode359(ymotionv{1,e});
% end

%% Encode Residuals
encodedRes = cell(1,n);
dict = cell(1,n);
for e=2:n
    [h,w,encodedRes{1,e}, dict{1,e},~]=encoder(residualsCollected{1,e},50);
end

%% ---RX----

%recon_Ifrm = (decoder(ensig1,dict1,h1,w1,50));
decodedRes=cell(1,n);
ReconImage=cell(1,n);
ReconImage{1,1}=recon_Ifrm;
predImg = cell(1,n);
%%
for d=2:n  
    decodedRes{1,d}=decoder(encodedRes{1,d},dict{1,d},h1,w1,50);
    predictedImage = predict(frm{1,1},xmotionv{1,d},ymotionv{1,d},N,W);
    predImg{1,d} = predictedImage;
    ReconImage{1,d}=decodedRes{1,d}+predictedImage;
    ReconImage{1,d}=recons{1,d};
end

%%
% video = VideoWriter('yourvideo4.mp4'); %create the video object
% open(video); %open the file for writing
% for d=1:12 %where N is the number of images
%   I = imread(ReconImage{1,d}); %read the next image
%   writeVideo(video,I); %write the image to file
% end
% close(video); %close the file