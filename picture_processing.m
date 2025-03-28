clc;
clear;
% 读取图像
I = imread('D:\水面波\picture\Image\1.png');

% 将图像转换为灰度图
I_gray = rgb2gray(I);

% 对图像进行直方图均衡化
I_eq = histeq(I_gray);

% --- 对均衡化后的图像进行高通滤波 ---
% 获取图像大小
[M, N] = size(I_eq);

% 对图像进行傅里叶变换
I_fft = fft2(I_eq);

% 移动零频率分量到频谱中心
I_fft_shifted = fftshift(I_fft);

% 构建理想高通滤波器
D0 = 8; % 设置截止频率
[x, y] = meshgrid(1:N, 1:M);
centerX = N / 2;
centerY = M / 2;
D = sqrt((x - centerX).^2 + (y - centerY).^2);
H = double(D > D0); % 高通滤波器

% 应用高通滤波器
I_filtered_fft = I_fft_shifted .* H;

% 将频谱移回
I_filtered_fft_shifted = ifftshift(I_filtered_fft);

% 对结果进行逆傅里叶变换，转换回空间域
I_filtered = real(ifft2(I_filtered_fft_shifted));

% --- 对高通滤波后的图像进行增强 ---
% % 1. 图像锐化
I_sharpened = imsharpen(I_filtered);
% 
% % 2. 对比度拉伸
I_contrast = imadjust(I_sharpened);

% 3. 直方图均衡化
I_enhanced = histeq(I_contrast);

% 显示处理结果
% figure;
subplot(1, 4, 1), imshow(I_gray), title('原始图像');
subplot(1, 4, 2), imshow(I_eq), title('直方图均衡化后的图像');
subplot(1, 4, 3), imshow(I_filtered, []), title('高通滤波后的图像');
% subplot(2, 2, 3), imshow(I_sharpened, []), title('锐化后的图像');
subplot(1, 4, 4), imshow(I_enhanced, []), title('增强后的图像');
%转化为二值图像
I_enhanced_1=imbinarize(I_enhanced);
% figure;
% subplot(1,4, 1),imshow(I_enhanced_1),title('二值图像');

%低通滤波去噪
sigma=5;%滤波器的标准差
parameters=double(3*sigma*2+1); % 模板尺寸
H=fspecial('gaussian', parameters, sigma);%滤波算子 %gaussian低通滤波器
I_enhanced_filtered=imfilter(I_enhanced_1,H,'replicate');
% subplot(1,4, 2),imshow(I_enhanced_filtered),title('去噪后图像'); 

%骨化
I_ossify=bwmorph(I_enhanced_filtered,'skel',18);
% subplot(1, 4, 3),imshow(I_ossify),title('骨化图像');

%去毛刺(消除噪声)
I_ossify_filter=bwmorph(I_ossify,'spur',25);
% subplot(1, 4, 4),imshow(I_ossify_filter),title('去毛刺');