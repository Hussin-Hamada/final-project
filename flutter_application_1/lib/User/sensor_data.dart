import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SensorData extends StatefulWidget {
  const SensorData({Key? key}) : super(key: key);

  @override
  State<SensorData> createState() => _SensorDataState();
}

class _SensorDataState extends State<SensorData> {
  String airHumidity = '';
  String airTemperature = '';
  String soilHumidity = '';
  String timeStamp = '';
  late final ref = FirebaseDatabase.instance
      .ref('users/OqWq4MWdesgOQaS2wEG6SZW7KNO2/device1/read');

  gettData() {
    ref.onValue.listen(
      (DatabaseEvent event) {
        if (this.mounted) {
          setState(
            () {
              airHumidity =
                  event.snapshot.child('air humidity').value.toString();
              airTemperature =
                  event.snapshot.child('air temperature').value.toString();
              soilHumidity =
                  event.snapshot.child('soil humidity').value.toString();
              timeStamp = event.snapshot.child('time stamp').value.toString();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    gettData();
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pattern.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100),
                Text(
                  'Air Temperature: $airTemperature',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Text(
                  'Air Humidity: $airHumidity',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Text(
                  'Soil Humidity: $soilHumidity',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
