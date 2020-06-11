import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallModal extends StatefulWidget {
  final String number;

  const CallModal({
    @required this.number
  });

  @override
  _CallModalState createState() => _CallModalState();
}

class _CallModalState extends State<CallModal> {

  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(70),
          onTap: () => setState(() {
            _launched = _makePhoneCall('tel:${widget.number}');
          }),
          child: Container(
            width: 200,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 15.0),
              child: Text(
                widget.number,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
    );
  }
}
