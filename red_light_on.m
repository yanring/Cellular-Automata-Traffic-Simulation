function [ pixel ] = red_light_on( pixel )
%red_light_on 设置红灯为亮
%   此处显示详细说明
pixel(end,end-1) = -2;
%pixel(floor(end/2),end-1) = -2;
end

