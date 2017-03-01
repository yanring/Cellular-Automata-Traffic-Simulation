function [ pixel ] = create_street( pixel , amount ,side_length)
%给小区区域添加道路
%   此处显示详细说明
step = floor(side_length/(amount)+1);%出入口相隔的步长
start_point = floor((size(pixel,1)-side_length)/2);
for i = start_point+step:step:start_point+side_length
    pixel(i,1:side_length+1) = 0;
end


end

