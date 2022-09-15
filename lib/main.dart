// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:io' as dartio;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  double? temperature;
  String location = "Cali";
  int woeid = 2487956;
  String weather = 'clear';
  String newApiUrl =
      'http://api.weatherapi.com/v1/current.json?key=f5994c939c674eb6a0e153457221409&q=';
  String iconstate = "//cdn.weatherapi.com/weather/64x64/night/116.png";
  String weatherDescription = "Partly cloudly";
  String? errorMessage;
  late Position _currentPosition;
  late String _currentAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newFetchSearh(location);
  }

  // String searchApiUrl='https://wwww.metaweather.com/api/location/search/?query=';
  // String locationApiUrl='https://wwww.metaweather.com/api/location';

  //  // Not used due to the service is not working anymore
  // void fetchSearh(String input) async{
  //   // var serchResult=await http.get(Uri.parse(searchApiUrl + input));
  //   // var result=json.decode(serchResult.body)[0];

  //   setState(() {
  //     // location=result["title"];
  //     location="London";
  //     woeid=44418;
  //     // woeid=result["woeid"];
  //   });
  // }

  // Not used due to the service is not working anymore
  // void fetchLocation()async{
  //   // // var locationResult=await http.get(Uri.parse(locationApiUrl+woeid.toString()));
  //   // var result=json.decode(locationResult.body);
  //   // var consolidatedWeather=result["consolidated_weather"];
  //   // var data=consolidatedWeather[0];
  //   setState(() {
  //     // temperature=data["the_temp"].round();
  //     temperature=24;
  //     weather="clear";
  //     // weather=data['weather_state_name'].replaceall(' ','').toLowerCase();
  //   });

  // }

  String background(int state) {
    if (state >= 1003 && state <= 1006) {
      return "lightcloud";
    }
    if ((state >= 1009 && state <= 1030) || (state >= 1134 && state <= 1147)) {
      return "heavycloud";
    }
    if ((state == 1063) || (state >= 1150 && state <= 1180)) {
      return "showers";
    }
    if ((state >= 1066 && state <= 1072) ||
        (state >= 1114 && state <= 1117) ||
        (state >= 1198 && state <= 1225)) {
      return "snow";
    }
    if ((state == 1087) || (state >= 1273 && state <= 1282)) {
      return "thunderstorm";
    }
    if ((state >= 1183 && state <= 1189) || (state >= 1243 && state <= 1246)) {
      return "lightrain";
    }
    if (state >= 1192 && state <= 1195) {
      return "heavyrain";
    }
    if ((state >= 1237 && state <= 1240) || (state >= 1249 && state <= 1264)) {
      return "hail";
    }
    return "clear";
  }

  //Using the another API
  Future<void> newFetchSearh(String input) async {

    try {
      var serchResult = await http.get(Uri.parse(newApiUrl + input));
      var result = json.decode(serchResult.body);
      // devtools.log(newApiUrl + input);
      // devtools.log(result["current"]["temp_c"].toString());
      setState(() {
        location =
            result["location"]["name"] + ", " + result["location"]["country"];
        temperature = result["current"]["temp_c"];
        weather = background(result["current"]["condition"]["code"]);
        iconstate = result["current"]["condition"]["icon"];
        weatherDescription = result["current"]["condition"]["text"];
        // devtools.log(result["current"]["condition"].toString());
        // devtools.log(weather);
        errorMessage = '';
        // woeid=result["woeid"];
      });
    } catch (error) {
      setState(() {
        errorMessage =
            "Sorry, we don't have data about this city, Try another one";
      });
    }
  }

  void onTextFieldSubmitted(String input) async {
    await newFetchSearh(input);
    
    // fetchSearh(input);
    // fetchLocation();
  }

  _getCurrentLocation() {
    getLocation();
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      devtools.log(_currentAddress);
      onTextFieldSubmitted(place.locality??"");
    } catch (e) {
      print(e);
    }
  }

   void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
 
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
 
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/$weather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: temperature == null
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right:20),
                      child: GestureDetector(
                        onTap: () {
                          _getCurrentLocation();
                        },
                        child: Icon(
                          Icons.location_city,
                          size: 36,
                        ),
                      ),
                    )
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: [
                          Center(
                              child: Image.network(
                            "http:$iconstate",
                            scale: 0.6,
                          )),
                          Text("$temperature °C",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 60)),
                          Text(
                            location,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            weatherDescription,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          child: TextField(
                            onSubmitted: (String input) {
                              onTextFieldSubmitted(input);
                            },
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            decoration: InputDecoration(
                                hintText: 'Search another location...',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.white)),
                          ),
                        ),
                        Text(
                          errorMessage ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize:
                                  dartio.Platform.isAndroid ? 15.0 : 20.0),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
