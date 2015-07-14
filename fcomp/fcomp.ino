
//Libraries
#include <Wire.h> //The Wire library is used for I2C communication
#include <I2Cdev.h>
#include <MPU6050.h>

MPU6050 accelgyro;

int16_t ax, ay, az;
int16_t gx, gy, gz;
uint32_t time_for_loop; //time for a loop

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
  Serial.println(time_for_loop);

}
