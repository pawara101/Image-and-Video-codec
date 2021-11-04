function [predictedImage,reconstructed,residual] = ReconstructI(rImage,cImage,mvx,mvy,N,W)
rI =double(padarray(rImage,[W/2 W/2],'replicate'));
cI =double(padarray(cImage,[W/2 W/2],'replicate'));

[Height,Width] = size(rImage);
N2 = 2*N;
residual = double(zeros(Height,Width)); 
reconstructed = double(zeros(Height,Width)); 
predictedImage = double(zeros(Height,Width)); 

x=mvx;
y=mvy;

for r = 1:N:Height
    bR = floor(r/N) + 1;
    for c = 1:N:Width
        bC = floor(c/N) + 1;
        x1 = x(bR,bC);
        y1 = y(bR,bC);
        predictedImage(r:r+N-1,c:c+N-1) = rI(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);
        residual(r:r+N-1,c:c+N-1) = cI(r+N:r+N2-1,c+N:c+N2-1)-rI(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);
        reconstructed(r:r+N-1,c:c+N-1) = rI(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1)+ residual(r:r+N-1,c:c+N-1);
    end
end

end