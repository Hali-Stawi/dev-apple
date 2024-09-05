import 'dart:convert';
import 'package:hali_stawi/blocs/dependents_bloc.dart';
import 'package:hali_stawi/model/dependents_model.dart';
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

class DependentsScreen extends StatefulWidget {
  final authToken;
  final national_id;
  DependentsScreen({Key key, @required this.authToken,@required this.national_id}):super(key:key);
  @override
  _DependentsScreenState createState() => _DependentsScreenState();
}

class _DependentsScreenState extends State<DependentsScreen>{
  String patientName;
  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  int _radioValue1 = 0;
  String _gender;
  Object valueChoose = "Husband";
  String _state = "init";

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  void _handleRadioValueChange1(value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  List relative = [
    "Husband",
    "Wife",
    "Child",
    "Father",
    "Mother",
    "Brother",
    "Sister"
  ];

  userDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      patientName = prefs.getString('patientName');
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController dateSet = TextEditingController();

  //func

  Widget build(BuildContext context) {
    dependentsBloc.fetchDependents("${widget.national_id}", "${widget.authToken}");
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
              width: 10,
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
            padding: EdgeInsets.only(top:15,right:10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${capitalize(patientName.toLowerCase())}",
                  style: GoogleFonts.alata(color:Color.fromRGBO(47,47,47, 1),fontSize:13,fontWeight:FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.of(context).size.height* .003),
                Text(
                  widget.national_id,
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Family Members",
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
                        dependantsFormDialog(context);
                      }
                    )
                  ],
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height* .025),
              StreamBuilder(
                stream: dependentsBloc.dependents,
                builder: (context, AsyncSnapshot<List<DependentsModel>> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.length < 1 ? Container(height: 0, width: 0)
                    : MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children:[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(247, 247, 247, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/patient.png',
                                              scale: 30,
                                              color: Color.fromRGBO(1, 150, 151, 1),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${capitalize(snapshot.data[index].name.toLowerCase())}",
                                              style: GoogleFonts.alata(fontSize: 13, fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                        Text(
                                          snapshot.data[index].date_of_birth,
                                          style: GoogleFonts.alata(
                                              fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 11),
                                child:Divider(
                                  color: Color.fromRGBO(1, 215, 216, 1)
                                )
                              ),
                            ],
                          );
                        },
                        itemCount: snapshot.data.length,
                      )
                    );
                  }
                  else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } 
                  else {
                    return MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, position) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            height: MediaQuery.of(context).size.height * .08,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal:21),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Shimmer.fromColors(
                                  baseColor: Color.fromRGBO(247, 247, 247, 1),
                                  highlightColor:Colors.white,
                                  direction: ShimmerDirection.ltr,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * .013,
                                    width: MediaQuery.of(context).size.width * .28,
                                    decoration: BoxDecoration(
                                      color:Color.fromRGBO(247, 247, 247, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  )
                                ),
                                Shimmer.fromColors(
                                  baseColor: Color.fromRGBO(247, 247, 247, 1),
                                  highlightColor:Colors.white,
                                  direction: ShimmerDirection.ltr,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * .013,
                                    width: MediaQuery.of(context).size.width * .12,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(247, 247, 247, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    )
                                  )
                                )
                              ]
                            )
                          );
                        },
                        itemCount: 8,
                      )
                    );
                  }
                }
              )
            ]
          ));
        }),
      )
    );
  }

  dependantsButton() {
    if (_state == "init") {
      return  Text(
        'Submit',
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

  Future dependantsFormDialog(BuildContext context) async {
    return showDialog<ConfirmDependantsAction>(
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
                      'Add Dependent',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alata(color: Color.fromRGBO(17, 17, 17, 1),fontSize: 14)
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height* .02),
                    Form(
                      key: this._formKey,
                      child: Column(
                        children: <Widget>[
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
                                errorStyle: GoogleFonts.alata(
                                  fontSize: 10
                                )
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height* .02),
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
                              errorStyle: GoogleFonts.alata(
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
                                      // textSelectionTheme: TextSelectionThemeData(
                                      //   style: TextSelection.(
                                      //     primary: Colors.white,
                                      //     onSurface: Color.fromRGBO(0, 126, 126, 1),
                                      //     backgroundColor: Colors.blue,
                                      //   ),
                                      // ),
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
                          SizedBox(height: MediaQuery.of(context).size.height* .02),
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
                                      onChanged: (value) {
                                        setState(() {
                                          _radioValue1 = value;
                                        });
                                        _handleRadioValueChange1(value);
                                      },
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
                                      onChanged: (value) {
                                        setState(() {
                                          _radioValue1 = value;
                                        });
                                        _handleRadioValueChange1(value);
                                      },
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
                          // SizedBox(height: MediaQuery.of(context).size.height* .01),
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(247, 247, 247, 1),
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color.fromRGBO(233, 233, 233, 1)),
                              )
                            ),
                            child: DropdownButton(
                              hint: Text(
                                'Select Relative: ',
                                style: GoogleFonts.alata(
                                    color: Color.fromRGBO(1, 155, 156, 1), fontSize: 12),
                              ),
                              dropdownColor: Color.fromRGBO(247, 247, 247, 1),
                              icon: Icon(Icons.arrow_drop_down,color:Color.fromRGBO(1, 155, 156, 1)),
                              iconSize: 20,
                              isExpanded: true,
                              underline: SizedBox(),
                              style: GoogleFonts.alata(color: Color.fromRGBO(1, 155, 156, 1),fontSize:12),
                              value: valueChoose,
                              onChanged: (newValue) {
                                setState(() {
                                  valueChoose = newValue;
                                });
                              },
                              items: relative.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: Text(valueItem),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
                      Navigator.of(context).pop(ConfirmDependantsAction.Cancel);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(10),
                    color: Color.fromRGBO(1, 150, 151, 1),
                    child: dependantsButton(),
                    onPressed: () async {
                      if (this._formKey.currentState.validate()) {
                        setState(() {
                          _state = "submitted";
                        });
                        _radioValue1 == 0
                          ? setState(() => _gender = "Male")
                          : setState(() => _gender = "Female");
                        var correctDate = dateSet.text.substring(0, dateSet.text.length - 13);
                        var url = Uri.parse("https://mobilehali.tenwebtechnologies.com/api/patient/dependent/add");
                        var response = await http.post(url, body: {
                          "name": _fullNameController.text,
                          "date_of_birth": correctDate,
                          "gender": _gender,
                          "relation": valueChoose,
                          "national_id": "${widget.national_id}"
                        }, headers: {'Authorization': 'Bearer ${widget.authToken}'});
                        var data = json.decode(response.body);
                        // print(data);
                        if(data['message'] == "success") {
                          setState((){
                            _state = "completed";
                          });
                          FlutterToast(context).showToast(
                            toastDuration: Duration(seconds: 4),
                            child: AlertDialog(
                              backgroundColor: Color.fromRGBO(247, 247, 247, 1),
                              title: Icon(MdiIcons.checkCircleOutline,color: Color.fromRGBO(1, 150, 151, 1), size: 40),
                              content: Text(
                                "Dependent has been registered successfully under this account!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.alata(fontWeight: FontWeight.w400)
                              ),
                            )
                          );
                        } else if (data['message'] == "exists"){
                          setState(() {
                            _state = "init";
                          });
                          FlutterToast(context).showToast(
                            toastDuration: Duration(seconds: 4),
                            child: AlertDialog(
                              backgroundColor: Color.fromRGBO(247, 247, 247, 1),
                              title: Icon(MdiIcons.information,color: Color.fromRGBO(83, 84, 226, 1), size: 40),
                              content: Text(
                                "Sorry!"+"\n"+"The dependent already exists in our servers."+"\n"+"Please use different details.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.alata(fontWeight: FontWeight.w400)
                              ),
                            )
                          );
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
enum ConfirmDependantsAction { Accept, Cancel }