import 'dart:convert';
import 'package:hali_stawi/blocs/payment_history_doc.dart';
import 'package:hali_stawi/model/payment_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hali_stawi/pages/home_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:strings/strings.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final authToken;
  final national_id;
  final patientName;
  final dob;
  final gender;
  PaymentHistoryScreen({Key key, @required this.authToken,@required this.national_id,@required this.patientName,@required this.dob,@required this.gender}):super(key:key);
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen>{
  String username;
  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  int balance;

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  userDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // username = prefs.getString('username');
      balance = prefs.getInt('balance');
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  Widget build(BuildContext context) {
    paymentsBloc.fetchPaymentHistory("${widget.national_id}", "${widget.authToken}");
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
                      "Payment History",
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
                        paymentFormDialog(context);
                      }
                    )
                  ],
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height* .025),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "BALANCE",
                      style: GoogleFonts.alata(color:Color.fromRGBO(47,47,47,1),fontSize:13,fontWeight:FontWeight.w500),
                    ),
                    Text(
                      "$balance" != null ? "$balance" : "0.00",
                      style: GoogleFonts.alata(color:Color.fromRGBO(0,150,151,1),fontSize:12,fontWeight:FontWeight.w500),
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    //   child:CircularProgressIndicator(
                    //     backgroundColor: Colors.white,
                    //     valueColor: AlwaysStoppedAnimation(Color.fromRGBO(1, 150, 151, 1)),
                    //     strokeWidth: 1.5,
                    //   ),
                    //   height: 12,
                    //   width: 12,
                    // )
                  ],
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height* .025),
              StreamBuilder(
                stream: paymentsBloc.payments,
                builder: (context, AsyncSnapshot<List<PaymentHistoryModel>> snapshot) {
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
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(230, 230, 230, 1),
                                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                              ),
                                              child: Icon(
                                                MdiIcons.currencyUsd,
                                                size: 18,
                                                color: Color.fromRGBO(1, 150, 151, 1),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width* .03
                                            ), 
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${snapshot.data[index].mpesacode}",
                                                  style: GoogleFonts.alata(fontSize: 13, fontWeight: FontWeight.w400),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height* .004),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${snapshot.data[index].transactiondate}",
                                                      style: GoogleFonts.alata(fontSize: 10, fontWeight: FontWeight.w200),
                                                    ),
                                                    Text(
                                                      "${snapshot.data[index].transactiontime}",
                                                      style: GoogleFonts.alata(fontSize: 10, fontWeight: FontWeight.w200),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(230, 230, 230, 1),
                                            borderRadius: BorderRadius.all(Radius.circular(2)),
                                          ),
                                          child:Text(
                                            "${snapshot.data[index].amount}",
                                            style: GoogleFonts.alata(fontSize: 10, fontWeight: FontWeight.w500)
                                          )
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.5),
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
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
              // StreamBuilder(
              //   stream: paymentsBloc.payments,
              //   builder: (context, AsyncSnapshot<List<PaymentHistoryModel>> snapshot) {
              //     if (snapshot.hasData) {
              //       return snapshot.data.length < 1 ? Container(height: 0, width: 0)
              //       : MediaQuery.removePadding(
              //         removeTop: true,
              //         context: context,
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           physics: NeverScrollableScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             return Container(
              //               margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              //               decoration: BoxDecoration(
              //                 color: Color.fromRGBO(247, 247, 247, 1),
              //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //               ),
              //               child: Column(
              //                 children: [
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Row(
              //                         children: [
              //                           Container(
              //                             padding: EdgeInsets.all(4),
              //                             decoration: BoxDecoration(
              //                               color: Color.fromRGBO(230, 230, 230, 1),
              //                               borderRadius: BorderRadius.all(Radius.circular(3)),
              //                             ),
              //                             child: Icon(
              //                               MdiIcons.currencyUsd,
              //                               size: 18,
              //                               color: Color.fromRGBO(1, 150, 151, 1),
              //                             ),
              //                           ),
              //                           SizedBox(
              //                             width: MediaQuery.of(context).size.width* .03
              //                           ),
              //                           Column(
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             children: [
              //                               Text(
              //                                 "QHB313NLT1",
              //                                 style: GoogleFonts.alata(fontSize: 13, fontWeight: FontWeight.w400),
              //                               ),
              //                               SizedBox(height: MediaQuery.of(context).size.height* .004),
              //                               Row(
              //                                 children: [
              //                                   Text(
              //                                     "11 Aug, 2022",
              //                                     style: GoogleFonts.alata(fontSize: 10, fontWeight: FontWeight.w200),
              //                                   ),
              //                                   Text(
              //                                     "00:55:07",
              //                                     style: GoogleFonts.alata(fontSize: 10, fontWeight: FontWeight.w200),
              //                                   )
              //                                 ],
              //                               )
              //                             ],
              //                           )
              //                         ],
              //                       ),
              //                       Container(
              //                         padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              //                         decoration: BoxDecoration(
              //                           color: Color.fromRGBO(230, 230, 230, 1),
              //                           borderRadius: BorderRadius.all(Radius.circular(2)),
              //                         ),
              //                         child:Text(
              //                           "10.00",
              //                           style: GoogleFonts.alata(fontSize: 10, fontWeight: FontWeight.w500)
              //                         )
              //                       ),
              //                     ],
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.symmetric(vertical: 3),
              //                     child:Divider(
              //                       color: Color.fromRGBO(1, 215, 216, 1)
              //                     )
              //                   ),
              //                 ],
              //               )
              //             );
              //           }
              //         )
              //       );
              //     }
              //     else if (snapshot.hasError) {
              //       return Text(snapshot.error.toString());
              //     } 
              //     else {
              //       return MediaQuery.removePadding(
              //         removeTop: true,
              //         context: context,
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           physics: NeverScrollableScrollPhysics(),
              //           itemBuilder: (context, position) {
              //             return Container(
              //               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //               height: MediaQuery.of(context).size.height * .08,
              //               width: MediaQuery.of(context).size.width,
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(5),
              //               ),
              //               padding: const EdgeInsets.symmetric(horizontal:21),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: <Widget>[
              //                   Shimmer.fromColors(
              //                     baseColor: Color.fromRGBO(247, 247, 247, 1),
              //                     highlightColor:Colors.white,
              //                     direction: ShimmerDirection.ltr,
              //                     child: Container(
              //                       height: MediaQuery.of(context).size.height * .013,
              //                       width: MediaQuery.of(context).size.width * .28,
              //                       decoration: BoxDecoration(
              //                         color:Color.fromRGBO(247, 247, 247, 1),
              //                         borderRadius: BorderRadius.circular(5),
              //                       ),
              //                     )
              //                   ),
              //                   Shimmer.fromColors(
              //                     baseColor: Color.fromRGBO(247, 247, 247, 1),
              //                     highlightColor:Colors.white,
              //                     direction: ShimmerDirection.ltr,
              //                     child: Container(
              //                       height: MediaQuery.of(context).size.height * .013,
              //                       width: MediaQuery.of(context).size.width * .12,
              //                       decoration: BoxDecoration(
              //                         color: Color.fromRGBO(247, 247, 247, 1),
              //                         borderRadius: BorderRadius.circular(5),
              //                       )
              //                     )
              //                   )
              //                 ]
              //               )
              //             );
              //           },
              //           itemCount: 8,
              //         )
              //       );
              //     }
              //   }
              // )
            ]
          ));
        }),
      )
    );
  }

  Future paymentFormDialog(BuildContext context) async {
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
                      'Payment Request',
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
                              controller: _phoneNumberController,
                              cursorColor: Color.fromRGBO(1, 150, 151, 1),
                              style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                labelText: 'Phone Number',
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
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height* .02),
                          Theme(
                            data: Theme.of(context).copyWith(primaryColor: Colors.black),
                            child: TextFormField(
                              controller: _amountController,
                              cursorColor: Color.fromRGBO(1, 150, 151, 1),
                              style: GoogleFonts.alata(color: Color.fromRGBO(0, 139, 139, 1), fontSize: 13),
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                labelText: 'Enter Amount',
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
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Amount is required';
                                }
                                return null;
                              },
                            ),
                          ),
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
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    color: Color.fromRGBO(1, 150, 151, 1),
                    child: Text(
                      'Send Request',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.alata(color: Color.fromRGBO(247, 247, 247, 1), fontSize: 10),
                    ),
                    onPressed: () {},
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