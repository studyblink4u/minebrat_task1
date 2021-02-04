import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minebrat_task1/display_details.dart';
import 'package:minebrat_task1/state_object.dart';

class CitySelect extends StatefulWidget {
  final String id;
  final String stateName;
  final String userName;

  CitySelect({this.id, this.stateName, this.userName});
  @override
  _CitySelectState createState() => _CitySelectState();
}

class _CitySelectState extends State<CitySelect> {
  bool loading;
  bool status;
  List<CityObject> cities = [];
  final searchController = TextEditingController();
  List<CityObject> searchedCities = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    status = false;
    fetchCities();
    searchController.addListener(_searchList);
  }

  _searchList() {
    String searchString = searchController.text;
    List<CityObject> matchedCities = [];
    for (var city in cities) {
      if (city.cityName.toLowerCase().contains(searchString.toLowerCase())) {
        matchedCities.add(city);
      }
    }
    setState(() {
      searchedCities = matchedCities;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  void fetchCities() async {
    await http
        .get('http://api.minebrat.com/api/v1/states/cities/${widget.id}')
        .then((value) {
      List holdCity = json.decode(value.body);
      holdCity.forEach((element) {
        cities.add(
            CityObject(id: element["cityId"], cityName: element["cityName"]));
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
                  hintText: 'Enter the city name',
                  labelText: 'City Name',
                ),
                controller: searchController,
              ),
            ),
            searchedCities.length > 0
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var city in searchedCities)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DisplayDetails(
                                        name: widget.userName,
                                        cityName: city.cityName,
                                        stateName: widget.stateName,
                                      )));
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
                                child: Center(child: Text(city.cityName))),
                          )
                      ],
                    ),
                  )
                : Container(),
            !loading
                ? status
                    ? Expanded(
                        child: GridView.builder(
                          itemCount: cities.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 1.5),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DisplayDetails(
                                          name: widget.userName,
                                          cityName: cities[index].cityName,
                                          stateName: widget.stateName,
                                        )));
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
                                      child: Text(cities[index].cityName))),
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
