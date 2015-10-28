MOV_AV_SIZE=5;
MOV_AV_Buffer=Pressure(1:MOV_AV_SIZE);
movavg_i=0;

P_avg=zeros(1,length(Pressure));

for i=2:length(Pressure)
    if Pressure(i) ~= Pressure(i-1)
        MOV_AV_Buffer(movavg_i+1)= Pressure(i);
        movavg_i=rem(movavg_i+1,MOV_AV_SIZE);
    end
    P_avg(i)=sum(MOV_AV_Buffer)/MOV_AV_SIZE;
end

plot(Time,Pressure, 'r')
hold on
plot(Time,P_avg, 'g')
hold off

dpdt=zeros(1,length(P_avg));
P_avg_prev=P_avg(2);
Time_prev=Time(1);

for i=3:length(P_avg)
    if P_avg(i) ~= P_avg(i-1)
        dpdt(i)=(P_avg(i)-P_avg_prev)/(Time(i)-Time_prev);
    else
        dpdt(i)=dpdt(i-1);
    end
end

figure
plot(Time, dpdt)