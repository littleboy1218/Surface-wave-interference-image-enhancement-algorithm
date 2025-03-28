clc;
close all;
clear all;
% 读取图像
I1 = imread('D:\水面波\条纹检测与智能测距\1.png');
I2=rgb2gray(I1);
% 显示图像
figure(1);
imshow(I2);
title('请在图像上用鼠标划线');

% % 等待用户用鼠标划线
% [x, y] = ginput(); % 用户交互获取点坐标
% hold on;
% plot(x, y, 'r', 'LineWidth', 2); % 绘制用户划线的路径

% 提取沿着路径的像素值

data1 = improfile;
data2 = transpose (data1);
data3=smoothdata(data2,'gaussian',10);
% 绘制提取的像素值
figure(2);
plot(data3, 'LineWidth', 1.5); % 设置线宽1.5
xlabel('距离', 'FontName', '楷体' , 'FontWeight', 'bold'); % 设置字体和加粗
ylabel('像素强度', 'FontName', '楷体', 'FontWeight', 'bold'); % 设置字体和加粗
title('双缝干涉强度分布', 'FontName', '楷体', 'FontWeight', 'bold'); % 设置字体和加粗
grid on;

% legend(, 'FontName', '楷体', 'FontWeight', 'bold', 'Box', 'off'); % 设置字体和加粗并去掉box
set(gca, 'FontName', '楷体', 'FontWeight', 'bold', 'LineWidth', 1); % 设置坐标轴字体和加粗及线宽

% 设置坐标轴线宽
ax = gca;
ax.LineWidth = 1;


N=size(data3,2);
M=zeros(N,N);
f=64;
for i=1:N
    for j=1:N
        M(i,j)=data2(j);
    end
end
% imshow(mat2gray(M));  
% h2=gcf ;
% saveas(h2, ['D:\A.matlab\work\yanshe\stripe\', '双缝（等缝宽）', '.jpg']);

% 读取图像
Img = mat2gray(M);
M = size(Img);
if numel(M)>2
    gray = rgb2gray(Img);
else
    gray = Img;
end
 
% 创建滤波器
W = fspecial('gaussian',[5,5],1); 
G = imfilter(gray, W, 'replicate');
figure(3);
imshow(G);    
title('三缝衍射条纹图');
