void initialize() {
  // put your setup code here, to run once:
  // join I2C bus (I2Cdev library doesn't do this automatically)
  #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
      Wire.begin();
      TWBR = 24; // 400kHz I2C clock (200kHz if CPU is 8MHz)
  #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
      Fastwire::setup(400, true);
  #endif
  
  Serial.begin(115200);

  //attach servos
  servo1.attach(6,900,2100);
  servo2.attach(7,900,2100);
  servo3.attach(8,900,2100);
  servo4.attach(9,900,2100);
  servo1.write(90);
  servo2.write(90);
  servo3.write(90);
  servo4.write(90);
  
  // initialize device
  Serial.println("Initializing I2C devices...");
  accelgyro.initialize();
  accelgyro.setI2CBypassEnabled(1);
  mag.initialize();
  baro.init(MS561101BA_ADDR_CSB_LOW); 
  
  //gyro set up
  accelgyro.setRate(4);
  accelgyro.setDLPFMode(1);
  accelgyro.setFullScaleGyroRange(2); //2 = +/- 1000 degrees/sec
  
  //accel setup
  accelgyro.setFullScaleAccelRange(3);
  
  // populate movavg_buff before starting loop
  while(pressure==NULL) {
    delay(10);
    pressure = baro.getPressure(MS561101BA_OSR_4096);      
  }

  ground_pressure = pressure; //set pressure at ground level
  alt_const=(287/9.8)*(273+baro.getTemperature(MS561101BA_OSR_4096));
  
  // verify connection
  Serial.println("Testing device connections...");
  Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");
  Serial.println(mag.testConnection() ? "HMC5883L connection successful" : "HMC5883L connection failed");

  gyro_calibration();
  pinMode(Buzzer_Pin, OUTPUT);
  pinMode(Pyro_Pin, OUTPUT);
  
  Serial.println("End setup");
  digitalWrite(Buzzer_Pin, HIGH);   
  delay(500);              
  digitalWrite(Buzzer_Pin, LOW);    
}

void gyro_calibration(){
  delay(1000); //make sure everything is static
  long GxCal=0, GyCal=0, GzCal=0; 
  int n=100;
  for (uint8_t i=0; i<n; i++) {
    //Read the x,y and z output rates from the gyroscope and take an average of 50 results
    GxCal += accelgyro.getRotationX();
    GyCal += accelgyro.getRotationY();
    GzCal += accelgyro.getRotationZ();
    delay(10);
  }
  //use these to find gyro offsets
  gxoff=1.0*GxCal/n;
  gyoff=1.0*GyCal/n;
  gzoff=1.0*GzCal/n;

}
