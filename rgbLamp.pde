

int redLed = 2;
int greenLed = 4;
int blueLed = 6;

int RED[] = {255, 0, 0};
int GREEN[] = {0, 255, 0};
int BLUE[] = {0, 0, 255};
int BROWN[] = {255, 255, 0};
int NONE[] = {0, 0, 0};

const int PHASE_STARTED = 2;
const int PHASE_COMPLETED = 4;
const int PHASE_FINISHED = 6;

const int STATUS_SUCCESS = 8;
const int STATUS_FAILURE = 10;
const int STATUS_ABORTED = 12;

const int CODE_IS_BAD = 1;

const int NOT_INIT = 0;

const int MODE_PRODUCTION = 14;
const int MODE_TESTS = 16;

int currentStatus = NOT_INIT;

int runMode = MODE_TESTS; //Default

void setup() {
  Serial.begin(9600);
  pinMode(redLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
  pinMode(blueLed, OUTPUT);
}

boolean isValid(byte value) {
  return value == PHASE_STARTED ||
         value == PHASE_COMPLETED ||
         value == PHASE_FINISHED ||
         value == STATUS_SUCCESS ||
         value == STATUS_FAILURE ||
         value == STATUS_ABORTED ||
         value == CODE_IS_BAD ||
         value == MODE_PRODUCTION ||
         value == MODE_TESTS;
}

boolean isRunMode(byte value) {
  return value == MODE_PRODUCTION ||
         value == MODE_TESTS;
}

void loop() {
  
  if (Serial.available() > 0) {

    // get incoming byte:
    int inByte = Serial.read();
    
    if (isValid(inByte)) {
      if (isRunMode(inByte)) {
        setColour(NONE); //reset leds
        runMode = inByte;  
      } else {
        currentStatus = inByte;  
      }
    }
  }
  
  if (runMode == MODE_PRODUCTION) {
    runProduction();
  } else if (runMode = MODE_TESTS) {
    runLedTests();  
  }
  
}

void runLedTests() {
  setColour(RED);
  delay(1000);
  setColour(GREEN);
  delay(1000);
  setColour(BLUE);
  delay(1000);
}

void runProduction() {
  
  if (currentStatus != CODE_IS_BAD && currentStatus != NOT_INIT) {
    switch(currentStatus) {
        case STATUS_SUCCESS: 
          setColour(GREEN);
          break;
        case STATUS_FAILURE:
          setColour(RED);
          break;
        case PHASE_STARTED:
          setColour(BLUE);
          break;
        case STATUS_ABORTED:
          setColour(BROWN);
          break;
        default:
          setColour(NONE);
          break;
    }
  } else if (currentStatus == CODE_IS_BAD) {
    
    setColour(RED);
    delay(50);
    setColour(NONE);
    delay(50);
  }  
}

void setColour(int values[]) {
  setColour(values[0], values[1], values[2]);
}

void setColour(int red, int green, int blue) {
  red = validate(red);
  green = validate(green);
  blue = validate(blue);
  setRed(red);
  setGreen(green);
  setBlue(blue);
}

// Make sure value is within range of 0 - 255
// Return 0 if value < 0
// Return 255 if value > 255
int validate(int value) {
  if (value > 255) {
    value = 255;  
  } else if (value < 0) {
    value = 0;  
  }
  return value;
}

void setRed(int value) {
  analogWrite(redLed, value);
}

void setGreen(int value) {
  analogWrite(greenLed, value);
}

void setBlue(int value) {
  analogWrite(blueLed, value);
}
