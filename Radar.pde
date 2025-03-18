import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial myPort; // Defines variables
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
PFont orcFont;

void setup() {
  size(1366, 768);
  smooth();
  myPort = new Serial(this, "COM3", 9600); // Change COM port accordingly
  myPort.bufferUntil('.'); // Reads data from the serial port up to the character '.'
}

void draw() {
  fill(98, 245, 31);
  // Simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height - height * 0.065);

  fill(98, 245, 31); // Green color
  // Calls the functions for drawing the radar
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) { // Starts reading data from the Serial Port
  data = myPort.readStringUntil('.'); // Reads data from Serial Port up to '.'
  if (data != null) {
    data = data.trim(); // Removes any newline or whitespace
    index1 = data.indexOf(","); // Finds ',' and puts its position into index1

    if (index1 > 0) {
      angle = data.substring(0, index1); // Value of the angle
      distance = data.substring(index1 + 1, data.length()); // Value of the distance

      // Converts the String variables into Integers
      iAngle = int(angle);
      iDistance = int(distance);
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // Moves the starting coordinates
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  // Draws the arc lines
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);
  // Draws the angle lines
  line(-width / 2, 0, width / 2, 0);
  for (int angle = 30; angle <= 150; angle += 30) {
    line(0, 0, (-width / 2) * cos(radians(angle)), (-width / 2) * sin(radians(angle)));
  }
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074); // Moves the starting coordinates
  strokeWeight(9);
  stroke(255, 10, 10); // Red color
  pixsDistance = iDistance * ((height - height * 0.1666) * 0.025); // Distance from cm to pixels
  // Limiting the range to 40 cm
  if (iDistance < 40) {
    // Draws the object according to the angle and the distance
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), 
         (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074); // Moves the starting coordinates
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle))); // Draws the line according to the angle
  popMatrix();
}

void drawText() { // Draws the texts on the screen
  pushMatrix();
  noObject = (iDistance > 40) ? "Out of Range" : "In Range";
  
  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(25);

  text("10cm", width - width * 0.3854, height - height * 0.0833);
  text("20cm", width - width * 0.281, height - height * 0.0833);
  text("30cm", width - width * 0.177, height - height * 0.0833);
  text("40cm", width - width * 0.0729, height - height * 0.0833);
  textSize(40);
  text("GHEORGHE", width - width * 0.875, height - height * 0.0277);
  text("Angle: " + iAngle + " °", width - width * 0.48, height - height * 0.0277);
  if (iDistance < 40) {
    text(iDistance + " cm", width - width * 0.225, height - height * 0.0277);
  }
  textSize(25);
  fill(98, 245, 60);
  
  // Display angle markers
  int[] angles = {30, 60, 90, 120, 150};
  for (int angle : angles) {
    float x = (width / 2) * cos(radians(angle));
    float y = -(width / 2) * sin(radians(angle));
    resetMatrix();
    translate(width / 2 + x, height - height * 0.074 + y);
    rotate(radians(-angle + 90));
    text(angle + "°", 0, 0);
  }
  popMatrix();
}
