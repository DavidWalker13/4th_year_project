close all 


R1 = eye(3); %rotation matrix 1

for i=1:4917     
  % update matrix
  time_for_loop_s=looptime(i)*1E-6;
  delta_theta(1)=wxd(i)*time_for_loop_s;
  delta_theta(2)=wyd(i)*time_for_loop_s;
  delta_theta(3)=wzd(i)*time_for_loop_s;
  if isnan(delta_theta(1)) | isnan(delta_theta(2)) | isnan(delta_theta(3))
      fprintf('problem row %d', i);
      fprintf('\n');
      delta_theta=[0 0 0];
  end
  M = [ 1.0, -delta_theta(3), delta_theta(2);
    delta_theta(3), 1.0, -delta_theta(1);
    -delta_theta(2), delta_theta(1), 1.0 ]; 
   
  R2 = R1 * M;
  
  %Renormalization of R
  R1 = Normalize_M(R2);
  
    plot3([0,R1(1)],[0,R1(2)],[0,R1(3)]);
    title('3D');
    axis([-1.5 1.5 -1.5 1.5 -1.5 1.5]);
    hold on
    plot3([0,R1(4)],[0,R1(5)],[0,R1(6)],'r');
    plot3([0,R1(7)],[0,R1(8)],[0,R1(9)]);
    hold off
    pause(0.005)
    
end

R1
