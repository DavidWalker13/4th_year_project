void IMU() {
  // read raw accel/gyro measurements from device
  accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  mag.getHeading(&mx, &my, &mz);
  
  //get altitude
  float temperature = baro.getTemperature(MS561101BA_OSR_4096);
  if(temperature) {
    temp = temperature;
  }
  
  press = baro.getPressure(MS561101BA_OSR_4096);
  if(press!=NULL) {
    pushAvg(press);
  }
  
  press = getAvg(movavg_buff, MOVAVG_SIZE);
  altitude = getAltitude(press, temp);
  
  a[0]= axscale*(ax-axoff);
  a[1]= ayscale*(ay-ayoff);
  a[2]= azscale*(az-azoff);
  
  w[0]= gxscale*(gx-gxoff);
  w[1]= gyscale*(gy-gyoff);
  w[2]= gzscale*(gz-gzoff);
}

float getAltitude(float press, float temp) {
  //return (1.0f - pow(press/101325.0f, 0.190295f)) * 4433000.0f;
  return ((pow((sea_press / press), 1/5.257) - 1.0) * (temp + 273.15)) / 0.0065;
}

void pushAvg(float val) {
  movavg_buff[movavg_i] = val;
  movavg_i = (movavg_i + 1) % MOVAVG_SIZE;
}

float getAvg(float * buff, int size) {
  float sum = 0.0;
  for(int i=0; i<size; i++) {
    sum += buff[i];
  }
  return sum / size;
}
