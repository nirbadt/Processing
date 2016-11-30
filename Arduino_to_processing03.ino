//This code allows for an auto_calibration and stabilization process to continuously calibrate the upper and lower boundries of the map function.
//This allows having always the maximal scale of output, regardless of the scale of input

#define THERMISTORPIN A0 //this is our example sensor 
#define NUMSAMPLES 5  // how many samples to take and average, more takes longer but is more 'smooth'
int samples[NUMSAMPLES];

float  max = -100; //sensor initialization value, should be lower than expected maximal value
float  min = 500; //sensor initialization value, should be higher than expected maximal value
float reading;  //reading from sensor
float driftFactor = 500; //sets how fast the upper and lower boundries will close back to each other

void setup() {
  Serial.begin(9600);
  analogReference(EXTERNAL);
  establishContact();  // send a byte to establish contact until receiver responds 
}

void loop() {
  uint8_t i;
  float average;
  
  //this loop puts puts reads inside the samples[] array
  for (i = 0; i < NUMSAMPLES; i++) {

    samples[i] = analogRead(THERMISTORPIN);
    delay(10);
  }
    //this loop add all samples to an average sum
    average = 0;
    for (i = 0; i < NUMSAMPLES; i++) {
      average += samples[i];
    }

    average /= NUMSAMPLES; //divide the average by NUMSAMPLES to receive an average value
  
  //this part constatntly checks that the upper and lower boundries are set to the range between maximal value and minimal value
  if (average > max) {
    max = average;
  }
  max = (max * driftFactor + average) / (driftFactor + 1); //this part slowly lowers the max down to allow the input to grow weaker and still create a full output
  if (average < min) {
    min = average;
  }
  min = (min * driftFactor + average) / (driftFactor + 1); //this part slowly raises the min up to allow the input to grow weaker and still create a full output

  int output = map(average, min, max, 0, 600);
  /*
  Serial.print(average);
  Serial.print("  ,  ");
  Serial.print(output);
  Serial.print("  ,  ");
  Serial.print(min);
  Serial.print("  ,  ");
  Serial.println(max);
  */
  //Serial.println(output); 
  Serial.write(output);
  delay(20);
  
}
void establishContact() {
  while (Serial.available() <= 0) {
  Serial.println("A");   // send a capital A
  delay(300);
  }
}

