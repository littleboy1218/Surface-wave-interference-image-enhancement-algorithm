clc;
clear;
% 参数设置
c = 3.13; % 波速 (m/s)
f = 50; % 频率 (Hz)
A = 0.5e-3; % 振幅 (m)
Lx = 0.4; Ly = 0.3; % 水槽尺寸 (m)
Nx = 400; Ny = 300; % 网格数
dx = Lx/Nx; dy = Ly/Ny;
dt = 0.9*dx/(c*sqrt(2)); % 时间步长 (CFL条件)

% 初始化波场
u_prev = zeros(Nx, Ny);
u_current = zeros(Nx, Ny);
u_next = zeros(Nx, Ny);

% 振源位置（示例：双振源）
sources = [round(0.3*Nx), round(0.5*Ny); 
           round(0.7*Nx), round(0.5*Ny)];

% 障碍物（示例：双缝）
obstacle = zeros(Nx, Ny);
obstacle(round(0.4*Nx):round(0.6*Nx), :) = 1; % 墙壁
slit_width = 10; % 缝宽（像素）
obstacle(round(0.5*Nx-slit_width/2):round(0.5*Nx+slit_width/2), :) = 0; % 双缝

% 时间迭代
for n = 1:1000
    % 更新振源
    t = n*dt;
    for s = 1:size(sources, 1)
        u_current(sources(s,1), sources(s,2)) = A*sin(2*pi*f*t);
    end
    
    % 波动方程更新（忽略边界处理）
    u_next(2:end-1, 2:end-1) = 2*u_current(2:end-1, 2:end-1) - u_prev(2:end-1, 2:end-1) + ...
        (c^2 * dt^2 / dx^2) * (u_current(3:end, 2:end-1) - 2*u_current(2:end-1, 2:end-1) + u_current(1:end-2, 2:end-1)) + ...
        (c^2 * dt^2 / dy^2) * (u_current(2:end-1, 3:end) - 2*u_current(2:end-1, 2:end-1) + u_current(2:end-1, 1:end-2));
    
    % 应用障碍物边界条件
    u_next(obstacle == 1) = 0;
    
    % 更新状态
    u_prev = u_current;
    u_current = u_next;
    
    % 频闪采样与可视化
    if mod(n, round(1/(f*dt))) == 0
        imagesc(u_current); axis equal; drawnow;
    end
end