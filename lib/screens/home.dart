import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:whetherapi2/constants/endpoints.dart' as constant;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String city = '';
  String discription = '';
  num? temp1;
  num? temp2;
  num? temp3;
  num? temp4;
  num? temp5;

  num? max1;

  num? min1;

  int sunrise=0;
   int sunset=0;
  String day1='';
  String day2='';
  String day3='';
  String day4='';
  String day5='';
  late DateTime date1;
  late DateTime date2;
  late DateTime date3;
  late DateTime date4;
  late DateTime date5;

  num? humidity;
  num? windspeed;

  bool isLoaded = false;
  String day = DateTime.now().toString();
  DateTime now = DateTime.now();
  num?formattedDate;
late DateTime formatedsunset;
late DateTime formatedsunrise;

var formattedSunRTime;
var formattedSunSTime;
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    print(position);
    if (position != null) {
      print('lat:${position.latitude},long:${position.longitude}');
      getCurrentCityWeather(position);
    } else {
      print("Data Unavailable");
    }
  }

  getCurrentCityWeather(Position pos) async {
    var url =
        '${constant.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${constant.apiKey}';
    var uri = Uri.parse(url);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var data = responce.body;
      var decodedData = jsonDecode(data);
      print(data);
      updateUI(decodedData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(responce.statusCode);
    }
  }

  updateUI(var decodedData) {
    print(decodedData);
    setState(() {
      if (decodedData == null) {
        city = "Not available";
        sunset=0;
        sunrise=0;
        temp1 = 0;
        temp2= 0;
        temp3 = 0;
        temp4 = 0;
        temp5 = 0;

        humidity = 0;
        discription = "Not Available";
        max1 = 0;
        min1= 0;
        windspeed = 0;
      } else {

        city = decodedData['city']['name'];
        humidity = decodedData['list'][0]['main']['humidity'];
        discription = decodedData['list'][0]['weather'][0]['description'];

        windspeed=decodedData['list'][0]['wind']['speed'];
        temp1=decodedData['list'][0]['main']['temp'] - 273;
        max1=(decodedData['list'][0]['main']['temp_min']-273).toInt();
        min1=(decodedData['list'][0]['main']['temp_max']-273).toInt();
        sunrise=decodedData['city']['sunrise'];
        sunset=decodedData['city']['sunset'];
        temp2=decodedData['list'][1]['main']['temp']-273;
        temp3=decodedData['list'][2]['main']['temp']-273;
        temp4=decodedData['list'][3]['main']['temp']-273;
        temp5=decodedData['list'][4]['main']['temp']-273;
        day1=decodedData['list'][1]['dt_txt'];
        day2=decodedData['list'][2]['dt_txt'];
        day3=decodedData['list'][3]['dt_txt'];
        day5=decodedData['list'][4]['dt_txt'];
        day5=decodedData['list'][5]['dt_txt'];





      }
    });
  }

  @override
  Widget build(BuildContext context) {
     formatedsunset = DateTime.fromMillisecondsSinceEpoch(sunset);
     formatedsunrise = DateTime.fromMillisecondsSinceEpoch(sunrise );
    formattedSunRTime = DateFormat('hh:mm a').format(formatedsunrise);
    formattedSunSTime = DateFormat('hh:mm a').format(formatedsunset);

    date1 = DateFormat("dd-MM-yyyy hh:mm:ss").parse(day1);
     date2 = DateFormat("dd-MM-yyyy hh:mm:ss").parse(day2);
     date3 = DateFormat("dd-MM-yyyy hh:mm:ss").parse(day3);
     date4 = DateFormat("dd-MM-yyyy hh:mm:ss").parse(day4);
     date5 = DateFormat("dd-MM-yyyy hh:mm:ss").parse(day5);





     return Scaffold(
      body: Stack(
        children: [
          Image(
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height,
              image: AssetImage(
                  'images/HD-wallpaper-red-and-black-clouds-during-night-time.jpg')),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  city,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  discription,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.cloud,
                  color: Colors.white,
                  size: 50,
                ),
                Text(
                  "${temp1?.toInt()}°C",
                  style: TextStyle(fontSize: 70, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "min",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        Text(
                          "${min1}°C",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: VerticalDivider(
                        width: 10,
                        thickness: 8,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "max",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        Text(
                          "${max1}°C",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
                // Divider(
                //   height: 100,
                //   color: Colors.white,
                //   thickness: 1,
                //   indent: 10,
                //   endIndent: 0,
                // ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('${DateFormat('EE').format(date1)},${DateFormat('hh a').format(date1)}', style: TextStyle(fontSize: 15, color: Colors.white)),
                          Text( ' ${temp1?.toInt()}°C',
                              style: TextStyle(fontSize: 20, color: Colors.white)),
                          Icon(
                            Icons.cloudy_snowing,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('${DateFormat('EE').format(date2)},${DateFormat('hh a').format(date2)}', style: TextStyle(fontSize: 15, color: Colors.white)),
                          Text( ' ${temp2?.toInt()}°C',
                              style: TextStyle(fontSize: 20, color: Colors.white)),
                          Icon(
                            Icons.cloudy_snowing,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('${DateFormat('EE').format(date3)},${DateFormat('hh a').format(date3)}', style: TextStyle(fontSize: 15, color: Colors.white)),
                          Text( ' ${temp3?.toInt()}°C',
                              style: TextStyle(fontSize: 20, color: Colors.white)),
                          Icon(
                            Icons.sunny,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('${DateFormat('EE').format(date4)},${DateFormat('hh a').format(date4)}', style: TextStyle(fontSize: 15, color: Colors.white)),
                          Text( ' ${temp4?.toInt()}°C',
                              style: TextStyle(fontSize: 20, color: Colors.white)),
                          Icon(
                            Icons.sunny,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text('${DateFormat('EE').format(date5)},${DateFormat('hh a').format(date5)}', style: TextStyle(fontSize: 15, color: Colors.white)),
                          Text( ' ${temp5?.toInt()}°C',
                              style: TextStyle(fontSize: 20, color: Colors.white)),
                          Icon(
                            Icons.cloud,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 100,
                  color: Colors.white,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Windspeed",
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                        Text("${windspeed?.toInt()}",
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                    // SizedBox(
                    //   width: 10,
                    //
                    VerticalDivider(
                      indent: 10,
                      endIndent: 0,
                      width: 10,
                      thickness: 8,
                      color: Colors.white,
                    ),
                    Column(
                      children: [
                        Text("sunrise",
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                        Text(formattedSunRTime,
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text("sunset",
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                        Text(formattedSunSTime,
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text("Humidity",
                            style: TextStyle(fontSize: 15, color: Colors.white)),
                        Text("${humidity?.toInt()}",
                            style: TextStyle(fontSize: 15, color: Colors.white)),

                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
