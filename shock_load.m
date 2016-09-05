%this script models two masses (m1&m2) moving apart at two velocities
%(v1&v2) connected by an elastic string of stiffness (k) and length (l)

%all values in SI units
m1=1;
m2=2;
v1=12.0;
v2=6.0;
d=5E-3; %rope diameter
%to find stiffness take elongation at break data
Ed=(80*9.8/(0.0105^2*0.25*pi))/0.085; %dynamic climbing rope
En=1.18E8/(0.25*pi); %nylon rope
Ek=(0.3*5000*9.8/(0.008^2*0.25*pi))/0.025; %dynema
l=3;%rope length
k=En*(0.25*pi*d^2)/l; %select appropriate youngs modulus 

N=100;%number of steps in iteration
T_end=0.2; %end time
T=linspace(0,T_end,N); %time data
%build arrays
Delta=zeros(N,1);
F=zeros(N,1);
V=zeros(N,2);
A=zeros(N,2);

%set initial values
Delta(1)=0;
F(1)=0;
V(1,1)=v1;
V(1,2)=v2;
A(1,1)=0;
A(1,2)=0;

%loop
for i=2:N
    dt=T(i)-T(i-1);
    delta_dot=V(i-1,1)+V(i-1,2);
    Delta(i)=Delta(i-1)+delta_dot*dt;
    F(i)=k*Delta(i);
    A(i,1)=F(i)/m1;
    A(i,2)=F(i)/m2;
    V(i,1)=V(i-1,1)-dt*A(i,1);
    V(i,2)=V(i-1,2)-dt*A(i,2);
    if F(i)<0
        break
    end
end

plot(T,F)
xlabel('Time (s)')
ylabel('Force (N)')


