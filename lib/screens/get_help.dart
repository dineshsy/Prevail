import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/modal/get_help_modal.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class GetHelp extends StatefulWidget {
  final FirebaseUser user;
  GetHelp({this.user});
  @override
  _GetHelpState createState() => _GetHelpState();
}

class _GetHelpState extends State<GetHelp> {
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();

  String dropdownText = "Medical";

  @override
  void dispose() {
    controllerDescription?.dispose();
    controllerPhone?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverToBoxAdapter(
                  child: Form(
                      key: _formKey,
                      autovalidate: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    child: Text(
                                      'I need help in',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  CountryDropdown(
                                      countries: [
                                        "Medical",
                                        "Food",
                                        "Shelter",
                                        "Other"
                                      ],
                                      country: dropdownText,
                                      onChanged: (String value) {
                                        setState(() {
                                          dropdownText = value;
                                        });
                                      }),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a description';
                                  }
                                  return null;
                                },
                                controller: controllerDescription,
                                maxLines: 4,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: "Enter your text here",
                                    labelText: 'Describe your needs here',
                                    labelStyle: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide phone number';
                                }
                                if (value.length != 10) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                              controller: controllerPhone,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: "Your 10 digit mobile number",
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                          )
                        ],
                      )))),
          SliverPadding(
            padding: EdgeInsets.only(left: 100, right: 100),
            sliver: SliverToBoxAdapter(
              child: FlatButton.icon(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                onPressed: () {
                  _submitForm();
                },
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                icon: const Icon(
                  Icons.done,
                  color: Colors.blue,
                ),
                label: Text(
                  'Sumbit',
                  style: Styles.buttonTextStyle,
                ),
                textColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(first.addressLine);
    return first.addressLine;
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      String address = await getLocation();
      GetHelpModal getHelpModal = GetHelpModal(
          helpDescription: controllerDescription.text,
          helpType: dropdownText,
          userAddress: address,
          userName: widget.user.displayName,
          userPhone: controllerPhone.text);
      getHelpModal.save();
    }
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Get Help from Gaurdians',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/love.png'))),
            )
          ],
        ),
      ),
    );
  }
}
