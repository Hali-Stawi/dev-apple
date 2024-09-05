import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hali_stawi/auth/contact_details.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailsScreen extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetailsScreen> {
  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  bool authCheckProgress = false;
  String _state = "init";
  int _radioValue1 = 0;
  String _gender;

  @override
  void initState() {
    super.initState();
    getLoginStatus();
  }

  void _handleRadioValueChange1(value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  getLoginStatus() async {
    setState(() {
      authCheckProgress = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    int userId = prefs.getInt('id');

    if (username == null) {
      setState(() {
        authCheckProgress = false;
      });
    } else {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
      // SummaryPageScreen(userId: userId)));
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController dateSet = TextEditingController();

  Future personalDetails() async {
    setState(() {
      _state = "submitted";
    });
    _radioValue1 == 0
      ? setState(() => _gender = "Male")
      : setState(() => _gender = "Female");
    var correctDate = dateSet.text.substring(0, dateSet.text.length - 13); //2022-07-01 00:00:00.000

    Future.delayed(Duration(milliseconds: 500), () {
      setState((){
        _state = "completed";
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactDetailsScreen(
            residence: _residenceController.text,
            fullName: _fullNameController.text,
            gender: _gender,
            dob: correctDate
          )
        )
      );
    });
  }

  Widget formPersonalDetails() {
    return Form(
      key: this._formKey,
      child: Column(
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
            child: TextFormField(
              focusNode: myFocusNode1,
              controller: _residenceController,
              cursorColor: Color.fromRGBO(1, 150, 151, 1),
              style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
              keyboardType: TextInputType.name,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'Residence Area',
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
                ),
                errorStyle: TextStyle(
                  fontSize: 10
                )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Residence area is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height* .015),
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
            child: TextFormField(
              focusNode: myFocusNode2,
              controller: _fullNameController,
              cursorColor: Color.fromRGBO(1, 150, 151, 1),
              style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
              keyboardType: TextInputType.name,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'Full Name',
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
                ),
                errorStyle: TextStyle(
                  fontSize: 10
                )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height* .015),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text('Gender',
                  style:
                      GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 12)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width* .045,
                    child: Radio(
                      value: 0,
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                      activeColor: Color.fromRGBO(1, 150, 151, 1),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  new Text(
                    'Male',
                    style: GoogleFonts.alata(color:Color.fromRGBO(0, 139, 139, 1),fontSize: 12),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width* .045,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width* .045,
                    child: Radio(
                      value: 1,
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange1,
                      activeColor: Color.fromRGBO(1, 150, 151, 1),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  new Text(
                    'Female',
                    style: GoogleFonts.alata(
                      color:Color.fromRGBO(0, 139, 139, 1),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height* .015),
          TextFormField(
            controller: dateSet,
            keyboardType: TextInputType.datetime,
            style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelText: 'Date of Birth',
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
              ),
              errorStyle: TextStyle(
                fontSize: 10
              )
            ),
            onTap: () async {
              DateTime date = DateTime(1900);
              FocusScope.of(context).requestFocus(new FocusNode());
              date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: Colors.white,
                        onPrimary: Color.fromRGBO(0, 126, 126, 1),
                        surface: Color.fromRGBO(0, 126, 126, 1),
                        onSurface: Colors.white
                      ),
                      dialogBackgroundColor:Color.fromRGBO(0, 126, 126, 1)
                    ),
                    
                    child: child,
                  );
                },
              );
              dateSet.text = date.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'DOB is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  proceedButton() {
    if (_state == "init") {
      return  Text('Proceed',
        style: GoogleFonts.alata(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.normal
        )
      );
    } else if (_state == "submitted") {
      return SizedBox(
        child:CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Color.fromRGBO(172, 173, 189, 1)),
          strokeWidth: 1.5,
        ),
        height: 14,
        width: 14,
      );
    } else if (_state == "completed")  {
      return Icon(
        MdiIcons.checkCircle, size: 18, color: Colors.white
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return authCheckProgress ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: new BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Image.asset(
                'assets/halistawi_logo.png',
                scale: 1.7,
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ) : Scaffold(
      // backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0), // here the desired height
        child: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromRGBO(1, 150, 151, 1),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Color.fromRGBO(1, 150, 151, 1),
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
        )
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height* .07),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(8, 11), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/hali_stawi.png',
                    scale: 15,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height* .05),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal:25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child:Text(
                          "Sign up",
                          style: GoogleFonts.alata(
                            color: Color.fromRGBO(0, 150, 151, 1),
                            fontSize: 23,
                            fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .01),
                      Container(
                        alignment: Alignment.centerLeft,
                        child:Text(
                          "Personal Information",
                          style: GoogleFonts.alata(
                            color: Color.fromRGBO(0, 150, 151, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .015),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: formPersonalDetails()
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .052),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width* .29,
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color.fromRGBO(1, 170, 171, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5) //                 <--- border radius here
                              ),
                            ),
                            child:MaterialButton(
                              child: proceedButton(),
                              onPressed: () {
                                if (this._formKey.currentState.validate()) {
                                  personalDetails();
                                }else{
                                  setState(() {
                                    _state = "submitted";
                                  });
                                  Future.delayed(Duration(milliseconds: 300), () {
                                    setState(() {
                                      _state = "init";
                                    });
                                  });
                                }
                              },
                            )
                          ),
                        ]
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .05),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}