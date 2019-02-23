# Cellular-Automata-Traffic-Simulation
Research on The Impact of Road Traffic Around on Opening Residential Community Based on Cellular Automaton
基于元胞自动机的城市小区开放对周边道路通行的影响研究

本题为2016年高教杯数学建模大赛B题代码，获国家一等奖

编写环境:Matalab R2016a
已在Matalab R2014a中测试,可以正常运行.

程序主文件:main.m

功能:运行main.m 可以对其所指定参数的模型进行模拟仿真，以时步为单位显示车辆在地图中的运动过程,并统计数据与绘图。参数设置位置在程序中已给出。

参数：

* red_light_time = 60;%红灯时间

* green_light_time = 40;%绿灯时间

* fresh_frequency = 0.01;%刷新速率

* num_of_street = 3;%小区道路的数量,也就是交叉口的数量

* global pixellength;%定义全局变量车道长度

* pixellength = 30;%主道的长度

* side_length = 25;%小区边长

注意：主道长度不能小于小区边长！


比较不同小区的情况的文件：compare_diff_xiaoqu.m

功能：运行compare_diff_xiaoqu.m可以对其小区大小的数组进行设置，然后可以对每一种大小小区进行仿真及统计数据。最后每一种小区都会绘出其在设置不同数量的道路下的车辆平均速度与拥堵度。

参数：diff_xiaoqu_size不同小区的大小数组，默认为diff_xiaoqu_size=[25 50 70]。主路长度与小区边长的默认比值为1.4

运行main.m

不同的校区开放情况下产生的结果:

![](https://yanring-1252048839.cos.ap-guangzhou.myqcloud.com/img/2019-02-23-11.40.16.gif)


