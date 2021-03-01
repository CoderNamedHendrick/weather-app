import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: "Weather App",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  String state;

  final myController = TextEditingController();

  Future getWeather({state: 'Lagos'}) async {
    this.state = state;
    http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=${state}&units=metric&appid=b17aaa6e4063f24e319f15b72e5d7177');
    var result = jsonDecode(response.body);
    setState(() {
      this.temp = result['main']['temp'];
      this.description = result['weather'][0]['description'];
      this.currently = result['weather'][0]['main'];
      this.humidity = result['main']['humidity'];
      this.windSpeed = result['wind']['speed'];
    });
  }

  FaIcon tempIcon({var temp}){
    if(temp < 27)
      if(temp < 18)
        if (temp < 9)
          if (temp < 3)
            return FaIcon(FontAwesomeIcons.thermometerEmpty, color: Colors.blue,);
          else
            return FaIcon(FontAwesomeIcons.thermometerQuarter, color: Colors.blue[500],);
        else
          return FaIcon(FontAwesomeIcons.thermometerHalf, color: Colors.blue.shade300,);
      else
        return FaIcon(FontAwesomeIcons.thermometerThreeQuarters, color: Colors.red,);
    else
      return FaIcon(FontAwesomeIcons.thermometerFull, color: Colors.red,);
  }

  FaIcon weatherConditionIcon({ var description}){
    if(description.toString().contains("sky")){
      return FaIcon(FontAwesomeIcons.solidSun, color: Colors.orange,);
    } else if(description.toString().contains("cloud")){
      return FaIcon(FontAwesomeIcons.mixcloud, color: Colors.orange,);
    } else{
      return FaIcon(FontAwesomeIcons.cloud);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: currently == 'Clear' ? Colors.blueAccent.shade200 : Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(
                        opacity: 0.0,
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white, width: 2.0),
                        ),
                        child: SizedBox(
                          height: 48,
                          width: 204,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: TextField(
                              cursorColor: Colors.white70,
                              controller: myController,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.search),
                        onPressed: () {
                          getWeather(state: "${myController.text}");
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Currently in ${state}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + "\u00B0" : "loading",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    currently != null ? currently.toString() : "loading",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView(
                children: [
                  ListTile(
                    leading: tempIcon(temp: temp),
                    title: Text("Temperature"),
                    trailing: Text(
                        temp != null ? temp.toString() + "\u00B0" : "loading"),
                  ),
                  ListTile(
                    leading: weatherConditionIcon(description: description),
                    title: Text("Weather"),
                    trailing: Text(description != null
                        ? description.toString()
                        : "loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Humidity"),
                    trailing: Text(
                        humidity != null ? humidity.toString() : "loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("WindSpeed"),
                    trailing: Text(
                        windSpeed != null ? windSpeed.toString() : "loading"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

