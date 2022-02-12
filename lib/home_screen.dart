import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:weather/model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color whiteColor=Colors.white;
  int woied = 0;
  String image = "clear";
  String cityName = "City";
  int temp = 0;
  int min_temp = 0;
  int max_temp = 0;
  String abber = "c";
  String applicable_date = "${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day} ";
  Future getDataCity(String city) async {
    var Url = Uri.parse(
        "https://www.metaweather.com/api/location/search/?query=$city");
    var response = await http.get(Url);
    var respnseBody = jsonDecode(response.body)[0];
    setState(() {
      woied = respnseBody["woeid"];
      cityName = respnseBody["title"];
    });
  }

  Future<List<ModelTemp>> getDataWeather() async {
    List<ModelTemp> list = [];
    var Url = Uri.parse("https://www.metaweather.com/api/location/$woied");
    var response = await http.get(Url);
    var respnseBody = jsonDecode(response.body)["consolidated_weather"];
    setState(() {
      temp = respnseBody[0]["the_temp"].round();
      min_temp = respnseBody[0]["min_temp"].round();
      max_temp = respnseBody[0]["max_temp"].round();
      applicable_date = respnseBody[0]["applicable_date"];

      image =
          respnseBody[0]["weather_state_name"].replaceAll(' ', '').toLowerCase();
      abber = respnseBody[0]["weather_state_abbr"];
      print(temp);

    });
    for (var i in respnseBody) {
      ModelTemp x = ModelTemp(
        min_temp: i["min_temp"],
        max_temp: i["max_temp"],
        the_temp: i["the_temp"],
          applicable_date: i["applicable_date"]
      );
      list.add(x);
  }
    return list;
  }


  void implement(input) async {
    await getDataCity(input);
    await getDataWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/$image.png"))),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            padding: const EdgeInsets.symmetric(vertical: 50,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "$cityName",
                    style:  TextStyle(
                        color: whiteColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "$applicable_date",
                    style:  TextStyle(
                        color: whiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 53.0),
                        child: Image.network(
                          "https://www.metaweather.com/static/img/weather/png/$abber.png",
                          width: 70,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "$temp",
                        style:  TextStyle(
                            color: whiteColor,
                            fontSize: 80,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             Text(
                              "°C ",
                              style: TextStyle(color:whiteColor, fontSize: 20),
                            ),
                            Container(
                              color: whiteColor,
                              width: 50,
                              height: 1,
                            ),
                             Text(
                              " F",
                              style: TextStyle(color:whiteColor, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             Text(
                              "$min_temp ",
                              style: TextStyle(color:whiteColor, fontSize: 20),
                            ),
                            Container(
                              color:whiteColor,
                              width: 50,
                              height: 1,
                            ),
                             Text(
                              "$max_temp ",
                              style: TextStyle(color:whiteColor, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        cursorColor:whiteColor,
                        onSubmitted: (String input) {
                          implement(input);
                        },
                        style:  TextStyle(color: whiteColor, fontSize: 20),
                        decoration:  InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search_outlined,
                              color: whiteColor,
                              size: 28,
                            ),
                            hintText: "Search on your city",
                            hintStyle:
                                TextStyle(color: whiteColor, fontSize: 22)),
                      ),
                    ),
                    Container(
                      height: 200,
                      child: FutureBuilder(
                        future: getDataWeather(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.data==null){
                            return Text("");
                          }
                          else if(snapshot.hasData){
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  color: Colors.transparent,
                                  child: Container(

                                    width: 144,

                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("${snapshot.data[index].applicable_date}",style: TextStyle(
                                              color:whiteColor
                                          )),
                                          Image.network(
                                            "https://www.metaweather.com/static/img/weather/png/$abber.png",
                                            width: 45,
                                          ),
                                          Text("The_Temp    ${snapshot.data[index].the_temp.round()}°",style: TextStyle(
                                              color: whiteColor
                                          )),


                                          Text("Min_Temp    ${snapshot.data[index].min_temp.round()}°",style: TextStyle(
                                            color: whiteColor
                                          ),),
                                          Text(" Max_Temp   ${snapshot.data[index].max_temp.round()}°",style: TextStyle(
                                              color: whiteColor
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },);
                          }
                         else {
                           return Text("");
                          }
                        },),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
/*
Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network("https://www.metaweather.com/static/img/weather/png/$abber.png",width: 100,),
            Center(
              child: Text("$temp | °C",style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),),
            ),
            Center(
              child: Text("$cityName",style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onSubmitted: (String input){
                  implement(input);

                },
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_outlined,color: Colors.white,size: 28,),

                  hintText:"Search on your city",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22
                  )
                ),
              ),
            )
          ],
        ),
 */
