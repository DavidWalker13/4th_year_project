
void data_out(){ 
 //print_accel();
 //print_gyro();
 //print_mag();
 //print_baro();
 float quat[4];
 MToquat((float*) R1, quat);
 serialcubeout(quat, 4);
 Serial.print(time_for_loop);
 Serial.println("");
}

void print_accel(){
  //Serial.print("a:\t");
  Serial.print(a[0]); Serial.print(",");
  Serial.print(a[1]); Serial.print(",");
  Serial.print(a[2]); Serial.print(",");
}

void print_gyro(){
    for(int i=0; i<3; i++){
    serialFloatPrint(w[i]);
    Serial.print(",");
  }
}

void print_mag(){
  Serial.print("mag:\t");
  Serial.print(mx); Serial.print("\t");
  Serial.print(my); Serial.print("\t");
  Serial.println(mz); 
}

void print_baro(){
  //Serial.print("baro:\t");
  //Serial.print(temp); Serial.print("\t");
  Serial.print(pressure); Serial.print("\t");
  //Serial.print(altitude); Serial.print("\t");
}

void serialcubeout(float* M, int length){
  //function to send data to cube visualization
  for(int i=0; i<length; i++){
    serialFloatPrint(M[i]);
    Serial.print(",");
  }
}

void serialFloatPrint(float f) {
  //function to print floats in hex, used by serialcubeout
  byte * b = (byte *) &f;
  for(int i=0; i<4; i++) {
    
    byte b1 = (b[i] >> 4) & 0x0f;
    byte b2 = (b[i] & 0x0f);
    
    char c1 = (b1 < 10) ? ('0' + b1) : 'A' + b1 - 10;
    char c2 = (b2 < 10) ? ('0' + b2) : 'A' + b2 - 10;
    
    Serial.print(c1);
    Serial.print(c2);
  }
}

void MToquat(float* m, float* q){
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
