void event_detection(){
  //shift launch_event array, discarding the oldest value and setting the right most bit to 0 
  launch_event = launch_event << 1;
  //detect launch event, is the magntiude of the acceration above 4g?
  if( (fabs(a[0])+fabs(a[1])+fabs(a[2])) > 40 && launch_confirmed == false){
    launch_event = launch_event | 1; //set right most bit to 1 
    if( launch_event == 1 ) {
       Serial.println("Launch event detected"); 
    }
  }
  //Serial.println(launch_event, BIN);
  //Serial.println((ground_pressure-pressure));

  //confirm launch if change in height is >launch_detect_altitude since launch event
  if(launch_event > 0 && (ground_pressure-pressure)*alt_const/ground_pressure > launch_detect_altitude){
    launch_confirmed = true;
    Serial.println("Launch confirmed");
  }
  if(launch_event >= 0x8000000000000000 && launch_confirmed == false){ //if the left most digit of launch event is a 1 
    Serial.print("False launch detected at time: ");
    Serial.println(millis());
  }

  //detect apogee
  if(launch_confirmed == true && vert_vel < 0){
    apogee=true;
    Serial.print("Apogee detected at: ");
    Serial.println(millis());
  }

  //deploy main
  if(apogee == true && (ground_pressure-pressure)*alt_const/ground_pressure < 100){
    main_deploy=true;
    Serial.print("Main deployed at: ");
    Serial.println(millis());
  }

}

void fire_pyro(){
  digitalWrite(Pyro_Pin, HIGH);   
  delay(1000);              
  digitalWrite(Pyro_Pin, LOW);  
}

