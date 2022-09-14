import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as devtools show log;

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  WeatherApp({Key? key}) : super(key: key);

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  double temperature = 0;
  String location = "Cali";
  int woeid=2487956;
  String weather='clear';
  String newApiUrl='http://api.weatherapi.com/v1/current.json?key=f5994c939c674eb6a0e153457221409&q=';
  

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

  String background(int state){
    if(state>=1003 && state<=1006 ){
      return "lightcloud";
    }
    if((state>=1009 && state<=1030 )||(state>=1135 && state<=1147 )){
      return "heaycloud";
    }
    if((state==1063)||(state>=1150 && state<=1180 )){
      return "showers";
    }
    if((state>=1066 && state<=1072) || (state>=1114 && state<=1117 ) || (state>=1198 && state<=1225 )){
      return "snow";
    }
    if((state==1087)||(state>=1273 && state<=1282 )){
      return "thunderstorm";
    }
    if((state>=1183 && state<=1189 )||(state>=1243 && state<=1246 )){
      return "lightrain";
    }
    if(state>=1192 && state<=1195 ){
      return "heavyrain";
    }
    if((state>=1237 && state<=1240 )||(state>=1249 && state<=1264 )){
      return "hail";
    }
    return "clear";
  }

  //Using the another API
  void newFetchSearh(String input) async{
      var serchResult=await http.get(Uri.parse(newApiUrl + input));
      var result=json.decode(serchResult.body);
      // devtools.log(newApiUrl + input);
      // devtools.log(result["current"]["temp_c"].toString());
      setState(() {
        location=result["location"]["name"];
        temperature=result["current"]["temp_c"];
        weather=background(result["current"]["condition"]["code"]);
        devtools.log(result["current"]["condition"].toString());
        devtools.log(weather);
        // woeid=result["woeid"];
      });
    }
  void onTextFieldSubmitted(String input){
     newFetchSearh(input);
    // fetchSearh(input);
    // fetchLocation();
  }

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
              Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    child: TextField(
                      onSubmitted: (String input){
                        onTextFieldSubmitted(input);
                      },
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      decoration: InputDecoration(
                          hintText: 'Search another location...',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          prefixIcon: Icon(Icons.search, color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
