import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hali_stawi/auth/login_screen.dart';
import 'package:hali_stawi/blocs/dependents_bloc.dart';
import 'package:hali_stawi/model/dependents_model.dart';
import 'package:hali_stawi/pages/popups/appointments.dart';
import 'package:hali_stawi/pages/popups/dependents.dart';
import 'package:hali_stawi/pages/popups/medications.dart';
import 'package:hali_stawi/pages/popups/payment_history.dart';
import 'package:hali_stawi/pages/popups/test_results.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strings/strings.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_html/flutter_html.dart';

class HomeScreen extends StatefulWidget {
  final authToken;
  final national_id;
  final dob;
  final gender;
  HomeScreen({Key key, @required this.authToken,@required this.national_id,@required this.dob,@required this.gender}):super(key:key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> { 
  String patientName;
  String dob;
  @override
  void initState() {
    super.initState();
    userDetails();
  }

  userDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      patientName = prefs.getString('patientName');
      dob = prefs.getString('dob');
    });
  }

  //Bottom Sheets
  showModalTestResultsSheet(context){
    showModalBottomSheet(
      isScrollControlled: true,
      context:context,
      backgroundColor: Colors.transparent,
      builder: (context){
        dependentsBloc.fetchDependents("${widget.national_id}", "${widget.authToken}");
        return StatefulBuilder(
          builder: (context, setState) {
            return makeDismissible(
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                builder: (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(1, 150, 151, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * .02),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .009,
                            width: MediaQuery.of(context).size.width * .12,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(1, 120, 121, 1),
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * .03),
                          Container(
                            child: Text(
                              "Select Member",
                              style: GoogleFonts.alata(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)
                            )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * .05),
                          Column(
                            children:[
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${capitalize(patientName.toLowerCase())}",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w400),
                                      ),
                                      Text(
                                        "$dob",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ),
                                onTap:(){
                                  Navigator.push(context,MaterialPageRoute(
                                    builder: (context) =>TestResultsScreen(
                                      authToken: widget.authToken,
                                      national_id: widget.national_id,
                                      patientName: patientName,
                                      dob: widget.dob,
                                      gender: widget.gender
                                    )
                                  ));
                                }
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * .02),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child:Divider(
                                  color: Color.fromRGBO(1, 120, 121, 1),
                                )
                              )
                            ],
                          ),
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
                                          GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${capitalize(snapshot.data[index].name.toLowerCase())}",
                                                    style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w400),
                                                  ),
                                                  Text(
                                                    snapshot.data[index].date_of_birth,
                                                    style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w500),
                                                  ),
                                                ],
                                              )
                                            ),
                                            onTap:(){
                                              Navigator.push(context,MaterialPageRoute(
                                                builder: (context) =>TestResultsScreen(
                                                  authToken: widget.authToken,
                                                  national_id: widget.national_id,
                                                  patientName: snapshot.data[index].name,
                                                  dob: snapshot.data[index].date_of_birth,
                                                  gender: snapshot.data[index].gender
                                                )
                                              ));
                                            }
                                          ),
                                          SizedBox(height: MediaQuery.of(context).size.height * .02),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child:Divider(
                                              color: Color.fromRGBO(1, 120, 121, 1),
                                            )
                                          )
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
                                return Container(height: 0, width: 0);
                              }
                            }
                          )
                        ],
                      )
                    ]
                  )
                )
              )
            );
          }
        );
      }
    );
  }

  showModalAppointmentsSheet(context){
    showModalBottomSheet(
      isScrollControlled: true,
      context:context,
      backgroundColor: Colors.transparent,
      builder: (context){
        dependentsBloc.fetchDependents("${widget.national_id}", "${widget.authToken}");
        return StatefulBuilder(
          builder: (context, setState) {
            return makeDismissible(
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                builder: (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(1, 150, 151, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * .02),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .009,
                            width: MediaQuery.of(context).size.width * .12,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(1, 120, 121, 1),
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * .03),
                          Container(
                            child: Text(
                              "Select Member",
                              style: GoogleFonts.alata(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)
                            )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * .05),
                          Column(
                            children:[
                              GestureDetector(
                                child:Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${capitalize(patientName.toLowerCase())}",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w400),
                                      ),
                                      Text(
                                        "$dob",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ),
                                onTap:(){
                                  Navigator.push(context,MaterialPageRoute(
                                    builder: (context) =>AppointmentsScreen(
                                      authToken: widget.authToken,
                                      national_id: widget.national_id,
                                      patientName: patientName,
                                      dob: widget.dob,
                                      gender: widget.gender
                                    )
                                  ));
                                }
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * .02),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child:Divider(
                                  color: Color.fromRGBO(1, 120, 121, 1),
                                )
                              )
                            ],
                          ),
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
                                          GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${capitalize(snapshot.data[index].name.toLowerCase())}",
                                                    style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w400),
                                                  ),
                                                  Text(
                                                    snapshot.data[index].date_of_birth,
                                                    style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w500),
                                                  ),
                                                ],
                                              )
                                            ),
                                            onTap:(){
                                              Navigator.push(context,MaterialPageRoute(
                                                builder: (context) =>AppointmentsScreen(
                                                  authToken: widget.authToken,
                                                  national_id: widget.national_id,
                                                  patientName: snapshot.data[index].name,
                                                  dob: snapshot.data[index].date_of_birth,
                                                  gender: snapshot.data[index].gender
                                                )
                                              ));
                                            }
                                          ),
                                          SizedBox(height: MediaQuery.of(context).size.height * .02),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child:Divider(
                                              color: Color.fromRGBO(1, 120, 121, 1),
                                            )
                                          )
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
                                return Container(height: 0, width: 0);
                              }
                            }
                          )
                        ],
                      )
                    ]
                  )
                )
              )
            );
          }
        );
      }
    );
  }

  showModalMyMedicationsSheet(context){
    showModalBottomSheet(
      isScrollControlled: true,
      context:context,
      backgroundColor: Colors.transparent,
      builder: (context){
        dependentsBloc.fetchDependents("${widget.national_id}", "${widget.authToken}");
        return StatefulBuilder(
          builder: (context, setState) {
            return makeDismissible(
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                builder: (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(1, 150, 151, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * .02),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .009,
                            width: MediaQuery.of(context).size.width * .12,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(1, 120, 121, 1),
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * .03),
                          Container(
                            child: Text(
                              "Select Member",
                              style: GoogleFonts.alata(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)
                            )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * .05),
                          Column(
                            children:[
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${capitalize(patientName.toLowerCase())}",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w400),
                                      ),
                                      Text(
                                        "$dob",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ),
                                onTap:(){
                                  Navigator.push(context,MaterialPageRoute(
                                    builder: (context) =>MedicationsScreen(
                                      authToken: widget.authToken,
                                      national_id: widget.national_id,
                                      patientName: patientName,
                                      dob: widget.dob,
                                      gender: widget.gender
                                    )
                                  ));
                                }
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * .02),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child:Divider(
                                  color: Color.fromRGBO(1, 120, 121, 1),
                                )
                              )
                            ],
                          ),
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
                                          GestureDetector(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${capitalize(snapshot.data[index].name.toLowerCase())}",
                                                    style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w400),
                                                  ),
                                                  Text(
                                                    snapshot.data[index].date_of_birth,
                                                    style: GoogleFonts.alata(color:Colors.white,fontSize:13,fontWeight:FontWeight.w500),
                                                  ),
                                                ],
                                              )
                                            ),
                                            onTap:(){
                                              Navigator.push(context,MaterialPageRoute(
                                                builder: (context) =>MedicationsScreen(
                                                  authToken: widget.authToken,
                                                  national_id: widget.national_id,
                                                  patientName: snapshot.data[index].name,
                                                  dob: snapshot.data[index].date_of_birth,
                                                  gender: snapshot.data[index].gender
                                                )
                                              ));
                                            }
                                          ),
                                          SizedBox(height: MediaQuery.of(context).size.height * .02),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child:Divider(
                                              color: Color.fromRGBO(1, 120, 121, 1),
                                            )
                                          )
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
                                return Container(height: 0, width: 0);
                              }
                            }
                          )
                        ],
                      )
                    ]
                  )
                )
              )
            );
          }
        );
      }
    );
  }

  Widget build(BuildContext context) {
    int selectedIndex = 0;
    PageController pageController = PageController();
    void onTap(int pageValue) {
      setState(() {
        selectedIndex = pageValue;
      });
      pageController.jumpToPage(pageValue);
    }
    return WillPopScope(
      onWillPop: () async {
        _asyncExitConfirmDialog(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        appBar: AppBar(
          backwardsCompatibility: false,
          backgroundColor: Color.fromRGBO(247, 247, 247, 1),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromRGBO(1, 150, 151, 1),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Color.fromRGBO(1, 150, 151, 1),
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "My Health ...my wealth",
                style: GoogleFonts.alata(
                  color: Color.fromRGBO(1, 170, 171, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w800
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                    MdiIcons.bell,
                      color: Color.fromRGBO(1, 150, 151, 1),
                      size: 19,
                    ),
                  ),
                  Positioned(
                    left: 14.5,
                    child: Icon(
                      Icons.brightness_1,
                      color: Color.fromRGBO(113, 200, 55, 1),
                      size: 8.5,
                    ),
                  )
                ],
              ),
              onPressed: () {},
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: DividerThemeData(
                  color: Color.fromRGBO(1, 150, 151, 1),
                ),
                iconTheme: IconThemeData(color: Color.fromRGBO(1, 150, 151, 1), size: 15),
                textTheme: TextTheme().apply(bodyColor: Color.fromRGBO(1, 150, 151, 1)),
              ),
              child: PopupMenuButton<int>(
                color: Colors.white,
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    child: GestureDetector(
                      onTap: (){
                        // Navigator.push(context,MaterialPageRoute(
                        // builder: (context) => ProfileScreen(userId: widget.userId)));
                      },
                      child: Row(
                        children: [
                          Icon(MdiIcons.account, size: 15),
                          const SizedBox(width: 8),
                          Text(
                            'Profile',
                            style: GoogleFonts.alata(color: Color.fromRGBO(1, 150, 151, 1), fontSize: 12)
                          )
                        ]
                      ),
                    )
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<int>(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        signOut(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 15),
                          const SizedBox(width: 8),
                          Text(
                            'Sign Out',
                            style: GoogleFonts.alata(color: Color.fromRGBO(1, 150, 151, 1), fontSize: 12)
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          child: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal:5),
                  child:Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Row(
                                // crossAxisAlignment:CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(13),
                                    margin: EdgeInsets.only(right: 90),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle, color: Color.fromRGBO(247,247,247,1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/hali_stawi.png',
                                      color: Color.fromRGBO(241,241,241,1),
                                      scale: 30,
                                    ),
                                  )
                                ]
                              ),
                              Positioned(
                                left: 50,
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children:[
                                    SizedBox(height: MediaQuery.of(context).size.height* .015),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child:Text(
                                        "Welcome,",
                                        style: GoogleFonts.alata(
                                          color: Color.fromRGBO(1, 170, 171, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child:Text(
                                        "${capitalize(patientName.toLowerCase())}",
                                        style: GoogleFonts.alata(
                                          color: Color.fromRGBO(1, 170, 171, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    )
                                  ]
                                )
                              )

                            ],
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              margin: EdgeInsets.only(right: 6.8),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/payment.png',
                                color: Color.fromRGBO(1, 170, 171, 1),
                                scale: 30,
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) =>PaymentHistoryScreen(
                                    authToken: widget.authToken,
                                    national_id: widget.national_id,
                                    patientName: patientName,
                                    dob: widget.dob,
                                    gender: widget.gender
                                  )
                                )
                              );
                            }
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .03),
                      Container(
                        padding: EdgeInsets.all(6),
                        margin: const EdgeInsets.symmetric(horizontal:7),
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle, color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal:12,vertical:22),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle, color: Color.fromRGBO(1, 170, 171, 1),
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/blood_pressure1.png',
                                    color: Colors.white,
                                    scale: 9,
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width* .03),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Blood Pressure",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:12,fontWeight:FontWeight.w600)
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height* .005),
                                      Text(
                                        "N/A",
                                        style: GoogleFonts.alata(color:Colors.white,fontSize:12,fontWeight:FontWeight.bold)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right:10,bottom:10,top:10),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/blood_sugar3.png',
                                    color: Color.fromRGBO(1, 170, 171, 1),
                                    scale: 9,
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width* .02),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Blood Sugar",
                                        style: GoogleFonts.alata(color:Color.fromRGBO(1, 170, 171, 1),fontSize:12,fontWeight:FontWeight.w600)
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height* .005),
                                      Text(
                                        "N/A",
                                        style: GoogleFonts.alata(color:Color.fromRGBO(1, 170, 171, 1),fontSize:12,fontWeight:FontWeight.bold)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .04),  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: Offset(0, 1),// changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal:40,vertical:15),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle, color: Color.fromRGBO(247,247,247,1),
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                    ),
                                    child: Image.asset(
                                      'assets/test_results.png',
                                      color: Color.fromRGBO(1, 170, 171, 1),
                                      scale: 12,
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .03), 
                                  Text(
                                    "Test Results",
                                    style: GoogleFonts.alata(color:Color.fromRGBO(87,87,87,1),fontSize:12,fontWeight:FontWeight.w600),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .01),
                                ],
                              )
                            ),
                            onTap: (){
                              showModalTestResultsSheet(context);
                            },
                          ),
                          GestureDetector(
                            child:Container(
                              padding: EdgeInsets.all(4),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal:40,vertical:15),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle, color: Color.fromRGBO(247,247,247,1),
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                    ),
                                    child: Image.asset(
                                      'assets/appointments.png',
                                      color: Color.fromRGBO(1, 170, 171, 1),
                                      scale: 12,
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .03), 
                                  Text(
                                    "Appointments",
                                    style: GoogleFonts.alata(color:Color.fromRGBO(87,87,87,1),fontSize:12,fontWeight:FontWeight.w600),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .01),
                                ],
                              )
                            ),
                            onTap: (){
                              showModalAppointmentsSheet(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height* .04),  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child:Container(
                              padding: EdgeInsets.all(4),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal:40,vertical:15),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle, color: Color.fromRGBO(247,247,247,1),
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                    ),
                                    child: Image.asset(
                                      'assets/medicine.png',
                                      color: Color.fromRGBO(1, 170, 171, 1),
                                      scale: 12,
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .03), 
                                  Text(
                                    "My Medication",
                                    style: GoogleFonts.alata(color:Color.fromRGBO(87,87,87,1),fontSize:12,fontWeight:FontWeight.w600),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .01),
                                ],
                              )
                            ),
                            onTap: (){
                              showModalMyMedicationsSheet(context);
                            },
                          ),
                          GestureDetector(
                           child:Container(
                              padding: EdgeInsets.all(4),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle, color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal:40,vertical:15),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle, color: Color.fromRGBO(247,247,247,1),
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                    ),
                                    child: Image.asset(
                                      'assets/dependants.png',
                                      color: Color.fromRGBO(1, 170, 171, 1),
                                      scale: 12,
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .03), 
                                  Text(
                                    "Dependents",
                                    style: GoogleFonts.alata(color:Color.fromRGBO(87,87,87,1),fontSize:12,fontWeight:FontWeight.w600),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height* .01),
                                ],
                              )
                            ),
                            onTap: (){
                              Navigator.push(context,
                                      MaterialPageRoute(
                                      builder: (context) =>DependentsScreen(
                                        authToken: widget.authToken,
                                        national_id: "${widget.national_id}",
                                      )));
                            },
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(8),
                          //   decoration: new BoxDecoration(
                          //     shape: BoxShape.rectangle, color: Colors.white,
                          //     borderRadius: BorderRadius.all(Radius.circular(3)),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey.withOpacity(0.1),
                          //         offset: Offset(0, 1), // changes position of shadow
                          //       ),
                          //     ],
                          //   ),
                          //   child: Column(
                          //     children: [
                          //       Container(
                          //         padding: EdgeInsets.all(22),
                          //         decoration: new BoxDecoration(
                          //           shape: BoxShape.rectangle, color: Color.fromRGBO(247,247,247,1),
                          //           borderRadius: BorderRadius.all(Radius.circular(3)),
                          //         ),
                          //         child: Icon(
                          //           MdiIcons.fileDocumentMultipleOutline,
                          //           color: Color.fromRGBO(1, 170, 171, 1),
                          //           size: 25,
                          //         ),
                          //       ),
                          //       SizedBox(height: MediaQuery.of(context).size.height* .02), 
                          //       Text(
                          //         "Recharge Account",
                          //         style: GoogleFonts.alata(color:Color.fromRGBO(87,87,87,1),fontSize:12,fontWeight:FontWeight.w600),
                          //       )
                          //     ],
                          //   )
                          // )
                        ],
                      )                     
                    ]
                  )
                )
              );
            }
          ),
        ),
      )
    );
  }

  Widget makeDismissible({Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(
      onTap: () {},
      child: child,
    ),
  );
}

