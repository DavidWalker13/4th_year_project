
time_errors=0;
for i=1:length(looptime)
    if isnan(looptime(i)) ||looptime(i)> 2000000 || looptime(i) <2000
        looptime(i)=5000;
        time_errors=time_errors+1;
    end
end

time=cumsum(looptime);
time_s=time/1E6;

ay_errors=0;
for i=1:length(ay)
    if ay(i) > 200 || ay(i) < -200 ||isnan(ay(i)) 
        %ay(i)= 0;
        ay(i)=ay(i-1);
        ay_errors=ay_errors+1;
    end
end

ax_errors=0;
for i=1:length(ax)
    if ax(i) > 200 || ax(i) < -200 ||isnan(ax(i)) 
        %ax(i)= 0;
        ax(i)=ax(i-1);
        ax_errors=ax_errors+1;
    end
end

az_errors=0;
for i=1:length(az)
    if az(i) > 200 || az(i) < -200 ||isnan(az(i)) 
        %az(i)= 0;
        az(i)=az(i-1);
        az_errors=az_errors+1;
    end
end


pressure_errors=0;
for i=1:length(pressure)
    if pressure(i) > 1200 || pressure(i) < 500  ||isnan(pressure(i)) 
        %pressure(i)= 0;
        pressure(i)=pressure(i-1);
        pressure_errors=pressure_errors+1;
    end
end

T=20;
alt_const=287*(273+T)/9.8;
ground_pressure=mean(pressure(1:10))
alt=zeros(length(pressure),1);
alt2=zeros(length(pressure),1);
for i=1:length(pressure)
    alt(i)=2*alt_const*(ground_pressure-pressure(i))/(ground_pressure+pressure(i));
    alt2(i)=alt_const*(ground_pressure-pressure(i))/(ground_pressure);
end

wx_errors=0;
for i=1:length(wx)
    if all(isstrprop(wx{i}, 'xdigit')) == false
        %wx{i}=0;
        wx{i}=wx{i-1};
    end
    wxd(i)=decodehex(wx{i});
    if isnan(wxd(i)) 
        %wxd(i)= 0;
        wxd(i)= wxd(i-1);
        wx_errors=wx_errors+1;
    end
end
disp('finished wx');

wy_errors=0;
for i=1:length(wy)
   if all(isstrprop(wy{i}, 'xdigit')) == false
        %wy{i}=0;
        wy{i}=wy{i-1};
    end
    wyd(i)=decodehex(wy{i});
    if isnan(wyd(i)) 
        %wyd(i)= 0;
        wyd(i)= wyd(i-1);
        wy_errors=wy_errors+1;
    end
end
disp('finished wy');

wz_errors=0;
for i=1:length(wz)
    if all(isstrprop(wz{i}, 'xdigit')) == false
        %wz{i}=0;
        wz{i}=wz{i-1};
    end
    wzd(i)=decodehex(wz{i});
    if isnan(wzd(i)) 
        %wzd(i)= 0;
        wzd(i)= wzd(i-1);
        wz_errors=wz_errors+1;
    end
end

disp('finished wz');
