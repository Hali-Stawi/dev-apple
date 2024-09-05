import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'onboarding/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromRGBO(1, 150, 151, 1),
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color.fromRGBO(1, 150, 151, 1),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  navigatePage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
  }

  splashMove() {
    return Timer(const Duration(seconds: 5), navigatePage);
  }

  @override
  void initState() {
    super.initState();
    splashMove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(35),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.03),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(8, 11), // changes position of shadow
                  ),
                ],
              ),
              child: Image.asset(
                'assets/hali_stawi.png',
                scale: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}