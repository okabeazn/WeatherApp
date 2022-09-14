import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int temperature = 0;
  String location = "Cali";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/clear.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Text("$temperature °C",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 60)),
                    Text(
                      location,
                      style: const TextStyle(color: Colors.white, fontSize: 40),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: const TextField(
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                            hintText: 'Search another location...',
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 18),
                            prefixIcon: Icon(Icons.search, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
