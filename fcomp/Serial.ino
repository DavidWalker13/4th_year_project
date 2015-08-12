
void data_out(){ 
 //print_accel();
 //print_gyro();
 //print_mag();
 //print_baro();
 serialcubeout((float*) R1, 9);
}

void print_accel(){
  Serial.print("a:\t");
  Serial.print(a[0]); Serial.print("\t");
  Serial.print(a[1]); Serial.print("\t");
  Serial.println(a[2]); 
}

void print_gyro(){
  Serial.print("g:\t");
  Serial.print(w[0]); Serial.print("\t");
  Serial.print(w[1]); Serial.print("\t");
  Serial.println(w[2]);
}

void print_mag(){
  Serial.print("mag:\t");
  Serial.print(mx); Serial.print("\t");
  Serial.print(my); Serial.print("\t");
  Serial.println(mz); 
}

void print_baro(){
  Serial.print("baro:\t");
  Serial.print(press); Serial.print("\t");
  Serial.print(altitude); Serial.print("\t");
}

void serialcubeout(float* M, int length){
  //function to send data to cube visualization
  char cmd;
  while(!Serial.available()) {
    ; // do nothing until ready
  }
  cmd = Serial.read();
  if(cmd == 'q'){
    for(int i=0; i<length; i++){
      serialFloatPrint(M[i]);
      Serial.print(",");
    }
    Serial.print(time_for_loop);
    Serial.println("");
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
