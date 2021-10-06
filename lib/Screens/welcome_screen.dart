import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/Screens/gender_screen.dart';
import 'package:library_management_system/authorization/login.dart';
import 'package:drawing_animation/drawing_animation.dart';

// This Screen is the Welcome Screen That the User sees for the first time when the app starts.
// The Static String is Used so that the routes are not named incorrectly as they are used in many places.
// This Screen contains the Navigator to Login Screen and Registration Screen. So When The User Presses any button He is taken to The Login Screen.
// Whenever the FlatButton is pressed it takes to the respective page.

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  bool run = true;

  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/welcome.jpg'),fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              //color: Colors.white54,
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.14),
            child: ListView(
              children: [
                //SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: AnimatedCrossFade(
                    secondCurve: Curves.ease,
                    alignment: Alignment.center,
                    duration: Duration(seconds: 6),
                    firstChild: AnimatedDrawing.svg(
                      "images/logo copy 4.svg",
                      width: 180.0,
                      lineAnimation: LineAnimation.oneByOne,
                      scaleToViewport: true,
                      run: this.run,
                      duration: new Duration(seconds: 4),
                      onFinish: () => setState(() {
                        this.run = false;
                      }),
                    ),
                    secondChild: SvgPicture.asset('images/LMS logo.svg',width: 240,color: Color(0Xcf3D3854)),
                    crossFadeState: _crossFadeState,
                  ),
                ),
                //
                //   ),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(bottom: 5, left: 85, right: 85),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0Xaa6C63FF).withOpacity(0.9),
                          Color(0Xaa6C63FF).withOpacity(0.9),
                        ]),
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Color(0XFF403D55), width: 4.0),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                        Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: FlatButton(
                    child: Text('Login',
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: Color(0XFF003d5b),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Login.id);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(
                      top: 20, bottom: 10, left: 85, right: 85),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0Xaa6C63FF).withOpacity(0.9),
                          Color(0Xaa6C63FF).withOpacity(0.9),
                        ]),
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Color(0XFF403D55), width: 4.0),
                    boxShadow: [
                      BoxShadow(
                        // color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                        Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: FlatButton(
                    child: Text('Register',
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                        color: Color(0XFF003d5b),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, GenderScreen.id);
                      // Navigator.pushNamed(context, Registration.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
