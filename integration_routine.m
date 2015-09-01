close all 

R1 = eye(3); %rotation matrix 1

for i=1:length(looptime)

 % update matrix
  time_for_loop_s=looptime(i)*1E-6;
  delta_theta(1)=decodehex(wx{i})*time_for_loop_s;
  delta_theta(2)=decodehex(wy{i})*time_for_loop_s;
  delta_theta(3)=decodehex(wz{i})*time_for_loop_s;
  
  M = [ 1.0, -delta_theta(3), delta_theta(2);
    delta_theta(3), 1.0, -delta_theta(1);
    -delta_theta(2), delta_theta(1), 1.0 ]; 
   
  R2 = R1 * M;
  R1 = R2;
  %Renormalization of R
  
  
end

R1
