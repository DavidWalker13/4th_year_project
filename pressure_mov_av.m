MOV_AV_SIZE=1;
MOV_AV_Buffer=Pressure(1:MOV_AV_SIZE);
movavg_i=0;

P_avg=zeros(length(Pressure),1);

for i=2:length(Pressure)
    if Pressure(i) ~= Pressure(i-1)
        MOV_AV_Buffer(movavg_i+1)= Pressure(i);
        movavg_i=rem(movavg_i+1,MOV_AV_SIZE);
    end
    P_avg(i)=sum(MOV_AV_Buffer)/MOV_AV_SIZE;
end

% plot(Time,Pressure, 'r')
% hold on
% plot(Time,P_avg, 'g')
% hold off

dpdt=zeros(length(P_avg),1);
P_avg_prev=P_avg(2);
Time_prev=Time(1);
MOV_AV_SIZE=5;
MOV_AV_Buffer=zeros(1,MOV_AV_SIZE);

for i=3:length(P_avg)
    if P_avg(i) ~= P_avg(i-1)
        dpdt(i)=(P_avg(i)-P_avg_prev)/(Time(i)-Time_prev);
        P_avg_prev=P_avg(i);
        MOV_AV_Buffer(movavg_i+1)= dpdt(i);
        movavg_i=rem(movavg_i+1,MOV_AV_SIZE);
    else
        dpdt(i)=dpdt(i-1);
        
    end
    dpdt(i)=sum(MOV_AV_Buffer)/MOV_AV_SIZE;
end

%figure
plot(Time, dpdt,'r')
hold on