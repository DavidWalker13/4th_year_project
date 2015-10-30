previous_pressure=Pressure(1);
loop_no=1;
vert_vel=zeros(length(Pressure),1);
a=0.1;
beta=0.0;
b=0;
pressure_f=Pressure(1);
previous_pressure_f=pressure_f;
c=1;

for i=2:length(Pressure)
    if(Pressure(i) ~= previous_pressure && Pressure(i)>=100)
        pressure_f=(1-c)*previous_pressure_f+c*Pressure(i);
        vert_vel(i)= (1-a)*(vert_vel(i-1)+b) + a*(previous_pressure_f-pressure_f)*alt_const/(Pressure(i)*looptime(i)*loop_no*1E-6);
        b=beta*(vert_vel(i)-vert_vel(i-1))+(1-beta)*b;
        if abs(vert_vel(i)) >1000
            disp(i);
            vert_vel(i)=vert_vel(i-1);
        end
        previous_pressure=Pressure(i);
        previous_pressure_f=pressure_f;
        loop_no=1;  
    else
        vert_vel(i)=vert_vel(i-1);
        loop_no=loop_no+1;
    end
end

plot(Time,vert_vel,'b')
