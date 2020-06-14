import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
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
      backgroundColor: Palette.primaryColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'PREVAIL',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 7),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(35.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/main.jpg'))),
                ),
              ),
            ),
            new SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverToBoxAdapter(
                  child: FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    onPressed: () => _gSignin(),
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    icon: const Icon(
                      Icons.input,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Continue with Google',
                      style: Styles.buttonTextStyle,
                    ),
                    textColor: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
