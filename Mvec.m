function [xmV,ymV] = Mvec(refFr,curFr,N,W)
rF = double(refFr); % frame #1
cF = double(curFr); % frame #2

[Height,Width] = size(rF);

A1 =double(padarray(rF,[W/2 W/2],'replicate'));
B1 =double(padarray(cF,[W/2 W/2],'replicate'));

x = int16(zeros(Height/N,Width/N));% x-component of motion vector
y = int16(zeros(Height/N,Width/N));% y-component of motion vector

%% Sum of absolute diffrences
for r = N:N:Height
    bR = floor(r/N);
    for c = N:N:Width
        bC = floor(c/N);
        D = 1.0e+10;% initial SAD
        
        for u = -N:N
            for v = -N:N
                d = B1(r+1:r+N,c+1:c+N)-A1(r+u+1:r+u+N,c+v+1:c+v+N);
                
                d = sum(abs(d(:)));% SAD
                if d < D
                    D = d;
                    x(bR,bC) = v;
                    y(bR,bC) = u;
                end
            end
        end
        
        
    end
end
%% motion vectors
xmV=x;   ymV=y;

end