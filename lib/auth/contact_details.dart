import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hali_stawi/auth/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactDetailsScreen extends StatefulWidget {
  final residence;
  final fullName;
  final gender;
  final dob;

  ContactDetailsScreen(
    {Key? key,
    @required this.residence,
    @required this.fullName,
    @required this.gender,
    @required this.dob,
    })
    : super(key: key);
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetailsScreen> {
  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  bool authCheckProgress = false;
  String _state = "init";
  int _radioValue1 = 0;
  late bool _password1Visible;
  late bool _password2Visible;

  @override
  void initState() {
    super.initState();
    getLoginStatus();
    _password1Visible = false;
    _password2Visible = false;
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
  final TextEditingController _nationalIDController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future contactDetails() async {
    if(_passwordController.text == _confirmPasswordController.text){
      setState(() {
        _state = "submitted";
      });
      var url = Uri.parse("https://mobilehali.tenwebtechnologies.com/api/patient/create-account");
      var response = await http.post(url, body: {
        "name": widget.fullName,
        "gender": widget.gender,
        "date_of_birth": widget.dob,
        "mobile_number": _phoneNumberController.text,
        "national_id": _nationalIDController.text,
        "location_description": widget.residence,
        "password": _passwordController.text
      });
      var data = json.decode(response.body);
      if (data['message'] == "idexists" || data['message'] == "emailexists") {
        setState(() {
          _state = "init";
        });
        FlutterToast(context).showToast(
          toastDuration: Duration(seconds: 4),
          child: AlertDialog(
            backgroundColor: Color.fromRGBO(247, 247, 247, 1),
            title: Icon(MdiIcons.information,color: Color.fromRGBO(83, 84, 226, 1), size: 40),
            content: Text(
              "Sorry!"+"\n"+"The user email or national ID exists in our servers."+"\n"+"Please use different email/national ID.",
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(fontWeight: FontWeight.w400)
            ),
          )
        );
      } else if(data['message'] == "success") {
        setState((){
          _state = "completed";
        });
        _asyncSuccessConfirmDialog(context);
      } else {
        setState(() {
          _state = "init";
        });
        FlutterToast(context).showToast(
          toastDuration: Duration(seconds: 4),
          child: AlertDialog(
            backgroundColor: Color.fromRGBO(247, 247, 247, 1),
            title: Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 40),
            content: Text(
              "Sorry!" + "\n" + "Registration failed. Please try again.",
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(fontWeight: FontWeight.w400)
            ),
          )
        );
      }
    }else{
      FlutterToast(context).showToast(
        toastDuration: Duration(seconds: 4),
        child: AlertDialog(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1),
          title: Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 40),
          content: Text(
            "Sorry!" + "\n" + "Your password and confirm password do not match.",
            textAlign: TextAlign.center,
            style: GoogleFonts.alata(fontSize:13, fontWeight: FontWeight.w400)
          ),
        )
      );
    }
  }

  Widget formContactDetails() {
    return Form(
      key: this._formKey,
      child: Column(
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
            child: TextFormField(
              focusNode: myFocusNode1,
              controller: _nationalIDController,
              cursorColor: Color.fromRGBO(1, 150, 151, 1),
              style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
              keyboardType: TextInputType.name,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'National ID',
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
                  return 'ID is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height* .02),
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
            child: TextFormField(
              focusNode: myFocusNode2,
              controller: _phoneNumberController,
              cursorColor: Color.fromRGBO(1, 150, 151, 1),
              style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
              keyboardType: TextInputType.name,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'Mobile Number',
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
                  return 'Phone Number is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height* .02),
          Row(
            children: [
              new Expanded(
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_password1Visible,
                    cursorColor: Color.fromRGBO(1, 150, 151, 1),
                    style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Password',
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
                      ),
                      suffixIconConstraints: BoxConstraints(maxWidth: 25),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _password1Visible
                          ? Icons.visibility
                          : Icons.visibility_off,
                          color: Color.fromRGBO(1, 155, 156, 1),
                          size: 16,
                          ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                              _password1Visible = !_password1Visible;
                          });
                        },
                      ),
                      errorStyle: TextStyle(
                        fontSize: 10
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
              SizedBox(width: MediaQuery.of(context).size.width* .035),
              new Expanded(
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_password2Visible,
                    cursorColor: Color.fromRGBO(1, 150, 151, 1),
                    style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: 'Confirm Password',
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
                      ),
                      suffixIconConstraints: BoxConstraints(maxWidth: 25),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _password2Visible
                          ? Icons.visibility
                          : Icons.visibility_off,
                          color: Color.fromRGBO(1, 155, 156, 1),
                          size: 16,
                          ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                              _password2Visible = !_password2Visible;
                          });
                        },
                      ),
                      errorStyle: TextStyle(
                        fontSize: 10
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }

  registerButton() {
    if (_state == "init") {
      return  Text('Register',
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
                          "Contact Information",
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
                        child: formContactDetails()
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .015),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.alata(color:Color.fromRGBO(0, 139, 139, 1),fontSize:11),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'By clicking Register Button you confirm that you have accepted our ',
                                style: GoogleFonts.alata(fontSize:12),
                              ),
                              TextSpan(
                                  text: 'Terms and Conditions',
                                  style: GoogleFonts.alata(color:Color.fromRGBO(1, 155, 156, 1),fontSize:12,fontWeight:FontWeight.w600,decoration:TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                  ..onTap = () {}
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .052),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){},
                            child:Text(
                              "Previous",
                              style: GoogleFonts.alata(
                                color: Color.fromRGBO(1, 155, 156, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.normal
                              )
                            )
                          ),
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
                              child: registerButton(),
                              onPressed: () {
                                if (this._formKey.currentState.validate()) {
                                  contactDetails();
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

  Future _asyncSuccessConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmLoginAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1),
          title: Column(
            children: [
              Icon(MdiIcons.checkAll,color: Color.fromRGBO(1, 150, 151, 1), size: 40),
              SizedBox(height: 10),
              Text(
                'Registration done successfully!',
                textAlign: TextAlign.center,
                style: GoogleFonts.alata(color: Color.fromRGBO(17, 17, 17, 1),fontSize: 14)
              )
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(10),
                color: Color.fromRGBO(237, 237, 237, 1),
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alata(color: Color.fromRGBO(1, 150, 151, 1), fontSize: 10),
                ),
                onPressed: () {
                  setState(() {
                    _state = "init";
                  });
                  Navigator.of(context).pop(ConfirmLoginAction.Cancel);
                },
              ),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                padding: EdgeInsets.all(10),
                color: Color.fromRGBO(1, 150, 151, 1),
                child: Text(
                  'Go to Login',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alata(color: Color.fromRGBO(247, 247, 247, 1), fontSize: 10),
                ),
                onPressed: () {
                  setState(() {
                    _state = "init";
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
              ),
            ],
          )
        );
      },
    );
  }
}
enum ConfirmLoginAction { Accept, Cancel }