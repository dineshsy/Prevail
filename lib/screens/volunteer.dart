import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/modal/new_volunteer.dart';

class Volunteer extends StatefulWidget {
  final FirebaseUser user;
  Volunteer({this.user});
  @override
  _VolunteerState createState() => _VolunteerState();
}

class _VolunteerState extends State<Volunteer> {
  FirebaseDatabase database = new FirebaseDatabase();
  bool isVolunteer = false;
  bool disableButton = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Join the global community to receive Mails on requests we get from help seekers.',
                style: const TextStyle(
                  color: Palette.primaryColor,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(0.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage('assets/images/66152.jpg'))),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(40.0),
            sliver: SliverToBoxAdapter(
                child: FlatButton(
              disabledColor: Colors.blueGrey,
              disabledTextColor: Colors.grey,
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              onPressed: disableButton || isLoading
                  ? null
                  : () {
                      showAlertDialog(context);
                    },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Icon(
                          Icons.flag,
                          color: Colors.white,
                        ),
                  Text(
                    'Join Now',
                    style: Styles.buttonTextStyle,
                  ),
                ],
              ),
              textColor: Colors.white,
            )),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
    this.setState(() {
      isLoading = true;
    });
    await database.reference().child('/volunteers/').once().then((value) {
      Map<dynamic, dynamic> users = value.value;
      if (value.value == null) {
        return null;
      }
      for (MapEntry<dynamic, dynamic> user in users.entries) {
        if (user.value['email'] == widget.user.email) {
          setState(() {
            isVolunteer = true;
            disableButton = true;
            isLoading = false;
          });
          final snackBar =
              SnackBar(content: Text('You are already an volunteer'));

          Scaffold.of(this.context).showSnackBar(snackBar);
          break;
        }
      }
    });
    if (isVolunteer) {
      return;
    }
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
      onPressed: () {
        Navigator.of(context).pop();
        NewVolunteer newVolunteer = NewVolunteer(
            email: widget.user.email, name: widget.user.displayName);
        newVolunteer.save();
        final snackBar =
            SnackBar(content: Text('Congratulations you are a volunteer now '));

        Scaffold.of(this.context).showSnackBar(snackBar);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Would you like to be a volunteer?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Become a Volunteer',
          style: const TextStyle(
            color: Palette.primaryColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
