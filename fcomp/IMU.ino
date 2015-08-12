float R1[3][3] = { {1,0,0}, {0,1,0}, {0,0,1} }; ////rotation matrix 1
float R2[3][3]; //rotation matrix 2


void IMU() {
  read_sensors();
  scale_values();
  
   // update matrix
  float time_for_loop_s=time_for_loop*1E-6;
  float M[3][3] = {
    {1.0, -w[2]*time_for_loop_s, w[1]*time_for_loop_s},
    {w[2]*time_for_loop_s, 1.0, -w[0]*time_for_loop_s},
    {-w[1]*time_for_loop_s, w[0]*time_for_loop_s, 1.0}
  }; 
   
  Matrix.Multiply((float*)R1,(float*)M,3,3,3,(float*)R2); //R2 = R1 * M
  Matrix.Copy((float*) R2, 3, 3, (float*) R1); // R1 = R2
  //Renormalization of R
  Matrix.NormalizeTay3x3((float*)R1); //remove errors so dot product doesn't go complex
}

float getAltitude(float press, float temp) {
  //return (1.0f - pow(press/101325.0f, 0.190295f)) * 4433000.0f;
  return ((pow((sea_press / press), 1/5.257) - 1.0) * (temp + 273.15)) / 0.0065;
}

void read_sensors(){
  // read raw accel/gyro measurements from device
  accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
 /* mag.getHeading(&mx, &my, &mz);  
  //get altitude
  float temperature = baro.getTemperature(MS561101BA_OSR_4096);
  if(temperature) {
    temp = temperature;
  }
  
  press = baro.getPressure(MS561101BA_OSR_4096);
  if(press!=NULL) {
    pushAvg(press);
  }*/
}
  
  
void scale_values(){

  w[0]= gxscale*(gx-gxoff);
  w[1]= gyscale*(gy-gyoff);
  w[2]= gzscale*(gz-gzoff);
  /*
  a[0]= axscale*(ax-axoff);
  a[1]= ayscale*(ay-ayoff);
  a[2]= azscale*(az-azoff);
  
  m[0]= mxscale*(mx-mxoff);
  m[1]= myscale*(my-myoff);
  m[2]= mzscale*(mz-mzoff);
  
  press = getAvg(movavg_buff, MOVAVG_SIZE);
  altitude = getAltitude(press, temp);*/
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
