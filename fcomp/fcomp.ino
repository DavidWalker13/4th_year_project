
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
#define MOVAVG_SIZE 32

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
uint32_t time_for_loop=0; //time for a loop

//Baro stuff
float movavg_buff[MOVAVG_SIZE];
int movavg_i=0;

const float sea_press = 1013.25;
float pressure, temp, altitude, ground_pressure, alt_const;

void setup() {
  // put your setup code here, to run once:
  initialize();

}

void loop() {
  uint32_t loop_start = micros();
  // put your main code here, to run repeatedly:
  IMU();
  data_out();
  time_for_loop = micros()-loop_start;
}
