%% 全国大学生数学建模第三问比较不同小区比较的代码.
%每个格子的状态有三种：
%用1来表示正常前进车辆,-3表示拐入小区的车辆，0表示空位，-888表示不可进入区域

%% 初始化运行空间
clear all;
clc;
warning off;
dbstop if error
W = 0;
%% 主要参数
diff_xiaoqu_size=[25 50 70];%对应文献常规意义的最小小区,最优小区,最大小区
max_seperation_distance=25;%对应常规楼房的宽度,单比其稍宽.
one_step_distance = 6;%一格对应6m
red_light_time = 60;%红灯时间
green_light_time = 40;%绿灯时间
global pixellength;%定义全局变量车道长度

%% 用来统计数据的变量
global speed_index
speed_index=0;
loop_times = 10;%循环次数;
time_step_length = loop_times*(red_light_time+green_light_time)/2;
avr_move_steps = zeros(1,time_step_length);
store_num_of_cars = zeros(1,time_step_length);
store_num_of_jam_cars = zeros(1,time_step_length);
avr_mainroad_move_steps = zeros(1,time_step_length);
%% 生成运行改进后的N-S模型所需的变量.
for side_length=diff_xiaoqu_size
    pixellength = floor(side_length*1.6);
    data_index = 0;
    avr_mainroad_move_steps_arry=[];
    jam_percentage_arry=[];
    for num_of_street = [0:side_length*one_step_distance/max_seperation_distance]%从0条小区道路开始
        data_index = data_index+1;
        B = side_length+1;
        L = 1;     
        pixel = create_pixel(B,L,side_length);%生成元胞空间的状态矩阵
        pixel = create_street( pixel , num_of_street+1 ,side_length);%生成小区道路
        pixel_speed = zeros(size(pixel));%小车的速度矩阵,对应所在位置的小车的速度
        %temp_handle = show_pixel(pixel,B,NaN);%显示元胞矩阵
        speed_index=0;
         %% 循环刷新每一时步的图像,统计数据.
        for i = 1:loop_times
            waiting_time = 0;
            output = 0;
            entry = 0;
            traffic_capacity = 0;
            if mod(i,2)~=0
                pixel(end,end-1) = 0;%红灯变绿灯
                for xx=1:green_light_time            
                    [pixel,pixel_speed,move_step,num_of_cars,num_of_jam_cars,avr_mainroad_move_step] = go_forward(pixel,pixel_speed); %前进规则
                    [pixel,pixel_speed] = new_cars(pixel,1,pixel_speed); %将生成的车辆加到元胞空间矩阵中
                    entry = entry + 1;
                    %waiting_time = waiting_time + compute_wait(pixel); %进行求和求总的时间
                    %==============
                    %temp_handle = show_pixel(pixel,B,temp_handle);%刷新图像
                    %drawnow
                    %==============
                    pixel = clear_boundary(pixel);%将要离开系统的车辆，需要将车辆从系统中移除
                    %k = k+1;
                    %pause(fresh_frequency);
                    speed_index=speed_index+1;
                    %disp(speed_index)
                    avr_move_steps(speed_index)=move_step;
                    store_num_of_cars(speed_index) = num_of_cars;
                    store_num_of_jam_cars(speed_index)=num_of_jam_cars;
                    avr_mainroad_move_steps(speed_index)=avr_mainroad_move_step;
                end
            else
                pixel = red_light_on(pixel);%绿灯变红灯
                for xx=1:red_light_time

                    [pixel,pixel_speed,move_step,num_of_cars,num_of_jam_cars,avr_mainroad_move_step] = go_forward(pixel,pixel_speed); %前进规则

                    [pixel,pixel_speed] = new_cars(pixel,1,pixel_speed); %将生成的车辆加到元胞空间矩阵中
                    %temp_handle = show_pixel(pixel,B,temp_handle);%更新图像
                    %drawnow
                    %pause(fresh_frequency);
                    pixel = clear_boundary(pixel);
                    speed_index=speed_index+1;
                    avr_move_steps(speed_index)=move_step;
                    store_num_of_cars(speed_index) = num_of_cars;
                    store_num_of_jam_cars(speed_index)=num_of_jam_cars;
                    avr_mainroad_move_steps(speed_index)=avr_mainroad_move_step;
                end
            end               
        end

        %% 绘图与统计
        hold off;
        time_series = linspace(1,time_step_length,time_step_length);
        fprintf('小区边长：%i\n',side_length);
        fprintf('主路长度：%i\n',pixellength);
        fprintf('小区道路数：%i\n',num_of_street);
        fprintf('一个红绿灯周期内的一辆车的平均车速为：%f 格每时步\n',mean(avr_move_steps(end-(red_light_time+green_light_time):end)));
        fprintf('一个红绿灯周期内的一辆在主道上的车的平均车速为：%f 格每时步\n',mean(avr_mainroad_move_steps(end-(red_light_time+green_light_time):end)));
        fprintf('稳定的位于地图内的车辆数量为：%f \n',floor(mean(store_num_of_cars(end-30:end))));
        fprintf('稳定的位于地图内被阻塞的车辆为：%f \n',floor(mean(store_num_of_jam_cars(end-30:end))));
        fprintf('稳定的路网拥堵度为：%f \n',mean(store_num_of_jam_cars(end-30:end))/pixellength);
        avr_mainroad_move_steps_arry(data_index)=mean(avr_mainroad_move_steps(end-(red_light_time+green_light_time):end));
        jam_percentage_arry(data_index)=mean(store_num_of_jam_cars(end-30:end))/pixellength;
    end
    %figure(side_length);
    subplot(2,1,1)
    hold on
    xdata = [0:length(avr_mainroad_move_steps_arry)-1];
    plot(xdata,avr_mainroad_move_steps_arry.*(3600*6/1000))%换算为千米
    %bar(xdata,avr_mainroad_move_steps_arry.*(3600*6/1000))%换算为千米
    %avr_mainroad_move_steps_arry.*(3600*6/1000)
    %title(['图1:小区边长为',num2str(side_length),'的主道平均车速 km / h'])
    xlabel('开放小区交叉口数量')
    ylabel('车速')
    subplot(2,1,2)
    hold on
    plot(xdata,jam_percentage_arry)
    %bar(xdata,jam_percentage_arry)
    %title(['图2:小区边长为',num2str(side_length),'的路网拥堵度'])
    xlabel('开放小区交叉口数量')
    ylabel('阻塞率')
    %jam_percentage_arry
end