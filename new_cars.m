function [pixel,pixel_speed] = new_cars(pixel, entry,pixel_speed)
%将新车加入到元胞空间矩阵中，并且可以控制加新车的密度。

if entry > 0&&1>rand()%1>rand()为方便设置进入道路的车流量密度
       pixel(1,end-1) = 1;
       pixel_speed(1,end-1) = 4;

end
%%