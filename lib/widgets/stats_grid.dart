import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatsGrid extends StatefulWidget {
  @override
  _StatsGridState createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {
  var total_case = 'NULL';
  var total_death = 'NULL';
  var total_recovered = 'NULL';
  var total_active = 'NULL';
  final String apiUrl = "https://api.covid19india.org/data.json";

  List lis;

  static Future<List<dynamic>> fetchUsers(url) async {
    var result = await http.get(url);
    return json.decode(result.body)['cases_time_series'];
  }

  void fetching() async {
    lis = await fetchUsers(apiUrl);
    print(lis[0]['dailyconfirmed']);
    setState(() {
      total_case = lis[lis.length - 1]['totalconfirmed'];
      total_death = lis[lis.length - 1]['totaldeceased'];
      total_recovered = lis[lis.length - 1]['totalrecovered'];
      total_active = (int.parse(total_case) -
              int.parse(total_death) -
              int.parse(total_recovered))
          .toString();
    });
    print(lis[lis.length - 1]);
  }

  @override
  void initState() {
    super.initState();
    fetching();
  }

  String show(val) {
    if (val == 'NULL') return '...';
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Total Cases', show(total_case), Colors.orange),
                _buildStatCard('Deaths', show(total_death), Colors.red),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                    'Recovered', show(total_recovered), Colors.green),
                _buildStatCard('Active', show(total_active), Colors.lightBlue),
                _buildStatCard('Critical', 'N/A', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
