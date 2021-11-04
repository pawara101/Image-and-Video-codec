%% test Compensation

clear all; close all; clc;

inFile1 = 'E:\Academics\Final Year\EE 596\mini project\frames\scene00001.jpg';
inFile2 = 'E:\Academics\Final Year\EE 596\mini project\frames\scene00011.jpg';
A = rgb2gray(imread(inFile1)); % frame #1
B = rgb2gray(imread(inFile2)); % frame #2

N = 8;% block size is N x N pixels
W = 16; % search window size is W x W pixels
[Height,Width] = size(A);
% figure;
% imshow(A);
%%
A1 = double(padarray(A,[W/2 W/2],'replicate'));
B1 = double(padarray(B,[W/2 W/2],'replicate'));

NumRblk = Height/N;
NumCblk = Width/N;

x = int16(zeros(Height/N,Width/N));% x-component of motion vector
y = int16(zeros(Height/N,Width/N));% y-component of motion vector
% pf = single(zeros(Height,Width)); % predicted frame
% Find motion vectors to 1/4 pel accuracy

%figure;imshow(B); title('Superimposed motion vectors');
%hold on;
% display image & superimpose motion vectors

for r = N:N:Height
    rblk = floor(r/N);
        for c = N:N:Width
            cblk = floor(c/N);
            D = 1.0e+10;% initial city block distance
            
                for u = -N:N
                    for v = -N:N
                            d = B1(r+1:r+N,c+1:c+N)-A1(r+u+1:r+u+N,c+v+1:c+v+N);
                            
                            d = sum(abs(d(:)));% city block distance between pixels
                                if d < D
                                   D = d;
                                   x(rblk,cblk) = v;y(rblk,cblk) = u;
                                end
                    end
                end

%quiver(c+y(rblk,cblk),r+x(rblk,cblk),x(rblk,cblk),y(rblk,cblk),'b','LineWidth',1)


        end
end
%hold off;

%Reconstruct current frame using prediction error & reference frame

N2 = 2*N;
pf = double(zeros(Height,Width)); % prediction frame
Br = double(zeros(Height,Width)); % reconstructed frame

for r = 1:N:Height
        rblk = floor(r/N) + 1;
            for c = 1:N:Width
                cblk = floor(c/N) + 1;
                x1 = x(rblk,cblk); y1 = y(rblk,cblk);
                pi(r:r+N-1,c:c+N-1) = A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);
                pf(r:r+N-1,c:c+N-1) = B1(r+N:r+N2-1,c+N:c+N2-1)-A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);
                Br(r:r+N-1,c:c+N-1) = A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1)+ pf(r:r+N-1,c:c+N-1);
            end
end
%
PF = uint8(round(pf));
BR = uint8(round(Br));
figure;imshow(uint8(round(pi)));title('predicted image');
figure;imshow(uint8(round(Br)));title('Reconstructed image');

