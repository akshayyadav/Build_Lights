#include <EEPROM.h>

const int RedPin = 12;     //RED LED connection
const int GreenPin = 13;   //GREEN Led connection
int incomingByte = 'B';         // a variable to read incoming serial data into
int DEBUG = 0;
int addr = 1;
int previous = 'B';


void setup() {
  // initialize serial communication:
  Serial.begin(9600);
  // initialize the LED pin as an output:
  pinMode(RedPin, OUTPUT);
  pinMode(GreenPin, OUTPUT);
  Serial.flush();
  incomingByte = EEPROM.read(addr);
  
}

void loop() {
  // see if there's incoming serial data:
    
    incomingByte = EEPROM.read(addr);
    lights_controller(incomingByte);

}

void lights_controller(int incomingByte) {

    // read the oldest byte in the serial buffer:
    if (Serial.available() > 0)
    {  
      incomingByte = Serial.read();
      
      delay(100);
    }
    
    if (incomingByte == 'F')
    {
      digitalWrite(RedPin, HIGH);
      digitalWrite(GreenPin, LOW);
      EEPROM.write(addr, incomingByte);
      previous = incomingByte;
    }

    else if (incomingByte == 'P')
    {
      digitalWrite(GreenPin, HIGH);
      digitalWrite(RedPin, LOW);
      EEPROM.write(addr, incomingByte);
      previous = incomingByte;
    }

    else if (incomingByte == 'B')
    {
        digitalWrite(GreenPin, HIGH);
        digitalWrite(RedPin, LOW);
        delay(500);
        digitalWrite(GreenPin, LOW);
        digitalWrite(RedPin, HIGH);
        delay(500);
        EEPROM.write(addr, incomingByte);
        previous = incomingByte;
    }
    else
    {
      EEPROM.write(addr, previous);
    }
    
    
}
