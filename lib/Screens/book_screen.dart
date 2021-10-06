import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_management_system/components/book_screen_widgets.dart';

// This screens shows the contents of the book that was tapped in the search screen.
// If the user is an admin he can only view the status of the book but not apply for the book.
class BookScreen extends StatefulWidget {
  BookScreen({this.bookContent});
  final bookContent;

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {

  // _firestore is Firebase FireStore instance.
  // _auth is the Firebase Authorization instance.
  // emailAddress is taken with the help of loggedInUser which automatically fetches user's email address using Firebase Authorization.
  // isAvailable is bool which is true if at least one book is available to be issued.
  // isAdmin is bool which is true if the user is an Admin and false if it is a normal user. Its true since it can't be null when the widgets are build.
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String emailAddress;
  bool isAvailable = true;
  bool isAdmin = true;

  // This Function Checks whether the current user is admin or not.
  // It accesses the admin collection in firestore and checks if their is any entry with the current emailAddress.
  // It returns false and then uses setState to change isAdmin to new value, if the user has no entry in admin collection means the user is not an admin.
  void adminCheck() async {
    try{
      final userData = await _firestore.collection('admin').doc(emailAddress).get();
      if (userData.data() == null){
        setState(() {
          isAdmin = false;
        });
      }
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This function checks whether the book being applied is already issued by the user or not.
  // This function checks if any documents in issued books collections is having the current user's email address in the Borrower map.
  // we use the firstWhere to check for the condition and if it is issued the user's application is not send.
  void checkIssued () {
    try{
      var isIssued = widget.bookContent['Borrower'].keys.firstWhere(
              (k) => widget.bookContent['Borrower'][k] == emailAddress, orElse: () => null);
      if(isIssued != null){
        Fluttertoast.showToast(msg: 'Already Issued',);
      }
      else{
        checkApplied();
      }
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This function checks if the user has already applied to the book or not.
  // This function checks whether the particular user's doc in users collection contains the map applied with the particular book code being applied for.
  // This Function will limit the no.of applications for the book to one per person.
  void checkApplied() async {
    try{
      final userData = await _firestore.collection('users').doc(emailAddress).get();
      if(userData.data()['Applied']['${widget.bookContent['Book Code']}'] != null){
        Fluttertoast.showToast(msg: 'Already Applied',);
      }
      else{
        sendApplication();
      }
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // sendApplication sends the application of the user.
  // If isIssued and checkApplied are cleared then the user can send the application.
  // It creates a new doc in the applications collection and a new entry in the applied of the user doc in users collection.
  // The Application id is simply the emailAddress of the user + BookCode
  void sendApplication() {
    try{
      String applicationId;
      applicationId = emailAddress+widget.bookContent['Book Code'];
      print(applicationId);
      _firestore.collection('applications').doc(applicationId).set({
        'Book Code': widget.bookContent['Book Code'],
        'Borrower': emailAddress,
        'Application Date': DateTime.now(),
        'Book Name': widget.bookContent['Book Name'],
      });
      _firestore.collection('users').doc(emailAddress).update({
        'Applied.${widget.bookContent['Book Code']}': DateTime.now(),
      });
      Fluttertoast.showToast(
        msg: 'Issuing Request Send',
        backgroundColor: Color(0xDD286053),
      );
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This function is executed as soon as the widget is build.
  // isAvailable is true if the no.of books issued are less than total no.of books.
  // The function fetches the email address of the user via Firebase Authorization automatically.
  @override
  void initState() {
    super.initState();
    isAvailable = widget.bookContent['Total Quantity'] > widget.bookContent['Issued Quantity'];
    try{
      final user = _auth.currentUser;
      if(user != null){
        emailAddress = user.email;
      }
      adminCheck();
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
          color: Colors.black,
        ),
        child: ListView(
          children: [
            TitleBar(
              title: '${widget.bookContent['Book Name']}'.toUpperCase(),
              colour: Colors.white,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image(
                  image: AssetImage('images/dictionary.png'),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Details(
              title: 'Book Code',
              value: '${widget.bookContent['Book Code']}',
              imageName: 'qr-code.png',
            ),
            Details(
              title: 'Author',
              value: '${widget.bookContent['Author']}',
              imageName: 'writer.png',
            ),
            Details(
              title: 'Edition Year',
              value: '${widget.bookContent['Edition Year']}',
              imageName: 'calendar.png',
            ),
            Details(
              title: 'Issued Quantity',
              value: '${widget.bookContent['Issued Quantity']}',
              imageName: 'book.png',
            ),
            Details(
              title: 'Total quantity',
              value:'${widget.bookContent['Total Quantity']}',
              imageName: 'bookshelf.png',
            ),
            FlatButton(
              // If the isAdmin is true the user can cannot issue the book.
              // If the isAvailable is true the user cannot issue the book.
              onPressed: isAdmin ? (){} : isAvailable ? checkIssued : (){
                Fluttertoast.showToast(msg: 'Unavailable',);
              },
              child: isAvailable ?
              IssueButton(text: 'Request Book',colour: Color(0xDD286053),textColour: Color(0xFF3DD597),) :
              IssueButton(text: 'Not Available', colour: Color(0xDD623A42),textColour: Color(0xFFFC555C),),
            ),
          ],
        ),
      ),
    );
  }
}