enum ConfirmLogoutAction { Accept, Cancel }
Future signOut(BuildContext context) async {
  return showDialog<ConfirmLogoutAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        title: Column(
          children:[
            Text(
              'Are you sure you want to sign out?',
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(color: Color.fromRGBO(17, 17, 17, 1),fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            Text(
              'By signing out, you will need to sign in again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(color: Color.fromRGBO(1, 150, 151, 1),fontSize: 14),
            ),
          ]
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
              Navigator.of(context).pop(ConfirmLogoutAction.Cancel);
            },
          ),
          SizedBox(width: 10,),
          FlatButton(
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(1, 150, 151, 1),
            child: Text(
              'Sign Out',
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(color: Color.fromRGBO(247, 247, 247, 1), fontSize: 10),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>SignInScreen()),
              );
            },
          )
        ],)
      );
    },
  );
}

enum ConfirmExitAction { Accept, Cancel }
Future _asyncExitConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmExitAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Text(
              'Exit App',
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(color: Color.fromRGBO(17, 17, 17, 1),fontSize: 14, fontWeight: FontWeight.w800)
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            Text(
              'Are you sure you want to exit the application?',
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(color: Color.fromRGBO(1, 150, 151, 1),fontSize: 14)
            ),
          ]
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
              padding: EdgeInsets.all(10),
              color: Color.fromRGBO(237, 237, 237, 1),
              child: Text(
                'Cancel',
                textAlign: TextAlign.center,
                style: GoogleFonts.alata(color: Color.fromRGBO(1, 150, 151, 1), fontSize: 10),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmExitAction.Cancel);
              },
            ),
            SizedBox(width: 10,),
            FlatButton(
              padding: EdgeInsets.all(10),
              color: Color.fromRGBO(1, 150, 151, 1),
              child: Text(
                'Exit',
                textAlign: TextAlign.center,
                style: GoogleFonts.alata(color: Color.fromRGBO(247, 247, 247, 1), fontSize: 10),
              ),
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                });
              },
            ),
          ]
        )
      );
    },
  );
}