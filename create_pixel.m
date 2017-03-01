function pixel = create_pixel(B, L,side_length)
%生成二维数组，表示元胞空间的状态矩阵
global pixellength;%道路长度
pixel = zeros(pixellength,B+2);%生成pixel矩阵
pixel(1:pixellength,[B,B+2]) = -1000;%设置障碍行程干路
pixel(floor((pixellength-side_length)/2):pixellength-floor((pixellength-side_length)/2),1:B-1)=-1000;%生成小区范围
for i = 1:pixellength
    if 0.7>rand();
        pixel(i,B+1)=1;
    end
end
%%
