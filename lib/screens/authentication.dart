import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/screens/bottom_nav_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  Future<FirebaseUser> _gSignin() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavScreen(
              user: user,
              logout: _logout,
            )));

    return user;
  }

  _logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    _googleSignIn.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => Authentication()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text("Google-Sign-in"),
              onPressed: () => _gSignin(),
              color: Colors.red,
            ),
          ),
        ],
      ),
    ));
  }
}
