import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future fetchData() async {
  final response =
      await http.get('https://api.covidindiatracker.com/state_data.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("Collected");
    return json.decode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Data');
  }
}

class StateWiseCovidBar extends StatefulWidget {
  // final List<double> covidCases;

  @override
  _StateWiseCovidBarState createState() => _StateWiseCovidBarState();
}

class _StateWiseCovidBarState extends State<StateWiseCovidBar> {

  List futureData;
  Map data = Map<String,double>();
  List<double> listData=new List<double>();

  @override
  void initState() {
    super.initState();
    _takeData();
  }

  void _takeData() async{
    futureData = await fetchData();
    futureData.forEach((element) {
      if(element['id']=='IN-MH')
      {
        data['IN-MH']=element['confirmed'].toDouble();
      }
       if(element['id']=='IN-TN')
      {
        data['IN-TN']=element['confirmed'].toDouble();
      }
      if(element['id']=='IN-DL')
      {
        data['IN-DL']=element['confirmed'].toDouble();
      }
      if(element['id']=='IN-GJ')
      {
        data['IN-GJ']=element['confirmed'].toDouble();
      }
      if(element['id']=='IN-RJ')
      {
        data['IN-RJ']=element['confirmed'].toDouble();
      }               
    });
      if(this.mounted){
    setState(() {
      data.forEach((k, v) => listData.add(v/8000));
    });
      }
  }

  @override
  Widget build(BuildContext context) {
     return Container(
      height: 400.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'State Wise Cases',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.35,
            child: listData.length == 0
                  ? Center(child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator()))
                  : BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 16.0,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    margin: 10.0,
                    showTitles: true,
                    textStyle: Styles.chartLabelsTextStyle,
                    rotateAngle: 35.0,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Maharashtra';
                        case 1:
                          return 'TamilNadu';
                        case 2:
                          return 'Delhi';
                        case 3:
                          return 'Gujarat';
                        case 4:
                          return 'Rajasthan';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                      margin: 10.0,
                      showTitles: true,
                      textStyle: Styles.chartLabelsTextStyle,
                      getTitles: (value) {
                        if (value == 0) {
                          return '0';
                        } else if (value % 3 == 0) {
                          return '${value ~/ 3 * 25}K';
                        }
                        return '';
                      }),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 3 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.black12,
                    strokeWidth: 1.0,
                    dashArray: [5],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: listData
                    .asMap()
                    .map((key, value) => MapEntry(
                        key,
                        BarChartGroupData(
                          x: key,
                          barRods: [
                            BarChartRodData(
                              y: value,
                              color: Colors.red,
                            ),
                          ],
                        )))
                    .values
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}