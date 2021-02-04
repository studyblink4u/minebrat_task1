import 'package:flutter/material.dart';

class DisplayDetails extends StatelessWidget {
  final String name;
  final String stateName;
  final String cityName;

  DisplayDetails({this.name, this.stateName, this.cityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10.0,
        shadowColor: Colors.white,
        title: Text('Minebrat'),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        color: Colors.black,
        child: Center(
          child: Text(
            'Dear Mr/Ms ${name.toUpperCase()}, you are from $cityName in $stateName, India.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontSize: 15.0),
          ),
        ),
      ),
    );
  }
}
