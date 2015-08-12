clear all
close all
delete(instrfind);
arduino = serial('COM7');
arduino.BaudRate=115200;
set(arduino, 'terminator', 'LF');    % define the terminator for println
fopen(arduino)

DlgH = figure;
H = uicontrol('Style', 'PushButton', ...
                    'String', 'Break', ...
                    'Callback', 'delete(gcbf)');
 
pause(1)
fscanf(arduino, '%s')
fscanf(arduino, '%s')
fscanf(arduino, '%s')
fscanf(arduino, '%s')

divider=10;
i=0;
tsum=0;

M=zeros(9,1);

while (ishandle(H))
   %fprintf(arduino, 'q') 
   pause(0.003)
   count=fscanf(arduino, '%d');
   for j=1:9
     M(j)=fscanf(arduino, '%f');
   end
   M
  % M=str2double(strsplit(M,','));
  % pause(0.0005)
   t=fscanf(arduino, '%d');
   tsum=tsum+t;
  % pause(0.0005)
  i=i+1;
  if i>=divider
    i=0;
    tavg=tsum/divider
    tsum=0;
    plot3([0,M(1)],[0,M(2)],[0,M(3)]);
    title('3D');
    axis([-2 2 -2 2 -2 2]);
    hold on
    plot3([0,M(4)],[0,M(5)],[0,M(6)]);
    plot3([0,M(7)],[0,M(8)],[0,M(9)]);
    hold off
  end
  
end

fclose(arduino)

