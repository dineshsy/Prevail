import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/widgets/statewise_covid_bar_chart.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final String apiUrl = "https://api.covid19india.org/data.json";

  List lis;
  var tabIndex = 0;
  static Future<List<dynamic>> fetchUsers(url) async {
    var result = await http.get(url);
    return json.decode(result.body)['cases_time_series'];
  }

  void fetchingdata() async {
    var list = await fetchUsers(apiUrl);
    if (this.mounted) {
      setState(() {
        lis = list;
      });
    }
    // print(lis);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchingdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          // _buildRegionTabBar(),
          _buildStatsTabBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: lis == null
                  ? Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()))
                  : StatsGrid(list: lis, tabind: tabIndex),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: StateWiseCovidBar(),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Statistics of India',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // SliverToBoxAdapter _buildRegionTabBar() {
  //   return SliverToBoxAdapter(
  //     child: DefaultTabController(
  //       length: 2,
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 20.0),
  //         height: 50.0,
  //         decoration: BoxDecoration(
  //           color: Colors.white24,
  //           borderRadius: BorderRadius.circular(25.0),
  //         ),
  //         child: TabBar(
  //           indicator: BubbleTabIndicator(
  //             tabBarIndicatorSize: TabBarIndicatorSize.tab,
  //             indicatorHeight: 40.0,
  //             indicatorColor: Colors.white,
  //           ),
  //           labelStyle: Styles.tabTextStyle,
  //           labelColor: Colors.black,
  //           unselectedLabelColor: Colors.white,
  //           tabs: <Widget>[
  //             Text('My Country'),
  //             Text('Global'),
  //           ],
  //           onTap: (index) {},
  //         ),
  //       ),
  //     ),
  //   );
  // }

  SliverPadding _buildStatsTabBar() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: 3,
          child: Center(
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelStyle: Styles.tabTextStyle,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: <Widget>[
                Text('Total'),
                Text('Today'),
                Text('Yesterday'),
              ],
              onTap: (index) {
                setState(() {
                  tabIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
