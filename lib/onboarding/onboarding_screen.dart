import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding/screen_one.dart';
import '../onboarding/screen_two.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_offline/flutter_offline.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool authCheckProgress = false;
  bool onLastPage = false;
  late String username, phoneNumber, userId;

  @override
  void initState() {
    super.initState();
    userDetails();
  }

  userDetails() async {
    setState(() {
      authCheckProgress = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? patientName = prefs.getString('patientName');

    if (patientName == null || patientName == "") {
      setState(() {
        authCheckProgress = false;
      });
    } else {
      // if (!mounted) return;
      // Navigator.pushReplacement(
      //   context, MaterialPageRoute(
      //   builder: (context) =>
      //     HomeScreen()
      //   )
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return authCheckProgress
        ? ModalProgressHUD(
            color: Color.fromRGBO(20, 18, 28, 1),
            progressIndicator: const CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(112, 113, 149, 1),
              valueColor:
                  AlwaysStoppedAnimation(Color.fromRGBO(82, 83, 119, 1)),
              strokeWidth: 4.0,
            ),
            inAsyncCall: authCheckProgress,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(1, 150, 151, 1).withOpacity(0.8),
                      BlendMode.darken),
                  image: const AssetImage('assets/background.png'),
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Color.fromRGBO(250, 250, 250, 1),
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(37), // here the desired height
                child: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Color.fromRGBO(1, 150, 151, 1),
                    statusBarIconBrightness: Brightness.light,
                    systemNavigationBarColor: Color.fromRGBO(1, 150, 151, 1),
                    systemNavigationBarIconBrightness: Brightness.light,
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                )),
            body: Builder(builder: (BuildContext context) {
              return OfflineBuilder(
                  connectivityBuilder: (BuildContext context,
                      ConnectivityResult connectivity, Widget child) {
                    final bool connected =
                        connectivity != ConnectivityResult.none;
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        child,
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            // color: connected ? null : null,
                            child: connected
                                ? null
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Container(
                                            width: double.infinity,
                                            color:
                                                Color.fromRGBO(199, 0, 57, 1),
                                            padding: const EdgeInsets.only(
                                                top: 7, bottom: 7),
                                            child: Text(
                                              "No Internet Connection",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.alata(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ))
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                  child: Stack(children: [
                    PageView(
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          onLastPage = (index == 2);
                        });
                      },
                      children: [IntroPageOne(), IntroPageTwo()],
                    ),
                    Container(
                      alignment: Alignment(0, 0.85),
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: 2,
                        effect: WormEffect(
                            dotWidth: 12.0,
                            dotHeight: 12.0,
                            activeDotColor: Color.fromRGBO(1, 150, 151, 1),
                            dotColor: Colors.white),
                      ),
                    )
                  ]));
            }));
  }
}
