import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:flutter_covid_dashboard_ui/widgets/custom_app_bar.dart';
import 'package:flutter_covid_dashboard_ui/screens/volunteer.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNavScreen extends StatefulWidget {
  final FirebaseUser user;
  final Function logout;
  BottomNavScreen({this.user, this.logout});
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  List _screens;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screens = [
      HomeScreen(),
      StatsScreen(),
      GetHelp(user: widget.user),
      Volunteer(
        user: widget.user,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _screens[_currentIndex],
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(color: Palette.primaryColor),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.user.photoUrl)),
                          borderRadius: BorderRadius.circular(200)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        widget.user.displayName,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                )),
            ListTile(title: Center(child: Text(widget.user.email))),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ListTile(
                      title: Center(
                        child: Text("Contributors",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          buildGestureDetector(
                              'https://www.linkedin.com/in/sy-d/', "Dinesh"),
                          buildGestureDetector(
                              'https://www.linkedin.com/in/vasanth-kumar-967810169/',
                              "Vasanth Kumar"),
                          buildGestureDetector(
                              'https://www.linkedin.com/in/hemachandranvk/',
                              "Hemachandran"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border(top: BorderSide(color: Colors.black26))),
                      ),
                    ),
                    ListTile(
                        title: Center(
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        onPressed: () {
                          _launchURL(
                              'https://github.com/VasanthKumar14/PREVAIL-APP');
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        icon: Container(
                            height: 23,
                            child:
                                Image.asset('assets/images/press-release.png')),
                        label: Text(
                          'Updates',
                          style: Styles.buttonTextStyle,
                        ),
                        textColor: Colors.white,
                      ),
                    )),
                    ListTile(
                        title: Center(
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        onPressed: () {
                          widget.logout(
                              context); //On Pressed Event for Call Button
                        },
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        icon: const Icon(
                          Icons.last_page,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Logout',
                          style: Styles.buttonTextStyle,
                        ),
                        textColor: Colors.white,
                      ),
                    ))
                  ],
                )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: [
          Icons.home,
          Icons.insert_chart,
          Icons.event_note,
          Icons.person_pin_circle
        ]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    title: Text(''),
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Colors.blue[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }

  Padding buildGestureDetector(String _url, String _name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _launchURL(_url),
        child: Text(_name,
            style: TextStyle(color: Colors.blueAccent, fontSize: 15)),
      ),
    );
  }

  _launchURL(String _url) async {
    String url = _url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
