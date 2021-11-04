function Resized_image = resizer(image,N)

[X,Y] = size(image);
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
Resized_image = double(padarray(image,[need_row need_col],'replicate','both'));


end