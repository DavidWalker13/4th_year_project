float R1[3][3] = { {1,0,0}, {0,1,0}, {0,0,1} }; ////rotation matrix 1
const float IdentityM[3][3] = { {1,0,0}, {0,1,0}, {0,0,1} }; //identity matrix
float R2[3][3]; //rotation matrix 2
float previous_pressure_reading=0, previous_pressure=0;
uint8_t loop_no=1;


void IMU() {
  read_sensors();
  scale_values();
  //update_matrix();
  if(launch_event==0 && launch_confirmed == false){
    //reset matrix and ground pressure
    //ground_pressure = pressure;
    //Matrix.Copy((float*) IdentityM, 3, 3, (float*) R1); 
  }
}

void read_sensors(){
  // read raw accel/gyro measurements from device
  accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
 // mag.getHeading(&mx, &my, &mz);  
  //get pressure 
  float pressure_reading = baro.getPressure(MS561101BA_OSR_4096);
  if(pressure_reading != previous_pressure_reading){
    pressure=0*pressure+1*pressure_reading; //low pass filter on pressure
    previous_pressure_reading=pressure_reading;
    vert_vel= 0.8*vert_vel + 0.2*alt_const*(previous_pressure-pressure)/(pressure*time_for_loop*loop_no*1E-6);
    previous_pressure=pressure;
    loop_no=1;
  }
  else loop_no++;

}
  
  
void scale_values(){

  w[0]= gxscale*(gx-gxoff);
  w[1]= gyscale*(gy-gyoff);
  w[2]= gzscale*(gz-gzoff);
  
  a[0]= axscale*(ax-axoff);
  a[1]= ayscale*(ay-ayoff);
  a[2]= azscale*(az-azoff);
  /*
  m[0]= mxscale*(mx-mxoff);
  m[1]= myscale*(my-myoff);
  m[2]= mzscale*(mz-mzoff);
  */
  altitude = alt_const*2*(ground_pressure-pressure)/(ground_pressure+pressure);
 
}

void update_matrix(){
  // update matrix
  float time_for_loop_s=time_for_loop*1E-6;
  float delta_theta[3];
  delta_theta[0]=w[0]*time_for_loop_s;
  delta_theta[1]=w[1]*time_for_loop_s;
  delta_theta[2]=w[2]*time_for_loop_s;
  
  float M[3][3] = {
    {1.0, -delta_theta[2], delta_theta[1]},
    {delta_theta[2], 1.0, -delta_theta[0]},
    {-delta_theta[1], delta_theta[0], 1.0}
  }; 
   
  Matrix.Multiply((float*)R1,(float*)M,3,3,3,(float*)R2); //R2 = R1 * M
  Matrix.Copy((float*) R2, 3, 3, (float*) R1); // R1 = R2
  //Renormalization of R
  Matrix.NormalizeTay3x3((float*)R1); //remove errors so dot product doesn't go complex
}

