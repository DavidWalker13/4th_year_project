function [ Mnorm ] = Normalize_M( Min )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    xy_error=dot(Min(:,1),Min(:,2)); %compute error in X Y
    
    Min(:,1)=Min(:,1) -0.5*xy_error*Min(:,2); %assign half of error to X and half to Y
    Min(:,2)=Min(:,2) -0.5*xy_error*Min(:,1);

	Min(:,3)=cross(Min(:,1),Min(:,2));
	%make magnitudes equal to one, as the difference will be small can use
	%taylor expansion to avoid square root
    Mnorm=zeros(3);
	Mnorm(:,1) = 0.5*(3 - dot(Min(:,1),Min(:,1)))*Min(:,1);
    Mnorm(:,2) = 0.5*(3 - dot(Min(:,2),Min(:,2)))*Min(:,2);
    Mnorm(:,3) = 0.5*(3 - dot(Min(:,3),Min(:,3)))*Min(:,3);

end

