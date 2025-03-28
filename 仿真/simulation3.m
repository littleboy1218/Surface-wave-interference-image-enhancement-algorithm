% 水槽波动仿真完整代码（干涉+衍射）
clear all; close all; clc;

% ================= 参数设置 =================
c = 0.313;          % 波速(m/s)，根据波长3.1~31.3mm和频率10~100Hz换算
f = 50;             % 振子频率(Hz)
A = 0.5e-3;         % 振幅(m)
Lx = 0.4; Ly = 0.3; % 水槽尺寸(m) 400mm×300mm
Nx = 800; Ny = 600; % 网格数（1mm/格）
dx = Lx/Nx; dy = Ly/Ny;
dt = 0.8*dx/(c*sqrt(2)); % 时间步长(满足CFL条件)

% ================= 初始化波场 =================
u_prev = zeros(Nx, Ny);  % 前一时刻波场
u_current = zeros(Nx, Ny); % 当前时刻波场
u_next = zeros(Nx, Ny);  % 下一时刻波场

% ================= 振子设置（左侧线源） =================
source_x = 5; % 振子位置（左起第5格，避免边界干扰）
source_phase = 0; % 初始相位

% ================= 消波边界（PML层） =================
pml_thickness = 20; % PML层厚度(格)
damping = zeros(Nx, Ny); 
% 右侧PML（对应亚克力板对侧）
for i = 1:Nx
    if i > Nx - pml_thickness
        damping(i,:) = 0.15*(i - (Nx - pml_thickness)).^2;
    end
end

% ================= 障碍物设置（亚克力板） =================
obstacle = zeros(Nx, Ny);
% 亚克力板位置（右侧中央开双缝）
obstacle_x = round(0.3*Nx); % 板位置(距振子侧70%位置)
slit_width = 5; % 缝宽(mm)
slit_spacing = 10; % 缝间距(mm)
obstacle(obstacle_x, :) = 1; % 板主体
% 开双缝（中央区域）
center_y = Ny/2;
obstacle(obstacle_x, center_y-slit_spacing/2-slit_width:center_y-slit_spacing/2) = 0;
obstacle(obstacle_x, center_y+slit_spacing/2:center_y+slit_spacing/2+slit_width) = 0;

% ================= 时域迭代 =================
figure;
for n = 1:2000
    % 更新振子驱动（左侧线源）
    t = n*dt;
    u_current(source_x, 2:end-1) = A*sin(2*pi*f*t + source_phase);
    
    % 波动方程更新（二维显式差分）
    u_next(2:end-1, 2:end-1) = 2*u_current(2:end-1, 2:end-1) - u_prev(2:end-1, 2:end-1) + ...
        (c^2 * dt^2 / dx^2) * (u_current(3:end, 2:end-1) - 2*u_current(2:end-1, 2:end-1) + u_current(1:end-2, 2:end-1)) + ...
        (c^2 * dt^2 / dy^2) * (u_current(2:end-1, 3:end) - 2*u_current(2:end-1, 2:end-1) + u_current(2:end-1, 1:end-2));
    
    % 应用障碍物边界（亚克力板）
    u_next(obstacle == 1) = 0;
    
    % 应用PML吸收层（消波边界）
    u_next = u_next - damping.*(u_current - u_prev)*dt;
    
    % 状态更新
    u_prev = u_current;
    u_current = u_next;
    
    % 动态显示（每10步刷新）
    if mod(n,10) == 0
        imagesc(u_current'); 
        axis equal tight; 
        title(sprintf('t = %.2f s',t));
        caxis([-A A]); % 固定颜色范围
        drawnow;
    end
end