import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../auth/login_screen.dart';
import '../auth/personal_details.dart';

class IntroPageOne extends StatefulWidget {
  const IntroPageOne({super.key});

  @override
  IntroPageOneState createState() => IntroPageOneState();
}

class IntroPageOneState extends State<IntroPageOne> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .07,
        ),
        Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Row(children: [
                    Text('SKIP',
                        style: GoogleFonts.alata(
                            color: Color.fromRGBO(1, 150, 151, 1),
                            fontSize: 16)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .02,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color.fromRGBO(1, 150, 151, 1),
                    ),
                  ]),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SignInScreen()
                    //   ),
                    // );
                  },
                )
              ],
            )),
        Text('My Personal Health Manager',
            style: GoogleFonts.alata(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        SizedBox(
          height: MediaQuery.of(context).size.height * .03,
        ),
        Container(
          padding: const EdgeInsets.all(25),
          child: Image.asset(
            'assets/slides/pp1.png',
            fit: BoxFit.fill,
            scale: 1,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .03,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Halistawi is the SMART and SIMPLE way to',
                      style: GoogleFonts.alata(
                          color: Color.fromRGBO(1, 150, 151, 1), fontSize: 17)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .001,
                  ),
                  Text('manage diabetes by monitoring doctor',
                      style: GoogleFonts.alata(
                          color: Color.fromRGBO(1, 150, 151, 1), fontSize: 17)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .001,
                  ),
                  Text(
                      'instructions including; Prescriptions, Testing and \nAppointments',
                      style: GoogleFonts.alata(
                          color: Color.fromRGBO(1, 150, 151, 1), fontSize: 17)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Row(children: [
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 17,
                      color: Color.fromRGBO(1, 150, 151, 1),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .01,
                    ),
                    Text('Record your doctor instructions',
                        style: GoogleFonts.alata(
                            color: Color.fromRGBO(1, 150, 151, 1),
                            fontSize: 17))
                  ]),
                  Row(children: [
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 17,
                      color: Color.fromRGBO(1, 150, 151, 1),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .01,
                    ),
                    Text('Record test results and medication taken',
                        style: GoogleFonts.alata(
                            color: Color.fromRGBO(1, 150, 151, 1),
                            fontSize: 17))
                  ]),
                  Row(children: [
                    Icon(
                      Iconsax.arrow_right_3,
                      size: 17,
                      color: Color.fromRGBO(1, 150, 151, 1),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .01,
                    ),
                    Text('Data is securely stored.',
                        style: GoogleFonts.alata(
                            color: Color.fromRGBO(1, 150, 151, 1),
                            fontSize: 17))
                  ]),
                ])
              ],
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromRGBO(1, 150, 151, 1),
                      borderRadius: BorderRadius.all(Radius.circular(
                              5) //                 <--- border radius here
                          ),
                    ),
                    child: MaterialButton(
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.alata(
                            color: Color.fromRGBO(247, 247, 247, 1),
                            fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInScreen()));
                      },
                    )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.alata(
                        color: Color.fromRGBO(1, 150, 151, 1), fontSize: 17),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => PersonalDetailsScreen()));
                  },
                ),
              ],
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
      ],
    );
  }
}
