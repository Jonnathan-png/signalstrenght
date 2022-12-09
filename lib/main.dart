import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
//Paquete de la intensdiad de la señal
import 'package:gsm_info/gsm_info.dart';
//Paquete de las coordenadas
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _signal_strength = 0;
  late Position position;
  late StreamSubscription<Position> positionStream;
  String lat = '', long = '';

  @override
  void initState() {
    super.initState();
    getsignal_strength();
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    var geolocator = Geolocator();
    var locationOptions = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 1);

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationOptions)
            .listen((Position position) {

      if (position != null) {
        setState(() {
          lat = position.latitude.toStringAsFixed(9);
          long = position.longitude.toStringAsFixed(9);
        });
      } else {
        setState(() {
          lat = 'Unknown';
          long = 'Unknown';
        });
      }
    });
  }

  getSignal() {
    getsignal_strength();
  }

  // Metodo para getsignal_strength
  Future<void> getsignal_strength() async {
    int signal_strength = 0;
    try {
      signal_strength = await GsmInfo.gsmSignalDbM;
      print(signal_strength);
    } on PlatformException {
      signal_strength = -999;
    }
    if (!mounted) return;

    setState(() {
      _signal_strength = signal_strength;
    });
  }

  //Construye la aplicación
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Scaffold: Lienzo de la aplicacion o pantalla
      home: Scaffold(
        //appBar: Barra superior (Titulo)
        appBar: AppBar(
          title: const Text('signal Strenght'),
          backgroundColor: Colors.redAccent,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              const Text(
                "Intensidad y ubicación",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
              ),
              const Text(
                "de la señal móvil Celular",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
              ),
              //espacio
              const SizedBox(
                height: 20,
              ),
              //boton
              ElevatedButton(
                onPressed: getSignal(),
                child: const Text("Signal"),
              ),
              Text(
                'Running on: $_signal_strength dbm',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              //Widgets Lat -Lon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Latitud",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        lat,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Longitud",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        long,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: getLocation,
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black45,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    child: Text('Iniciar',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
