previous_pressure=pressure(1);
loop_no=1;
vert_vel=zeros(length(pressure),1);
pressure2=pressure(1);
previous_pressure2=pressure2;

for i=2:length(pressure)
    if(pressure(i) ~= previous_pressure && pressure(i)>=100)
        pressure2=0.5*pressure2+0.5*pressure(i); %^low pass filter on pressure
        vert_vel(i)= 0.8*vert_vel(i-1) + 0.2*alt_const*(previous_pressure2-pressure2)/(pressure2*looptime(i)*loop_no*1E-6);
        if abs(vert_vel(i)) >1000
            disp(i);
            vert_vel(i)=vert_vel(i-1);
        end
        previous_pressure=pressure(i);
        previous_pressure2=pressure2;
        loop_no=1;  
    else
        vert_vel(i)=vert_vel(i-1);
        loop_no=loop_no+1;
    end
end

plot(time,vert_vel)

        