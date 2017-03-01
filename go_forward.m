function [pixel,pixel_speed,move_steps,num_of_cars,jam_cars,main_road_move_steps] = go_forward(pixel,pixel_speed)
%前进规则
%否则，该车以概率为prob前进到它前面的位置
[L, W] = size(pixel); %get its dimensions
prob = 0.9;
temp_pixel = pixel;
global total_speed;
num_of_cars=0;
speed_max = 3;%最大速度
jam_cars= 0;
move_steps=0;
main_road_move_steps=0;
%if  ~isempty(find(pixel(:,W-1)==-3,1))%在这一步时,消除拐玩进入小区道路时占用的pixel(i,j)
    pixel(pixel(:,W-1)==-3,W-1) =0;
    pixel(pixel<=-4&pixel>=-10) = pixel(pixel<=-4&pixel>=-10)+1;
%end
move_steps=0;
%% 车辆前进的逻辑

for i = (L-1):-1:1
    for j =1: W-1
        if temp_pixel(i,j) == 1%主干路的移动情况
            if temp_pixel(i+1, j) ~= 0%堵车啦
                if temp_pixel(i, j-1)==0&&(temp_pixel(i+1, j)&temp_pixel(i+2, j)) ~= 0%当车的右侧有入口且前方阻塞时右拐入小区
                    pixel(i,j) = -8;%在此时步占用 pixel(i,j)，下一时步再将pixel(i,j)设为0，以此来表示进入口对道路通行的影响
                    pixel(i, j-1) = -8;
                end
                pixel_speed(i,j) = 0;
            elseif prob >= rand%向前移动                
                if i+pixel_speed(i,j)>L%越过边界时                    
                    next = find(temp_pixel(i+1:L,j),1);%判断下一次的加速移动是否会碰撞
                if ~isempty(next)&&next~=1%会碰到则按照N-S规则,移动至前车n后并速度降为Vn-1
                    total_speed=total_speed+(next-1);
                    move_steps=move_steps+(next-1);
                    next = next + i;
                    pixel(next-1,j) = 1;
                    %disp(next)
                    pixel(i,j)=1;%既占用小区路口又占用
                    pixel_speed(i,j)=0;
                    pixel_speed(next-1,j)=1;                    
                elseif isempty(next)
                    pixel(i,j)=0;
                    total_speed=total_speed+pixel_speed(i,j);
                    move_steps = move_steps+pixel_speed(i,j);
                end
                    break;
                end
                temp_pixel(temp_pixel==-2)=3;%将红绿灯转成正数方便判断
                next = find(temp_pixel(i+1:(i+pixel_speed(i,j)),j),1);%判断下一次的加速移动是否会碰撞
                if ~isempty(next)&&next~=1%会撞到前车到则按照NaSch规则,移动至前车n后并速度降为Vn-1
                    total_speed=total_speed+(next-1);
                    move_steps = move_steps+(next - 1);
                    next = next + i;                    
                    %disp(next)
                    pixel(i,j)=0;
                    pixel(next-1,j) = 1;
                    pixel_speed(i,j)=0;
                    pixel_speed(next-1,j)=1;                    
                elseif isempty(next)
                    pixel(i,j)=0;
                    pixel(i+pixel_speed(i,j), j) = 1;
                    total_speed=total_speed+pixel_speed(i,j);
                    move_steps = move_steps+pixel_speed(i,j);
                    if (pixel_speed(i,j)+1)>speed_max
                        pixel_speed(i+pixel_speed(i,j), j)=speed_max;
                    else
                        pixel_speed(i+pixel_speed(i,j), j)=pixel_speed(i,j)+1;
                    end                   
                end               
            end
            main_road_move_steps = move_steps;%主路的移动格数
        elseif pixel(i,j) == -3%小区内车辆的移动
                if (prob-0.3) >= rand&&pixel(i, j-1)==0&&j~=W-1;%184准则
                    %total_speed=total_speed+1;
                    move_steps = move_steps+1;                    
                    pixel(i,j) = 0;
                    pixel(i, j-1) = -3;
                end
        end
    end
end
%% 统计数据
for i=1:W
    for j=1:L
        if pixel(j,i)==1||pixel(j,i)==-3
            num_of_cars=num_of_cars+1;
            if pixel(j,i)==1&&pixel_speed(j,i)==0;
                jam_cars = jam_cars+1;
            end
        end
    end
end
if main_road_move_steps==0||sum(temp_pixel(:,W-1)==1)==0
    main_road_move_steps=0;
else
    main_road_move_steps = main_road_move_steps/sum(temp_pixel(:,W-1)==1);
end
if(main_road_move_steps ==0)
    %disp('1')
end
if    move_steps==0||sum(sum(temp_pixel==1))==0%防止NaN与Inf
    move_steps = 0;
else
    move_steps = move_steps/sum(sum(temp_pixel==1));
end
end