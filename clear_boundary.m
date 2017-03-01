function pixel = clear_boundary(pixel)
%将要离开系统的车辆，需要将车辆从系统中移除，即将元胞空间中最后一行大于0 的设为0
[L,W] = size(pixel);
if pixel(L,end-1)==1
    pixel(L,end-1)=0;
end
pixel(pixel(:,1)==-3)=0;
