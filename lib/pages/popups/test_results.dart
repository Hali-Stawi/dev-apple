import 'dart:convert';
import 'package:hali_stawi/pages/popups/vital_records.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hali_stawi/pages/home_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:strings/strings.dart';

class TestResultsScreen extends StatefulWidget {
  final authToken;
  final national_id;
  final patientName;
  final dob;
  final gender;
  TestResultsScreen({Key key, @required this.authToken,@required this.national_id,@required this.patientName,@required this.dob,@required this.gender}):super(key:key);
  @override
  _TestResultsScreenState createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen>{
  String username;
  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  userDetails() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   username = prefs.getString('username');
    // });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color.fromRGBO(1, 150, 151, 1),
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color.fromRGBO(1, 150, 151, 1),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 15,
            ),
            InkWell(
              child: Image.asset(
                'assets/right-arrow.png',
                scale: 22,
                color: Color.fromRGBO(47,47,47, 1),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(top:15,right:15),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${capitalize(widget.patientName.toLowerCase())}",
                  style: GoogleFonts.alata(color:Color.fromRGBO(47,47,47, 1),fontSize:13,fontWeight:FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.of(context).size.height* .003),
                Text(
                  "${widget.national_id}",
                  style: GoogleFonts.alata(color:Color.fromRGBO(1, 150, 151, 1),fontSize:12,fontWeight:FontWeight.w600),
                ),
              ],
            )
          )
        ],
      ),
      body: Container(
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height* .025),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Test Results",
                      style: GoogleFonts.alata(color:Color.fromRGBO(47,47,47, 1),fontSize:13,fontWeight:FontWeight.w500),
                    ),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(2, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/add.png',
                          color: Color.fromRGBO(0, 150, 151, 1),
                          scale: 30,
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(
                          builder: (context) =>VitalRecordsScreen(
                            authToken: widget.authToken,
                            national_id: widget.national_id,
                            patientName: widget.patientName,
                            dob: widget.dob,
                            gender: widget.gender
                          )
                        ));
                      }
                    )
                  ],
                )
              )
            ]
          ));
        }),
      )
    );
  }
}