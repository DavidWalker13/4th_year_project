pressure2=pressure(99850:140771);
time2=time((99850:140771));

for i=2:length(pressure2)
    if pressure2(i)<200
        pressure2(i)=pressure2(i-1);
    end
end

plot(time2, pressure2)

TP=[time2,pressure2];