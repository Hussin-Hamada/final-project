#include <Arduino.h>
#include <ESP8266WiFi.h>

#include <Firebase_ESP_Client.h>
//Provide the token generation process info.
//#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
//#include "addons/RTDBHelper.h"

#include <DHTesp.h>
#include <LiquidCrystal_I2C.h>

#include <NTPClient.h>
#include <WiFiUdp.h>

#include <WiFiClient.h>
#include <ThingSpeak.h>

WiFiClient client;

unsigned long myChannelNumber = 2046367; //Your Channel Number (Without Brackets)
const char * myWriteAPIKey = "4B6DSS2MI7O243EL"; //Your Write API Key

// Insert your network credentials
#define WIFI_SSID "hussin"
#define WIFI_PASSWORD "123qweasd"

// Insert Firebase project API Key
#define API_KEY "AIzaSyDY6KHmgnqGTeg_vnxsEEa8qIXie4mCs3Y"

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://aaaaa-a4343-default-rtdb.firebaseio.com/" 

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

String mode = "0";
String pump;

String databasePath = "/users/OqWq4MWdesgOQaS2wEG6SZW7KNO2/device1/read/";

String temperaturePath;
String humidityPath;
String soilMoisturePath;
String timeStampPath;
String modePath = "/users/OqWq4MWdesgOQaS2wEG6SZW7KNO2/device1/write/mode";
String pumpPath = "/users/OqWq4MWdesgOQaS2wEG6SZW7KNO2/device1/write/pump";

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

String timeStamp;

unsigned long getTime() {
  timeClient.update();
  unsigned long now = timeClient.getEpochTime();
  return now;
}

int lcdColumns = 20;
int lcdRows = 4;
#define AOUT_PIN A0
LiquidCrystal_I2C lcd(0x3F, lcdColumns, lcdRows); 
#define DHTpin 14    
DHTesp dht;
int relay=12;

void setup(){
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  ThingSpeak.begin(client);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")){
    Serial.println("ok");
  }
  else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  config.max_token_generation_retry = 5;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  timeClient.begin();

  pinMode(relay,OUTPUT);

  dht.setup(DHTpin, DHTesp::DHT11);

  lcd.init();
  lcd.backlight();
  lcd.print("");

  delay(dht.getMinimumSamplingPeriod());
}

void loop(){

  float temperature = dht.getTemperature();
  float humidity = dht.getHumidity();

  lcd.setCursor(0, 0);
  lcd.print("Temperature =");
  lcd.print(temperature);
  lcd.print("C");

  lcd.setCursor(0, 1);
  lcd.print("  Humidity =");
  lcd.print(humidity);
  lcd.print("%");

  float value = analogRead(AOUT_PIN); // read the analog value from sensor
  float soilMoisture = 100 - (value/10.24);

  lcd.setCursor(0, 2);
  lcd.print("Soil Moisture =");
  lcd.print(soilMoisture);
  lcd.print("%  ");

  timeStamp = getTime();

  temperaturePath = databasePath + "air temperature";
  humidityPath = databasePath + "air humidity";
  soilMoisturePath = databasePath + "soil humidity";
  timeStampPath = databasePath + "time stamp";

  Firebase.RTDB.setString(&fbdo, timeStampPath, timeStamp);
  Firebase.RTDB.setString(&fbdo, temperaturePath, temperature);
  Firebase.RTDB.setString(&fbdo, humidityPath, humidity);
  Firebase.RTDB.setString(&fbdo, soilMoisturePath, soilMoisture);

  Firebase.RTDB.getString(&fbdo,modePath);
  mode = fbdo.stringData();

  if (mode == "0"){
    if (soilMoisture < 50){
      digitalWrite(relay, LOW);
      lcd.setCursor(0, 3);
      lcd.print("Water pump is on. ");
    } else {
      digitalWrite(relay, HIGH);  
      lcd.setCursor(0, 3);
      lcd.print("Water pump is off.");
    }
  } else if (mode == "1"){
    Firebase.RTDB.getString(&fbdo,pumpPath);
    pump = fbdo.stringData();
    if (pump == "0"){
      lcd.setCursor(0, 3);
      lcd.print("Water pump is off.");
      digitalWrite(relay, HIGH);
    } else if (pump == "1"){
      lcd.setCursor(0, 3);
      lcd.print("Water pump is on. ");
      digitalWrite(relay, LOW);
    }
  }

  ThingSpeak.setField(1 , humidity);
  ThingSpeak.setField(2 , temperature);
  ThingSpeak.setField(3 , soilMoisture);
  ThingSpeak.writeFields(myChannelNumber , myWriteAPIKey);
}