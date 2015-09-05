function [ value ] = decodehex( inString )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
  
  if(length(inString) == 8) 
    inData1 = hex2dec(inString(1:2));
    inData2 = hex2dec(inString(3:4));
    inData3 = hex2dec(inString(5:6));
    inData4 = hex2dec(inString(7:8));
  
  
%   a= bitshift(inData4, 24);
%   b= bitshift(bitand(inData3, 255), 16);
%   c=bitshift(bitand(inData2, 255),8);
%   d=bitand(inData1,255);
%   e=bitor(bitor(bitor(a,b),c),d);
%   e=[a b c d];
      e=[inData1 inData2 inData3 inData4];
      e = uint8(e);
      value = typecast( e , 'single');
  else
      value = NaN;

end

