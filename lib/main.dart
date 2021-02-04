import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:minebrat_task1/state_select.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String name = '';
  // ToggleButton requires a list of bool for its children.
  // list in the order of [female,male,others]
  List<bool> gender = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10.0,
        shadowColor: Colors.white,
        title: Text('Minebrat'),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.all(15.0),
            constraints: BoxConstraints(maxWidth: 450.0, minHeight: 250.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 15.0,
                  spreadRadius: 15.0,
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'Enter your name',
                      labelText: 'Name:'),
                  onChanged: (inputName) {
                    name = inputName;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                ToggleButtons(
                    children: <Widget>[
                      Icon(MdiIcons.humanFemale),
                      Icon(MdiIcons.humanMale),
                      Icon(MdiIcons.genderTransgender),
                    ],
                    onPressed: (int selectedIndex) {
                      setState(() {
                        for (int index = 0; index < gender.length; index++) {
                          if (selectedIndex == index) {
                            gender[index] = true;
                          } else {
                            gender[index] = false;
                          }
                        }
                      });
                    },
                    isSelected: gender),
                SizedBox(
                  height: 15.0,
                ),
                InkWell(
                  onTap: () {
                    if (gender.contains(true) && name.length > 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StateSelect(name)));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'Enter your name or Select atleast one gender')));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
