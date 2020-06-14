import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';

class Volunteer extends StatefulWidget {
  @override
  _VolunteerState createState() => _VolunteerState();
}

class _VolunteerState extends State<Volunteer> {
  String email = null;
  // https://pub.dev/packages/email_validator#-example-tab- validate user email
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/66152.jpg'))),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            controller: myController,
            style: TextStyle(
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              hintText: "hint",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              // prefixIcon: Padding(
              //    IconTheme(
              //     data: IconThemeData(color: Theme.of(context).primaryColor),
              //     // child: ic,
              //   ),
              //   padding: EdgeInsets.only(left: 30, right: 10),
              // )
            ),
          ),
        )
      ],
    );
  }
}
