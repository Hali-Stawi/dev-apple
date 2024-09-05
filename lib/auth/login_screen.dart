import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hali_stawi/auth/personal_details.dart';
import 'package:hali_stawi/pages/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignInScreen> {
  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNodePassword = new FocusNode();
  bool _passwordVisible;
  bool authCheckProgress = false;
  String _state = "init";

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    getLoginStatus();
  }

  getLoginStatus() async {
    setState(() {
      authCheckProgress = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String patientName = prefs.getString('patientName');
    int patientId = prefs.getInt('patientId');
    String authToken = prefs.getString('authToken');
    int national_id = prefs.getInt('nationalId');
    String dob = prefs.getString('dob');
    String gender = prefs.getString('gender');

    if (patientName == null) {
      setState(() {
        authCheckProgress = false;
      });
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
      HomeScreen(
        authToken: authToken,
        national_id: national_id,
        dob: dob,
        gender: gender
      )));
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signIn() async {
    setState(() {
      _state = "submitted";
    });
    var url = Uri.parse("https://mobilehali.tenwebtechnologies.com/api/patient/signin");
    var response = await http.post(url, body: {
      "national_id": _nationalIdController.text,
      "password": _passwordController.text,
    });
    var data = json.decode(response.body);
    // print(data["token"]);
    if (data['status_code'] == "400") {
      FlutterToast(context).showToast(
        toastDuration: Duration(seconds: 4),
        child: AlertDialog(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1),
          title: Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 40),
          content: Text(
            "Sorry!" + "\n" + "Wrong Username/Password. Please try again.",
            textAlign: TextAlign.center,
            style: GoogleFonts.alata(fontWeight: FontWeight.w400)
          ),
        )
      );
      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    } else if (data['status_code'] == "200") {
      setState((){
        _state = "completed";
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', data['token']);
      prefs.setInt('patientId', data['user']['id']);
      prefs.setString('patientName', data['user']['name']);
      prefs.setString('dob', data['user']['date_of_birth']);
      prefs.setString('gender', data['user']['gender']);
      prefs.setInt('nationalId', data['user']['national_id']);
      prefs.setString('phone', data['user']['mobile_number']);
      prefs.setString('role', data['user']['role']);

      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeScreen(
            authToken: data['token'],
            national_id: data['user']['national_id'],
            dob: data['user']['date_of_birth'],
            gender: data['user']['gender']
          )
        ));
      });
    } else {
      FlutterToast(context).showToast(
        toastDuration: Duration(seconds: 4),
        child: AlertDialog(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1),
          title: Icon(MdiIcons.alertCircle,color: Color.fromRGBO(199, 0, 57, 1), size: 40),
          content: Text(
            "Sorry!" + "\n" + "The login credentials do not exist in our servers.",
            textAlign: TextAlign.center,
            style: GoogleFonts.alata(fontSize:13, fontWeight: FontWeight.w400)
          ),
        )
      );
      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    }
  }

  Widget formLogin() {
    return Form(
      key: this._formKey,
      child: Column(
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
            child: TextFormField(
              focusNode: myFocusNode,
              controller: _nationalIdController,
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
              focusNode: myFocusNodePassword,
              controller: _passwordController,
              cursorColor: Color.fromRGBO(1, 150, 151, 1),
              obscureText: !_passwordVisible,
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
                    _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                    color: Color.fromRGBO(1, 155, 156, 1),
                    size: 16,
                    ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                        _passwordVisible = !_passwordVisible;
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
          ),
        ],
      ),
    );
  }

  loginButton() {
    if (_state == "init") {
      return  Text('Login',
        style: GoogleFonts.alata(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.normal
        )
      );
    } else if (_state == "submitted") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,  //Center Column contents horizontally,
        children: [
          Text(
            "Loading...",
            style: GoogleFonts.alata(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w400
            ),
          ),
          SizedBox(width: 10,),
          SizedBox(
            child:CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Color.fromRGBO(172, 173, 189, 1)),
              strokeWidth: 1.5,
            ),
            height: 13,
            width: 13,
          )
        ]
      );
    } else if (_state == "completed")  {
      return Icon(
        MdiIcons.checkCircle, size: 20, color: Colors.white
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
                  padding: const EdgeInsets.all(30),
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
                    scale: 9,
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
                          "Login",
                          style: GoogleFonts.alata(
                            color: Color.fromRGBO(0, 150, 151, 1),
                            fontSize: 23,
                            fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .015),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: formLogin()
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.alata(
                                  fontSize: 12.0,
                                  color: Color.fromRGBO(0, 139, 139, 1),
                                  // decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .052),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color.fromRGBO(1, 170, 171, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5) //                 <--- border radius here
                          ),
                        ),
                        child:MaterialButton(
                          child: loginButton(),
                          onPressed: () {
                            if (this._formKey.currentState.validate()) {
                              signIn();
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
                      SizedBox(height: MediaQuery.of(context).size.height* .05),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider()
                          ),   
                          SizedBox(width: 5),
                          Text(
                            "OR", 
                            style: GoogleFonts.alata(color:Color.fromRGBO(1, 150, 151, 1),fontSize:12),
                          ),  
                          SizedBox(width: 5), 
                          Expanded(
                            child: Divider()
                          ),
                        ]
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .04),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.alata(color:Color.fromRGBO(0, 139, 139, 1),fontSize:11),
                            children: <TextSpan>[
                              TextSpan(text: 'New to HaliStawi? '),
                              TextSpan(
                                  text: ' Register',
                                  style: GoogleFonts.alata(color:Color.fromRGBO(1, 150, 151, 1),fontSize:11),
                                  recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context,
                                      MaterialPageRoute(
                                      builder: (context) =>PersonalDetailsScreen()));
                                  }
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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