#include <Servo.h>

const int trigPin = 10;
const int echoPin = 9;
const int redpin = 11;
const int bluepin = 12;
const int greenpin = 13;
const int buzzerPin = 4;
long duration;
int distance;
Servo myServo;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
  myServo.attach(5);
  pinMode(redpin, OUTPUT);
  pinMode(greenpin, OUTPUT);
  pinMode(bluepin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);
}

void loop() {
  for (int i = 15; i <= 165; i++) {  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".\n");  

    checkDistanceAlert(distance);
  }

  for (int i = 165; i >= 15; i--) {  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();

    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".\n");  

    checkDistanceAlert(distance);
  }
}

int calculateDistance() { 
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;  
  return distance;
}

void checkDistanceAlert(int distance) {
  if (distance < 15) {
    setColor(255, 0, 0);
    tone(buzzerPin, 1000);
  } else {
    setColor(0, 0, 255);
    noTone(buzzerPin);
  }
}

void setColor(int redValue, int greenValue, int blueValue) {
  analogWrite(redpin, redValue);
  analogWrite(greenpin, greenValue);
  analogWrite(bluepin, blueValue);
}

