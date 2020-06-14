import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/modal/get_help_modal.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:dropdownfield/dropdownfield.dart';

class GetHelp extends StatefulWidget {
  final FirebaseUser user;
  GetHelp({this.user});
  @override
  _GetHelpState createState() => _GetHelpState();
}

class _GetHelpState extends State<GetHelp> {
  final _formKey = GlobalKey<FormState>();
  // Map<String, dynamic> formData;
  // List<String> cities = [
  //   'Bangalore',
  //   'Chennai',
  //   'New York',
  //   'Mumbai',
  //   'Delhi',
  //   'Tokyo',
  // ];

  // _ExampleFormState() {
  //   formData = {
  //     'City': 'Bangalore',
  //   };
  // }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),

          // SliverPadding(
          //     padding: const EdgeInsets.all(20.0),
          //     sliver: SliverToBoxAdapter(
          //         child: Container(
          //       color: Colors.white,
          //       constraints: BoxConstraints.expand(),
          //       child: Form(
          //           key: _formKey,
          //           autovalidate: false,
          //           child: SingleChildScrollView(
          //               child: Column(
          //             children: <Widget>[
          //               Divider(
          //                   height: 10.0,
          //                   color: Theme.of(context).primaryColor),
          //               DropDownField(
          //                   value: formData['City'],
          //                   icon: Icon(Icons.location_city),
          //                   required: true,
          //                   hintText: 'Choose a city',
          //                   labelText: 'City *',
          //                   items: cities,
          //                   strict: false,
          //                   setter: (dynamic newValue) {
          //                     formData['City'] = newValue;
          //                   }),
          //               Divider(
          //                   height: 10.0,
          //                   color: Theme.of(context).primaryColor),
          //             ],
          //           ))),
          //     ))),
          SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  maxLines: 8,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enter your text here"),
                ),
              )),
          //         SliverPadding(
          // padding: const EdgeInsets.all(20.0),
          //   sliver: SliverToBoxAdapter(
          //     child: InternationalPhoneNumberInput(
          //           onInputChanged: (PhoneNumber number) {
          //             print(number.phoneNumber);
          //           },
          //           onInputValidated: (bool value) {
          //             print(value);
          //           },
          //           ignoreBlank: false,
          //           autoValidate: false,
          //           selectorTextStyle: TextStyle(color: Colors.black),
          //           initialValue: number,
          //           textFieldController: controller,
          //           inputBorder: OutlineInputBorder(),
          //         ),
          //         RaisedButton(
          //           onPressed: () {
          //             formKey.currentState.validate();
          //           },
          //           child: Text('Validate'),
          //         ),
          //         RaisedButton(
          //           onPressed: () {
          //             getPhoneNumber('+15417543010');
          //           },
          //           child: Text('Update'),
          //         ),
          //   ),
          // )
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
    return first.toString();
  }

  void _submitForm() async {
    String address = await getLocation();
    GetHelpModal getHelpModal = GetHelpModal(
        helpDescription: "from text area",
        helpType: "from dropdown",
        userAddress: address,
        userName: widget.user.displayName,
        userPhone: "from textfield");
    getHelpModal.save();
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Get Help from Gaurdians',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
