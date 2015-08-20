/**
Visualize a cube which will assumes the orientation described
in a matrix coming from the serial port.

INSTRUCTIONS: 
This program has to be run when you have the FreeIMU_serial
program running on your Arduino and the Arduino connected to your PC.
Remember to set the serialPort variable below to point to the name the
Arduino serial port has in your system. You can get the port using the
Arduino IDE from Tools->Serial Port: the selected entry is what you have
to use as serialPort variable.


Copyright (C) 2011-2012 Fabio Varesano - http://www.varesano.net/

This program is free software: you can redistribute it and/or modify
it under the terms of the version 3 GNU General Public License as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

import processing.serial.*;
import processing.opengl.*;

Serial myPort;  // Create object from Serial class

final String serialPort = "COM7"; // replace this with your serial port. On windows you will need something like "COM1".

float [] M = new float [9];
float [] hq = null;
float [] qin = new float [4]; //
float [] q = new float [4]; //

int lf = 10; // 10 is '\n' in ASCII
byte[] inBuffer = new byte[22]; // this is the number of chars on each line from the Arduino (including /r/n)

PFont font;
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;

boolean start = false;
String loop_time;
int divider=0;


void myDelay(int time) {
  try {
    Thread.sleep(time);
  } catch (InterruptedException e) { }
}

void setup() 
{
  size(VIEW_SIZE_X, VIEW_SIZE_Y, OPENGL); //processing 2
  //size(800, 600, P3D);

  myPort = new Serial(this, serialPort, 115200);
  
  // The font must be located in the sketch's "data" directory to load successfully
  font = loadFont("CourierNew36.vlw"); 
  
  println("Waiting IMU..");
  
  myPort.clear();
  
  while (myPort.available() == 0) {
    myDelay(1000);
  }

  //myPort.write("q");
  myPort.bufferUntil('\n');
  start=true;
}


float decodeFloat(String inString) {
  byte [] inData = new byte[4];
  
  if(inString.length() == 8) {
    inData[0] = (byte) unhex(inString.substring(0, 2));
    inData[1] = (byte) unhex(inString.substring(2, 4));
    inData[2] = (byte) unhex(inString.substring(4, 6));
    inData[3] = (byte) unhex(inString.substring(6, 8));
  }
      
  int intbits = (inData[3] << 24) | ((inData[2] & 0xff) << 16) | ((inData[1] & 0xff) << 8) | (inData[0] & 0xff);
  return Float.intBitsToFloat(intbits);
}

void serialEvent(Serial p) {
  if (start == true){
    if(p.available() >= 10) {
      String inputString = p.readStringUntil('\n');
      //print(inputString);
      if (inputString != null && inputString.length() > 0) {
        String [] inputStringArr = split(inputString, ",");
        if(inputStringArr.length >= 5) { // q1,q2,q3,q4,\r\n so we have 5 elements
          qin[0] = decodeFloat(inputStringArr[0]);
          qin[1] = decodeFloat(inputStringArr[1]);
          qin[2] = decodeFloat(inputStringArr[2]);
          qin[3] = decodeFloat(inputStringArr[3]);
          loop_time = inputStringArr[4];
          
        }
      }
      // ask more data when burst completed
       // p.write("q");         
    }
  }
  divider++;
}

void draworigin(int cx, int cy, int cz, int len){
  pushMatrix();
  translate(cx, cy, cz);
  textSize(8);
  //x axis
  stroke(255,0,0); 
  line(0,0,0, len, 0, 0);
  line(len, 0,0, len - 8, -8,0);
  line(len, 0,0, len - 8, 8,0);
  fill(255,0,0);
  text('X', len+8, 0, 0);
  
  //yaxis
  stroke(0,255,0);
  line(0,0,0, 0, len, 0);
  line(0, len,0,  - 8, len -8,0);
  line(0, len,0,  + 8, len -8,0);
  fill(0,255,0);
  text('Y', 0, len+8, 0);

  //zaxis
  stroke(0,0,255);
  line(0,0,0, 0, 0, len);
  line(0, 0, len,  - 8, 0, len-8);
  line(0, 0, len,   8, 0, len-8);
  fill(0,0,255);
  text('Z', 0, 0, len+8);

  popMatrix();
}


void drawCube() {  
  pushMatrix();
    translate(VIEW_SIZE_X/2, VIEW_SIZE_Y/2 + 50, 0);
    scale(5,5,5);
    
    // a demonstration of the following is at 
    // http://www.varesano.net/blog/fabio/ahrs-sensor-fusion-orientation-filter-3d-graphical-rotating-cube
    //convert quaternion to axis angle rotation
    //q=[w, x, y, z] = [cos(a/2), sin(a/2) * nx, sin(a/2)* ny, sin(a/2) * nz]
    float a, nx, ny, nz;
    a=2*acos(q[0]);
    nx=q[1]/sin(a*0.5);
    ny=q[2]/sin(a*0.5);
    nz=q[3]/sin(a*0.5);
    rotate(a,nx,ny,nz);
    
    draworigin(0,0,0, 20);
    
  popMatrix();
}


void draw() {
  if (divider>5){
    divider=0;
    //print("drawing");
    background(#000000);
    fill(#ffffff);
    textSize(20);
    
    if(hq != null) { // use home quaternion
      q=quatProd(hq, qin);
      text("Disable home position by pressing \"n\"", 20, VIEW_SIZE_Y - 30);
    }
    else {
      q=qin;
      text("Point FreeIMU's X axis to your monitor then press \"h\"", 20, VIEW_SIZE_Y - 30);
    }
    
    
    textFont(font, 20);
    textAlign(LEFT, TOP);
    
    //text("M:\n" + M[0] + " " + M[1] + " " + M[2] + "\n" + M[3] + " " + M[4] + " " + M[5] + "\n" + M[6] + " " + M[7] + " " + M[8], 20, 20);
    text("Quaternion:\nqw  : " + qin[0] + "\nqx : " + qin[1] + "\nqy  : " + qin[2]+ "\nqz  : " + qin[3], 500, 20);
    text("Loop time: " + loop_time, 20, VIEW_SIZE_Y - 60);  
    
    drawCube();
  }
}

void MToquat(float [] m, float [] q){
  float tr = m[0] + m[4] + m[8];
  float S;
  if (tr > 0) { 
    S = sqrt(tr+1.0) * 2; // S=4*qw 
    q[0] = 0.25 * S;
    q[1] = (m[7] - m[5]) / S;
    q[2] = (m[2] - m[6]) / S; 
    q[3] = (m[3] - m[1]) / S; 
  } else if ((m[0] > m[4])&&(m[0] > m[8])) { 
    S = sqrt(1.0 + m[0] - m[4] - m[8]) * 2; // S=4*qx 
    q[0] = (m[7] - m[5]) / S;
    q[1] = 0.25 * S;
    q[2] = (m[1] + m[3]) / S; 
    q[3] = (m[2] + m[6]) / S; 
  } else if (m[4] > m[8]) { 
    S = sqrt(1.0 + m[4] - m[0] - m[8]) * 2; // S=4*qy
    q[0] = (m[2] - m[6]) / S;
    q[1] = (m[1] + m[3]) / S; 
    q[2] = 0.25 * S;
    q[3] = (m[5] + m[7]) / S; 
  } else { 
    S = sqrt(1.0 + m[8] - m[0] - m[4]) * 2; // S=4*qz
    q[0] = (m[3] - m[1]) / S;
    q[1] = (m[2] + m[6]) / S;
    q[2] = (m[5] + m[7]) / S;
    q[3] = 0.25 * S;
  }
}


void keyPressed() {
  if(key == 'h') {
    println("pressed h");
    
    // set hq the home quaternion as the quatnion conjugate coming from the sensor fusion
    hq = quatConjugate(q);
    
  }
  else if(key == 'n') {
    println("pressed n");
    hq = null;
  }
}



float [] MProd(float [] A, float [] B) {
  float [] M = new float[9];
  int m=3, p=3, n=3;  
  int i, j, k;
      for (i=0;i<m;i++)
          for(j=0;j<n;j++)
          {
              M[n*i+j]=0;
              for (k=0;k<p;k++)
                  M[n*i+j]= M[n*i+j]+A[p*i+k]*B[n*k+j];
          }
  
  return M;
}


// return the transpose of a matrix
float [] Mtran(float [] M) {
  float [] tran = new float[9];
  int m=3, n=3;
  int i, j;
    for (i=0;i<m;i++)
        for(j=0;j<n;j++)
            tran[m*j+i]=M[n*i+j];
  
  return tran;
}

float [] quatProd(float [] a, float [] b) {
  float [] q = new float[4];
  
  q[0] = a[0] * b[0] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3];
  q[1] = a[0] * b[1] + a[1] * b[0] + a[2] * b[3] - a[3] * b[2];
  q[2] = a[0] * b[2] - a[1] * b[3] + a[2] * b[0] + a[3] * b[1];
  q[3] = a[0] * b[3] + a[1] * b[2] - a[2] * b[1] + a[3] * b[0];
  
  return q;
}

// return the quaternion conjugate of quat
float [] quatConjugate(float [] quat) {
  float [] conj = new float[4];
  
  conj[0] = quat[0];
  conj[1] = -quat[1];
  conj[2] = -quat[2];
  conj[3] = -quat[3];
  
  return conj;
}
