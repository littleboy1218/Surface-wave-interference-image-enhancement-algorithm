%波的干涉 
clc
clear all
f=10;%波源频率(两波同频)
A=2;%幅值

x=-5:0.01:5;
y=-5:0.01:5;
L_x=length(x);
z=zeros(1,L_x);

[X1,Y1,Z1]=griddata(x,y,z,linspace(min(x),max(x),150)',...
    linspace(min(y),max(y),150),'cubic');%插值
[X2,Y2,Z2]=griddata(x,y,z,linspace(min(x),max(x),150)',...
    linspace(min(y),max(y),150),'cubic');%插值
[X3,Y3,Z3]=griddata(x,y,z,linspace(min(x),max(x),150)',...
    linspace(min(y),max(y),150),'cubic');%插值
[X4,Y4,Z4]=griddata(x,y,z,linspace(min(x),max(x),150)',...
    linspace(min(y),max(y),150),'cubic');%插值

N=length(X1);

for i=1:N
    for j=1:N
        r1=sqrt((X1(i,j)+3)^2+Y1(i,j)^2);
        r2=sqrt((X2(i,j)+1)^2+Y2(i,j)^2);
        r3=sqrt((X3(i,j)-2)^2+Y3(i,j)^2);
        Z1(i,j)=A*sin(r1*f);
        Z2(i,j)=A*sin(r2*f);
        Z3(i,j)=A*sin(r3*f);
        Z4(i,j)=Z1(i,j)+Z2(i,j)+Z3(i,j);
    end
end

figure
surf(X1,Y1,Z1);%三维曲面1
hold on;
surf(X2,Y2,Z2);
hold on;
surf(X3,Y3,Z3);
colorbar('vert')
view(-8,87)

figure
surf(X4,Y4,Z4);%三维曲面
colorbar('vert')
view(-8,87)

figure
contourf(X4,Y4,Z4),shading interp;
colorbar('vert')
