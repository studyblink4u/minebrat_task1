import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minebrat_task1/city_select.dart';
import 'dart:convert';

import 'package:minebrat_task1/state_object.dart';

class StateSelect extends StatefulWidget {
  final String name;

  StateSelect(this.name);
  @override
  _StateSelectState createState() => _StateSelectState();
}

class _StateSelectState extends State<StateSelect> {
  List<StateObject> states = [];
  bool loading;
  bool status;
  final searchController = TextEditingController();

  List<StateObject> searchedStates = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    status = false;
    fetchState();
    searchController.addListener(_searchList);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  _searchList() {
    String searchString = searchController.text;
    List<StateObject> matchedStates = [];
    if (searchString.length > 0) {
      for (var state in states) {
        if (state.stateName
            .toLowerCase()
            .contains(searchString.toLowerCase())) {
          matchedStates.add(state);
        }
      }
    }
    setState(() {
      searchedStates = matchedStates;
    });
  }

  void fetchState() async {
    await http.get('http://api.minebrat.com/api/v1/states').then((value) {
      List holdStates = json.decode(value.body);
      holdStates.forEach((element) {
        states.add(StateObject(
            id: element["stateId"], stateName: element["stateName"]));
      });
      setState(() {
        status = true;
        loading = false;
      });
    }).catchError((error) {
      setState(() {
        status = false;
        loading = false;
      });
    });
  }

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
        color: Colors.black,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: 'Enter the state name',
                  labelText: 'State Name',
                ),
                controller: searchController,
              ),
            ),
            searchedStates.length > 0
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var state in searchedStates)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CitySelect(
                                  id: state.id,
                                  stateName: state.stateName,
                                  userName: widget.name,
                                ),
                              ));
                            },
                            child: Container(
                                padding: EdgeInsets.all(15.0),
                                margin: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 7.0,
                                        spreadRadius: 7.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: Center(child: Text(state.stateName))),
                          )
                      ],
                    ),
                  )
                : Container(),
            !loading
                ? status
                    ? Expanded(
                        child: GridView.builder(
                          itemCount: states.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 1.7),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CitySelect(
                                    id: states[index].id,
                                    stateName: states[index].stateName,
                                    userName: widget.name,
                                  ),
                                ));
                              },
                              child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  margin: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 7.0,
                                          spreadRadius: 7.0,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  child: Center(
                                      child: Text(states[index].stateName))),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          'Oops!!! Something went wrong',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
