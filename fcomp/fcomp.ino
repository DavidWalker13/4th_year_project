
//Libraries
#include <Wire.h> //The Wire library is used for I2C communication
#include <MatrixMath.h>
#include <I2Cdev.h>
#include <MPU6050.h>
#include <HMC5883L.h>
#include <MS561101BA.h>

MPU6050 accelgyro;
HMC5883L mag;
MS561101BA baro;
#define Buzzer_Pin 11
#define Pyro_Pin 5

//Variables
float gxscale =3.1416/(180*32.8), gyscale = 3.1416/(180*32.8), gzscale = 3.1416/(180*32.8);
int16_t gxoff =0, gyoff = 0, gzoff = 0;
float axscale = 9.81/2048, ayscale = 9.81/2048, azscale = 9.81/2048;
int16_t axoff = 0, ayoff = 0, azoff = 0;
float mxscale = 1, myscale = 1, mzscale = 1;
int16_t mxoff = 0, myoff = 0, mzoff = 0;

int16_t ax, ay, az;
int16_t gx, gy, gz;
int16_t mx, my, mz;
float w[3];
float a[3];
float m[3];
uint32_t time_for_loop=5000; //time for a loop

//Baro stuff
float pressure=1000, ground_pressure, alt_const, vert_vel, altitude;

//events
bool launch_confirmed=0, apogee=0, main_deploy=0;
uint64_t launch_event = 0; //this is treated as an array of 16 bools
const uint16_t launch_detect_altitude = 50; // height gain required for a launch to be confirmed in meters
uint8_t event_freq_divider=0; // 

void setup() {
  // put your setup code here, to run once:
  initialize();

}

void loop() {
  // put your main code here, to run repeatedly:
  uint32_t loop_start = micros();


  IMU();
  //PID();
  data_out();
  
  if (event_freq_divider > 10){ // event dectection occurs at 200/10Hz
    event_detection();
    event_freq_divider=1;
  }
  else event_freq_divider++;   
  
  set_loop_time(5000,loop_start);
  time_for_loop = micros()-loop_start;
}

void set_loop_time(uint16_t time, uint32_t loop_start){
  while(micros()-loop_start < time){
    delayMicroseconds(1);
  }
}




