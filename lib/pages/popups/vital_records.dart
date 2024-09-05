import 'dart:convert';
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

class VitalRecordsScreen extends StatefulWidget {
  final authToken;
  final national_id;
  final patientName;
  final dob;
  final gender;
  VitalRecordsScreen({Key key, @required this.authToken,@required this.national_id,@required this.patientName,@required this.dob,@required this.gender}):super(key:key);
  @override
  _VitalRecordsScreenState createState() => _VitalRecordsScreenState();
}

class _VitalRecordsScreenState extends State<VitalRecordsScreen>{
  String username;
  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  String _state = "init";

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bloodPressure1Controller = TextEditingController();
  final TextEditingController _bloodPressure2Controller = TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  //
  final TextEditingController _selectMobileNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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
              SizedBox(height: MediaQuery.of(context).size.height* .045),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Record Vitals",
                      style: GoogleFonts.alata(color:Color.fromRGBO(47,47,47, 1),fontSize:15,fontWeight:FontWeight.w500),
                    )
                  ],
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height* .06),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: this._formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Blood Pressure (mmHg)",
                        style: GoogleFonts.alata(
                          color: Color.fromRGBO(1, 155, 156, 1),
                          fontWeight: FontWeight.w300,
                          fontSize: 11
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .02),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Theme(
                              data: Theme.of(context).copyWith(primaryColor: Colors.black),
                              child: TextFormField(
                                controller: _bloodPressure1Controller,
                                cursorColor: Color.fromRGBO(1, 150, 151, 1),
                                style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                                keyboardType: TextInputType.name,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 2),                   
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:BorderSide(color: Color.fromRGBO(223, 223, 223, 1), width: 1.5),
                                  ),
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:BorderSide(color: Color.fromRGBO(223, 223, 223, 1), width: 1.5),
                                  ),
                                )
                              ),
                            )
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width* .015),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "/",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color.fromRGBO(213, 213, 213, 1), fontSize: 16, fontWeight: FontWeight.w900)
                            )
                          ),
                          Expanded(
                            flex: 4,
                            child: Theme(
                              data: Theme.of(context).copyWith(primaryColor: Colors.black),
                              child: TextFormField(
                                controller: _bloodPressure2Controller,
                                cursorColor: Color.fromRGBO(1, 150, 151, 1),
                                style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                                keyboardType: TextInputType.name,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 2), 
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:BorderSide(color: Color.fromRGBO(223, 223, 223, 1), width: 1.5),
                                  ),
                                  border: const UnderlineInputBorder(),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:BorderSide(color: Color.fromRGBO(223, 223, 223, 1), width: 1.5),
                                  ),
                                )
                              ),
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .02),
                      Text(
                        "Blood Sugar (mg/dL)",
                        style: GoogleFonts.alata(
                          color: Color.fromRGBO(1, 155, 156, 1),
                          fontWeight: FontWeight.w300,
                          fontSize: 11
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .02),
                      Theme(
                        data: Theme.of(context).copyWith(primaryColor: Colors.black),
                        child: TextFormField(
                          controller: _bloodSugarController,
                          cursorColor: Color.fromRGBO(1, 150, 151, 1),
                          style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                          keyboardType: TextInputType.name,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 2), 
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:BorderSide(color: Color.fromRGBO(223, 223, 223, 1), width: 1.5),
                            ),
                            border: const UnderlineInputBorder(),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:BorderSide(color: Color.fromRGBO(223, 223, 223, 1), width: 1.5),
                            ),
                          )
                        ),
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height* .04),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.centerRight,
                child: MaterialButton(
                  padding: EdgeInsets.all(10),
                  color: Color.fromRGBO(1, 150, 151, 1),
                  child: testResultsButton(),
                  onPressed: () async {
                    if(_bloodPressure1Controller.text == ''){
                      setState(() {
                        _state = "submitted";
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          _state = "init";
                        });
                      });
                      FlutterToast(context).showToast(
                        toastDuration: Duration(seconds: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color.fromRGBO(247, 247, 247, 1),
                          ),
                          child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 20),
                              SizedBox(
                              width: 12.0,
                              ),
                              Text(
                                "Blood pressure input I is required.",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        gravity: ToastGravity.BOTTOM
                      );
                      return false;
                    }else if(_bloodPressure2Controller.text == ''){
                      setState(() {
                        _state = "submitted";
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          _state = "init";
                        });
                      });
                      FlutterToast(context).showToast(
                        toastDuration: Duration(seconds: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color.fromRGBO(247, 247, 247, 1),
                          ),
                          child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 20),
                              SizedBox(
                              width: 12.0,
                              ),
                              Text(
                                "Blood pressure input II is required.",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        gravity: ToastGravity.BOTTOM
                      );
                      return false;
                    }else if(_bloodSugarController.text == ''){
                      setState(() {
                        _state = "submitted";
                      });
                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          _state = "init";
                        });
                      });
                      FlutterToast(context).showToast(
                        toastDuration: Duration(seconds: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color.fromRGBO(247, 247, 247, 1),
                          ),
                          child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 20),
                              SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                "Blood sugar input is required.",
                                style: TextStyle(fontSize: 12)
                              )
                            ]
                          )
                        ),
                        gravity: ToastGravity.BOTTOM
                      );
                      return false;
                    }else{
                      setState(() {
                        _state = "submitted";
                      });

                      var url = Uri.parse("https://mobilehali.tenwebtechnologies.com/api/patient/mytest");
                      var response = await http.post(url, body: {
                        "national_id": "${widget.national_id}",
                        "name": widget.patientName,
                        "dob": widget.dob,
                        "gender": widget.gender,
                        "bp_up": _bloodPressure1Controller.text,
                        "bp_dn": _bloodPressure2Controller.text,
                        "bloodsugar": _bloodSugarController.text
                      }, headers: {'Authorization': 'Bearer ${widget.authToken}'});
                      var data = json.decode(response.body);
                      // print(data);
                      if (data['message'] == "exists") {
                        setState(() {
                          _state = "init";
                        });
                        FlutterToast(context).showToast(
                          toastDuration: Duration(seconds: 4),
                          child: AlertDialog(
                            backgroundColor: Color.fromRGBO(247, 247, 247, 1),
                            title: Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 40),
                            content: Text(
                              "Sorry!" + "\n" + "There's more than one user account registered with your phone number.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.alata(fontWeight: FontWeight.w400)
                            ),
                          )
                        );
                      } else if(data['message'] == "nofund") {
                        setState(() {
                          _state = "init";
                        });
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button for close dialog!
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Color.fromRGBO(247, 247, 247, 1),
                                  title: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      children: [
                                        SizedBox(height: MediaQuery.of(context).size.height* .02),
                                        Text(
                                          'Request Payment',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.alata(color: Color.fromRGBO(17, 17, 17, 1),fontSize: 14)
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height* .02),
                                        Form(
                                          child: Column(
                                            children: <Widget>[
                                              Theme(
                                                data: Theme.of(context).copyWith(primaryColor: Colors.black),
                                                child: TextFormField(
                                                  controller: _selectMobileNumberController,
                                                  cursorColor: Color.fromRGBO(1, 150, 151, 1),
                                                  style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                                                  keyboardType: TextInputType.name,
                                                  textAlign: TextAlign.start,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.zero,
                                                    labelText: 'Select Mobile Number',
                                                    enabledBorder: const UnderlineInputBorder(
                                                      borderSide:BorderSide(color: Color.fromRGBO(233, 233, 233, 1), width: 1),
                                                    ),
                                                    border: const UnderlineInputBorder(),
                                                    labelStyle: GoogleFonts.alata(
                                                      color: Color.fromRGBO(1, 155, 156, 1),
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 12
                                                    ),
                                                    focusedBorder: const UnderlineInputBorder(
                                                      borderSide:BorderSide(color: Color.fromRGBO(233, 233, 233, 1), width: 1),
                                                    )
                                                  )
                                                )
                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height* .02),
                                              Theme(
                                                data: Theme.of(context).copyWith(primaryColor: Colors.black),
                                                child: TextFormField(
                                                  controller: _phoneNumberController,
                                                  cursorColor: Color.fromRGBO(1, 150, 151, 1),
                                                  keyboardType: TextInputType.name,
                                                  style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                                                  textAlign: TextAlign.start,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.zero,
                                                    labelText: 'Phone Number',
                                                    enabledBorder: const UnderlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(color: Color.fromRGBO(233, 233, 233, 1), width: 1),
                                                    ),
                                                    border: const UnderlineInputBorder(),
                                                    labelStyle: GoogleFonts.alata(
                                                        color: Color.fromRGBO(1, 155, 156, 1),
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 12),
                                                    focusedBorder: const UnderlineInputBorder(
                                                      borderSide:BorderSide(color: Color.fromRGBO(233, 233, 233, 1), width: 1),
                                                    )
                                                  )
                                                )
                                              )
                                            ]
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      MaterialButton(
                                        padding: EdgeInsets.all(10),
                                        color: Color.fromRGBO(237, 237, 237, 1),
                                        child: Text(
                                          'Cancel',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.alata(color: Color.fromRGBO(1, 150, 151, 1), fontSize: 10),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      MaterialButton(
                                        padding: EdgeInsets.all(10),
                                        color: Color.fromRGBO(1, 150, 151, 1),
                                        child: requestPaymentButton(),
                                        onPressed: () async {
                                          if(_selectMobileNumberController.text == ''){
                                            setState(() {
                                              _state = "submitted";
                                            });
                                            Future.delayed(Duration(milliseconds: 300), () {
                                              setState(() {
                                                _state = "init";
                                              });
                                            });
                                            FlutterToast(context).showToast(
                                              toastDuration: Duration(seconds: 4),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                                decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.0),
                                                color: Color.fromRGBO(247, 247, 247, 1),
                                                ),
                                                child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 20),
                                                    SizedBox(
                                                    width: 12.0,
                                                    ),
                                                    Text(
                                                      "Mobile number is required.",
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              gravity: ToastGravity.BOTTOM
                                            );
                                            return false;
                                          }else if(_phoneNumberController.text == ''){
                                            setState(() {
                                              _state = "submitted";
                                            });
                                            Future.delayed(Duration(milliseconds: 300), () {
                                              setState(() {
                                                _state = "init";
                                              });
                                            });
                                            FlutterToast(context).showToast(
                                              toastDuration: Duration(seconds: 4),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                                decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.0),
                                                color: Color.fromRGBO(247, 247, 247, 1),
                                                ),
                                                child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 20),
                                                    SizedBox(
                                                      width: 12.0,
                                                    ),
                                                    Text(
                                                      "Phone number is required.",
                                                      style: TextStyle(fontSize: 12)
                                                    )
                                                  ]
                                                )
                                              ),
                                              gravity: ToastGravity.BOTTOM
                                            );
                                            return false;
                                          }else{
                                            setState(() {
                                              _state = "submitted";
                                            });
                                          }
                                        }, 
                                      ),
                                    ],
                                  )
                                );
                              }
                            );
                          },
                        );
                      }
                    }
                  }, 
                )
              )
            ]
          ));
        }),
      )
    );
  }

  testResultsButton() {
    if (_state == "init") {
      return  Text(
        'Save Record',
        textAlign: TextAlign.center,
        style: GoogleFonts.alata(color: Color.fromRGBO(247, 247, 247, 1), fontSize: 10),
      );
    } else if (_state == "submitted") {
      return SizedBox(
        child:CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Color.fromRGBO(172, 173, 189, 1)),
          strokeWidth: 1.5,
        ),
        height: 12,
        width: 12,
      );
    } else if (_state == "completed")  {
      return Icon(
        MdiIcons.checkCircle, size: 16, color: Colors.white
      );
    }
  }

  requestPaymentButton() {
    if (_state == "init") {
      return  Text(
        'Send Request',
        textAlign: TextAlign.center,
        style: GoogleFonts.alata(color: Color.fromRGBO(247, 247, 247, 1), fontSize: 10),
      );
    } else if (_state == "submitted") {
      return SizedBox(
        child:CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Color.fromRGBO(172, 173, 189, 1)),
          strokeWidth: 1.5,
        ),
        height: 12,
        width: 12,
      );
    } else if (_state == "completed")  {
      return Icon(
        MdiIcons.checkCircle, size: 16, color: Colors.white
      );
    }
  }
}