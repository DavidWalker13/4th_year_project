close all

time_start=240;
time_end=310;
time_apogee=16;

%find indices
i_start=1;
while time_s(i_start)<time_start
    i_start=i_start+1;
end

i_end=i_start;
while time_s(i_end)<time_end
    i_end=i_end+1;
end

time_sP=time_s(i_start:i_end);
altP=alt(i_start:i_end);
wxdP=wxd(i_start:i_end);
wydP=wyd(i_start:i_end);
wzdP=wzd(i_start:i_end);

time_sP=time_sP-time_start;

plot(time_sP,altP)
xlabel('Time (s)')
ylabel('Altitude (m)')

figure
i_apogee=1;
while time_s(i_apogee)<time_apogee
    i_apogee=i_apogee+1;
end

plot(time_sP(1:i_apogee),rad2deg(wxdP(1:i_apogee)),time_sP(1:i_apogee),rad2deg(wzdP(1:i_apogee)),time_sP(1:i_apogee),rad2deg(wydP(1:i_apogee)))
xlabel('Time (s)')
ylabel(sprintf('Angular velocity (%c/s)', char(176)))
legend('Pitch','Yaw','Roll')