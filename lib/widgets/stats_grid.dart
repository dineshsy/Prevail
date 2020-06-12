import 'package:flutter/material.dart';

class StatsGrid extends StatefulWidget {
  StatsGrid({Key key, this.list, this.tabind}) : super(key: key);
  List list;
  var tabind = 0;
  @override
  _StatsGridState createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {
  var total_case = 'NULL';
  var total_death = 'NULL';
  var total_recovered = 'NULL';
  var total_active = 'NULL';
  var today_case = 'NULL';
  var today_death = 'NULL';
  var today_recovered = 'NULL';
  var today_active = 'NULL';
  var yesterday_case = 'NULL';
  var yesterday_death = 'NULL';
  var yesterday_recovered = 'NULL';
  var yesterday_active = 'NULL';

  void fetching() {
    print("hello");
    print(widget.list);
    setState(() {
      total_case = widget.list[widget.list.length - 1]['totalconfirmed'];
      total_death = widget.list[widget.list.length - 1]['totaldeceased'];
      total_recovered = widget.list[widget.list.length - 1]['totalrecovered'];
      total_active = (int.parse(total_case) -
              int.parse(total_death) -
              int.parse(total_recovered))
          .toString();
      today_case = widget.list[widget.list.length - 1]['dailyconfirmed'];
      today_death = widget.list[widget.list.length - 1]['dailydeceased'];
      today_recovered = widget.list[widget.list.length - 1]['dailyrecovered'];
      today_active = (int.parse(today_case) -
              int.parse(today_death) -
              int.parse(today_recovered))
          .toString();
      yesterday_case = widget.list[widget.list.length - 2]['dailyconfirmed'];
      yesterday_death = widget.list[widget.list.length - 2]['dailydeceased'];
      yesterday_recovered =
          widget.list[widget.list.length - 2]['dailyrecovered'];
      yesterday_active = (int.parse(yesterday_case) -
              int.parse(yesterday_death) -
              int.parse(yesterday_recovered))
          .toString();
    });
    print(widget.list[widget.list.length - 2]);
    print(widget.list[widget.list.length - 1]);
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
                _buildStatCard(
                    'Total Cases',
                    show(widget.tabind == 0
                        ? total_case
                        : widget.tabind == 1 ? today_case : yesterday_case),
                    Colors.orange),
                _buildStatCard(
                    'Deaths',
                    show(widget.tabind == 0
                        ? total_death
                        : widget.tabind == 1 ? today_death : yesterday_death),
                    Colors.red),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard(
                    'Recovered',
                    show(widget.tabind == 0
                        ? total_recovered
                        : widget.tabind == 1
                            ? today_recovered
                            : yesterday_recovered),
                    Colors.green),
                _buildStatCard(
                    'Active',
                    show(widget.tabind == 0
                        ? total_active
                        : widget.tabind == 1 ? today_active : yesterday_active),
                    Colors.lightBlue),
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
