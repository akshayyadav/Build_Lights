const int RedPin = 12;     //RED LED connection
const int GreenPin = 13;   //GREEN Led connection
signed int incomingByte = 'H';         // a variable to read incoming serial data into
int ifoutofBuild = 0;
int DEBUG = 0;

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
  // initialize the LED pin as an output:
  pinMode(RedPin, OUTPUT);
  pinMode(GreenPin, OUTPUT);
  Serial.flush();
}

void loop() {
  // see if there's incoming serial data:
  if (Serial.available() > 0)
  {  
    // read the oldest byte in the serial buffer:
    
    incomingByte = Serial.read();
    
    if (incomingByte == 'F')
    {
      digitalWrite(RedPin, HIGH);
      digitalWrite(GreenPin, LOW);
    }

    else if (incomingByte == 'P')
    {
      digitalWrite(GreenPin, HIGH);
      digitalWrite(RedPin, LOW);
    }

    else if (incomingByte == 'B')
    {
        digitalWrite(GreenPin, HIGH);
        digitalWrite(RedPin, LOW);
        delay(500);
        digitalWrite(GreenPin, LOW);
        digitalWrite(RedPin, HIGH);
        delay(500);
        /*digitalWrite(GreenPin, HIGH);
        digitalWrite(RedPin, LOW);
        delay(500);
        digitalWrite(GreenPin, LOW);
        digitalWrite(RedPin, HIGH);
        delay(500);**/

    }
  }
}
