import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'mySqlExample.dart';

void main() => runApp(SearchableDropdownApp());

class SearchableDropdownApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<SearchableDropdownApp> {
  List _teacherList = [];
  String teacherId;
  String teacherName;

  @override
  void initState() {
    this.fetchTeacherList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Searchable Dropdown Example App'),
              bottom: TabBar(tabs: [
                Tab(text: 'Student Attendance'),
                Tab(text: 'Student Attendance QR'),
              ])),
          body: TabBarView(
            children: [
              new Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 32.0, left: 5.0, right: 5.0),
                    //some padding
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///Dropdown for Teacher List
                          Container(
                            padding: EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 10.0),
                            width: double.infinity,
                            child: getSearchableDropdown(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              new Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSearchableDropdown() {
    return Container(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: new SearchableDropdown(
            items: _teacherList.map((item) {
              return new DropdownMenuItem(
                  child: new Text(
                    item['TeacherName'],
                    //Names that the api dropdown contains
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value:
                      item['TeacherName'].toString()); //TeacherRegistrationID
            }).toList(),
            value: teacherName,
            isCaseSensitiveSearch: false,
            hint: new Text('Select Teacher'),
            isExpanded: true,
            searchHint: new Text(
              'Select Teacher',
              style: new TextStyle(fontSize: 20),
            ),
            onChanged: (value) {
              setState(() {
                teacherName = value;
              });
              getTeacherID();
              //getDataFromMysql();
            },
          ),
        ),
      ),
    );
  }

  Future<String> fetchTeacherList() async {
    var res = await http.get(Uri.parse(
        "http://uniiv.org/api/SelectTeacherList?collegeid=1")); //if you have any auth key place here...properly..
    if (res.statusCode == 200) {
      var resBody = json.decode(res.body);
      setState(() {
        _teacherList = resBody;
      });
    } else {
      setState(() {
        _teacherList = [];
      });
    }
    return "Success";
  }

  getTeacherID() {
    for (var i = 0; i < _teacherList.length; i++) {
      if (teacherName == _teacherList[i]["TeacherName"]) {
        teacherId = _teacherList[i]["TeacherRegistrationID"].toString();
      }
    }
    print('Teacher Name : $teacherName and Teacher ID: teacherId');
  }
}
