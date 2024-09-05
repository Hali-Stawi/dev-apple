import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../auth/login_screen.dart';
import '../auth/personal_details.dart';

class IntroPageTwo extends StatefulWidget {
  const IntroPageTwo({super.key});

  @override
  IntroPageTwoState createState() => IntroPageTwoState();
}

class IntroPageTwoState extends State<IntroPageTwo> {
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
        Text('Only Follows Doctor Instructions',
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
            'assets/slides/pp6.png',
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
                  Text(
                      'Get doctor\'s authorization then setup doctor \ninstructions in your account.',
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
                    Text('Record Test Result and medication taken.',
                        style: GoogleFonts.alata(
                            color: Color.fromRGBO(1, 150, 151, 1),
                            fontSize: 17))
                  ]),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.arrow_right_3,
                          size: 17,
                          color: Color.fromRGBO(1, 150, 151, 1),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .01,
                        ),
                        Text(
                            'Data is stored in account. Reports are issued\nanytime. Notifications are issued if action is\nrequired. Follow instructions.',
                            style: GoogleFonts.alata(
                                color: Color.fromRGBO(1, 150, 151, 1),
                                fontSize: 17))
                      ])
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
