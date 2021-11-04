%% Part 1
clear all;close all;clc;

% RGB image
image = imread('E:\Academics\Final Year\EE 596\mini project\frames\scene00001.jpg');%1
figure;
imshow(image);

% gray scale image
gray_img =rgb2gray(image); 
figure;
imshow(gray_img);

%% qunatizing and Encoding 
[H,W,encsig,dict,DCToutQ] = encoder(gray_img,50);

file3 = fopen('fullencoded.txt','w');
[r,~]=size(encsig);
for c=1:r
    fprintf(file3, '%d',encsig(c));
end
%% Dequantizing and decoding
decoded_signal = decoder(encsig,dict,H,W,50);

[MBdeq,MBidct] = invQdct(DCToutQ,H,W,50);

figure;
imshow(decoded_signal);

%% Compression Ratio

CR = (H*W*8)/length(encsig);



