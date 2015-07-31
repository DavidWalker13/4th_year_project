void data_out(){
    // display tab-separated accel/gyro x/y/z values
  Serial.print("a/g:\t");
  Serial.print(a[0]); Serial.print("\t");
  Serial.print(a[1]); Serial.print("\t");
  Serial.print(a[2]); Serial.print("\t");
  Serial.print(w[0]); Serial.print("\t");
  Serial.print(w[1]); Serial.print("\t");
  Serial.println(w[2]);
  
  Serial.print("mag:\t");
  Serial.print(mx); Serial.print("\t");
  Serial.print(my); Serial.print("\t");
  Serial.println(mz); 
  
  Serial.print("baro:\t");
  Serial.print(press); Serial.print("\t");
  Serial.print(altitude); Serial.print("\t");
}
