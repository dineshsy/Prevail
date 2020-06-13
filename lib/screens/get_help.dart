import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
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
