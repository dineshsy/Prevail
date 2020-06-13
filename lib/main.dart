import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/screens/authentication.dart';
import 'package:flutter_covid_dashboard_ui/screens/bottom_nav_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool auth = prefs.getBool('auth');
  bool isAuthenticated = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  if (auth == true) {
    isAuthenticated = true;
    user = await _auth.currentUser();
    print(user.email);
  }
  runApp(isAuthenticated
      ? MyApp(
          isAuthenticated: isAuthenticated,
          user: user,
        )
      : MyApp(
          isAuthenticated: isAuthenticated,
        ));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final FirebaseUser user;

  MyApp({@required this.isAuthenticated, this.user});

  _logout(context) async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    _googleSignIn.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => Authentication()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Covid-19 Dashboard UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isAuthenticated
          ? BottomNavScreen(
              user: user,
              logout: _logout,
            )
          : Authentication(),
    );
  }
}
