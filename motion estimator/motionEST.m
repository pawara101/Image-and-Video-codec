function [RES,prdictf,RF,Mvx,Mvy] = motionEST(refIMG,targIMG,N,windowsize)
% RES = residual
% prdictf = estimated frame
% RF = reconstructed image

% N = 8;% block size is N x N pixels
% M = 16; % search window size is M x M pixels

[Height,Width] = size(refIMG);

A1 = double(padarray(refIMG,[windowsize/2 windowsize/2],'replicate'));
B1 = double(padarray(targIMG,[windowsize/2 windowsize/2],'replicate'));

% NumRblk = Height/N;
% NumCblk = Width/N;

x = int16(zeros(Height/N,Width/N));% x-component of motion vector
y = int16(zeros(Height/N,Width/N));% y-component of motion vector

%% motion vectors

%figure;imshow(B); title('Superimposed motion vectors');
%hold on;
% display image & superimpose motion vectors

for r = N:N:Height
    rb = floor(r/N);
        for c = N:N:Width
            cb = floor(c/N);
            D = 1.0e+10;% initial city block distance
            
                for u = -N:N
                    for v = -N:N
                        % SAD method
                            d = B1(r+1:r+N,c+1:c+N)-A1(r+u+1:r+u+N,c+v+1:c+v+N); 
                            
                            d = sum(abs(d(:)));%
                                if d < D
                                   D = d;
                                   x(rb,cb) = v;
                                   y(rb,cb) = u;
                                end
                    end
                end

%quiver(c+y(rb,cblk),r+x(rb,cblk),x(rb,cblk),y(rb,cblk),'b','LineWidth',1)


        end
end
%hold off;

%% reconstruction
N2 = 2*N;
residual = double(zeros(Height,Width)); % prediction frame
Br = double(zeros(Height,Width)); % reconstructed frame

for r = 1:N:Height
        rb = floor(r/N) + 1;
            for c = 1:N:Width
                cb = floor(c/N) + 1;
                x1 = x(rb,cb); 
                y1 = y(rb,cb); 
                %%prdictf(r:r+N-1,c:c+N-1) = A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);
                residual(r:r+N-1,c:c+N-1) = B1(r+N:r+N2-1,c+N:c+N2-1)-A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);% residual
                Br(r:r+N-1,c:c+N-1) = A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1)+ residual(r:r+N-1,c:c+N-1);% reconstructed image
                prdictf(r:r+N-1,c:c+N-1) = A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);
            end
end

RF = uint8(round(Br));
RES = uint8(round(residual)); % residual
Mvx = x1; % motion vector x
Mvy = y1; % motion vector y


end