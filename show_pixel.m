function h = show_pixel(pixel, B, h)
%用图像显示元胞空间
[L, W] = size(pixel); %获取车道长度，车道数
temp = pixel;
temp(temp==1) = 0;%一开始先把车道中的车清空

PLAZA(:,:,1) = pixel;
PLAZA(:,:,2) = pixel;
PLAZA(:,:,3) = pixel;

PLAZA(PLAZA==0)=1;
if pixel(end,end-1) == -2;
    PLAZA(end,end-1,1) =1;
    PLAZA(end,end-1,2) =0;
    PLAZA(end,end-1,3) =0;
end
for j=1:W
    for i=1:L
        if pixel(i,j) <= -3&&pixel(i,j) >= -10
            PLAZA(i,j,1) =0;
            PLAZA(i,j,2) =1;
            PLAZA(i,j,3) =0;
        elseif pixel(i,j) == 1
            PLAZA(i,j,1) =0.1289;
            PLAZA(i,j,2) =0.3867;
            PLAZA(i,j,3) =1;
        elseif pixel(i,j) <-100
            PLAZA(i,j,1) =0.45;
            PLAZA(i,j,2) =0.45;
            PLAZA(i,j,3) =0.45;
        end
    end
end
% for i = (L+1)/2
%     for j = ceil(W/2)-ceil(B/2)+2:ceil(W/2)+floor(B/2)
%         if pixel(i,j) == 0;
%             PLAZA(i,j,1) =0;
%             PLAZA(i,j,2) =1;
%             PLAZA(i,j,3) =0;
%         else
%             PLAZA(i,j,1) =1;
%             PLAZA(i,j,2) =0;
%             PLAZA(i,j,3) =0;
%         end
%     end
% end

if ishandle(h)
    set(h,'CData',PLAZA)
else
    figure('position',[20,100,1200,600])
    h = imagesc(PLAZA);    
    hold on
    plot([[0:W]',[0:W]']+0.5,[0,L]+0.5,'k')%画纵线
    plot([0,W]+0.5,[[0:L]',[0:L]']+0.5,'k')%画横线
    axis image
    set(gca,'xtick',[]);%去掉下面x轴的标签
    set(gca,'ytick',[]);%去掉左边y轴的标签
end