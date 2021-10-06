import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/authorization/login.dart';
// The Registration Page creates a new account using the Firebase Authorization.

class Registration extends StatefulWidget {
  Registration({this.gender});
  final String gender;

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  // emailAddress Stores The email address entered by the user.
  // password saves the password entered by the user.
  // _auth is Firebase Authorization Instance.
  // _firestore is Firebase Firestore Instance.
  //firstName, lastName, rollNumber, branch stores the respective information.
  // issuedBooks and applied are required to passed null inorder to have at their entry else the app will crash in later phases if they are not found.
  String emailAddress;
  String password;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String firstName;
  String lastName;
  String rollNumber;
  String branch;
  Map issuedBooks= {};
  Map applied = {};
  // Color maleColour = Colors.blueAccent.withOpacity(0.5);
  // Color femaleColour = Colors.white10;
  bool ignore = false;
  bool hidePass = true;

  void makeRecord() async {
    if(firstName == null || lastName == null || rollNumber == null || branch == null || emailAddress == null || password == null){
      Fluttertoast.showToast(msg: 'Field can\'t be empty');
      setState(() {
        ignore = false;
      });
    }
    else{
      try{
        // This Sends the data to the Firestore collection of users.
        // The document id is the emailAddress of the user filling the details.
        // After all the details are filled it takes the user to the home screen.
        _firestore.collection('users').doc(emailAddress).set({
          'First Name': firstName,
          'Last Name': lastName,
          'Branch': branch,
          'Roll Number': rollNumber,
          'Email Id': emailAddress,
          'Issued Books': issuedBooks,
          'Applied': applied,
          'Gender': widget.gender,
        });
        Navigator.pushNamed(context, Login.id);
      }
      catch(e){
        setState(() {
          ignore = false;
        });
        Fluttertoast.showToast(msg: e.toString(),);
      }
    }
  }

  void createAccount() async {
    try{
      // This creates the new account using Firebase Authorization
      // Then redirects them to the enter_details.dart to fill in useful info.
      // No one can become admin using register it can solely be done by the developer of the App.
      final newUser = await _auth.createUserWithEmailAndPassword(email: emailAddress, password: password);
      if(newUser != null){
        final user = _auth.currentUser;
        await user.sendEmailVerification();
        Fluttertoast.showToast(msg: 'Verification email Send');
        makeRecord();
      }
    }
    catch(e){
      setState(() {
        ignore = false;
      });
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.greenAccent,
        child: Center(
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.9,
            // height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/SignIn.png',),
                fit: BoxFit.scaleDown,
                alignment: Alignment.lerp(Alignment.bottomLeft, Alignment.bottomRight, 0.4),
              ),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top:40),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.edit,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter First Name",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      firstName = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.edit,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Last Name",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      lastName = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.idCard,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Roll Number",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      rollNumber = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.graduationCap,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Branch Name",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      branch = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.user,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      emailAddress = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60,right:60,top: 5,bottom: 50),
                  child: TextFormField(
                    obscureText: hidePass,
                    decoration: InputDecoration(
                      suffix: GestureDetector(
                        child: hidePass
                            ? Icon(
                          FontAwesomeIcons.eyeSlash,
                          color: Colors.black,
                        )
                            : Icon(FontAwesomeIcons.eye),
                        onTap: () {
                          setState(() {
                            hidePass = !hidePass;
                          });
                        },
                      ),
                      prefixIcon: Icon(FontAwesomeIcons.key,size: 18.0,color: Color(0Xff6B63FF),),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        Fluttertoast.showToast(msg: 'Required Field',);
                        return "Required Field";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.visiblePassword,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      password = value == '' ? null : value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 5, left: 115, right: 115),
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
                  child: IgnorePointer(
                    ignoring: ignore,
                    child: FlatButton(
                      child: Text(
                        'Register',
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w800,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: (){
                        setState(() {
                          ignore = true;
                        });
                        Future.delayed(Duration(milliseconds: 800),(){
                          setState(() {
                            ignore = false;
                          });
                        });
                        createAccount();
                      },
                    ),
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