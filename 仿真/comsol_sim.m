% 参数设置
Lx = 100;               % 水面长度（x方向）
Ly = 100;               % 水面长度（y方向）
Nx = 100;               % x方向网格数
Ny = 100;               % y方向网格数
dx = Lx / Nx;          % x方向网格间距
dy = Ly / Ny;          % y方向网格间距
dt = 0.1;              % 时间步长
Tmax = 100;             % 最大仿真时间
g = 9.81;              % 重力加速度

% 网格生成
x = (0:Nx-1) * dx;
y = (0:Ny-1) * dy;
[X, Y] = meshgrid(x, y);

% 初始条件
Z = zeros(Nx, Ny);     % 水面初始高度
Z(Nx/2, Ny/2) = 10;     % 设置中心点扰动

% 绘制初始状态
figure;
surf(X, Y, Z);
title('初始水面状态');
xlabel('x');
ylabel('y');
zlabel('水面高度');
shading interp;
colorbar;
pause(1);

% 时间循环
for t = 1:Tmax
    % 计算水面高度的二阶差分
    Zx = circshift(Z, [1, 0]) - circshift(Z, [-1, 0]);
    Zy = circshift(Z, [0, 1]) - circshift(Z, [0, -1]);
    Zxx = (circshift(Z, [1, 0]) - 2*Z + circshift(Z, [-1, 0])) / dx^2;
    Zyy = (circshift(Z, [0, 1]) - 2*Z + circshift(Z, [0, -1])) / dy^2;
    
    % 更新水面高度
    Z = Z + dt^2 * g * (Zxx + Zyy);
    
    % 绘制当前状态
    surf(X, Y, Z);
    title(['水面波传播 - 时间: ', num2str(t*dt), ' 秒']);
    xlabel('x');
    ylabel('y');
    zlabel('水面高度');
    shading interp;
    colorbar;
    pause(0.1);
end
