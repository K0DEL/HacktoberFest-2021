import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/Screens/application_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscan/qrscan.dart' as scanner;

// This is the widget of each search result of application_screen it brings out a bottom sheet for more options.
class AppWidget extends StatefulWidget {
  //appContent are the contents of the particular application doc in applications collection.
  // reviewAgain is called again whenever action is taken on application.
  AppWidget({this.appContent, this.reviewAgain});
  final appContent;
  final Function reviewAgain;

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  // _firestore is Firebase Firestore instance.
  final _firestore = FirebaseFirestore.instance;

  // This Function fetches the data of the particular document with the borrower's email address
  // Then adds the data to userInfoList which was public in the application_screen.dart.
  // The userInfoList is emptied each time this function runs.
  Future userInfo() async {
    try {
      var borrower = widget.appContent['Borrower'];
      final userData = await _firestore.collection('users').doc(borrower).get();
      setState(() {
        userInfoList = [];
        userInfoList.add(Text(
          '${userData['First Name']} ${userData['Last Name']}',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
        userInfoList.add(Text(
          '${userData['Branch']}',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
        userInfoList.add(Text(
          '${userData['Roll Number']}',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  // This function issues the book for the user.
  // First of all the uniqueBookCode is checked. If there exists any doc with the same name that means the code has been assigned to some other book and can't be assigned now.
  // Entry is created in the particular user doc's Applied map of the users collection with the uniqueBookCode and due date.
  // Entry is created in the particular book doc's Borrower map of the books collection with the borrower's email Address and uniqueBookCode.
  // A new doc is created with the uniqueBookCode in issued books collections.
  // Then the applications is deleted after calling deleteApplication().
  void getIssued() async {
    try {
      var borrower = widget.appContent['Borrower'];
      var bookCode = widget.appContent['Book Code'];
      var bookName = widget.appContent['Book Name'];
      var dueDate = date;
      // print(uniqueBookCode);
      // print(date);

      final issuedBookContent =
          await _firestore.collection('issued books').doc(uniqueBookCode).get();
      final bookData = await _firestore.collection('books').doc(uniqueBookCode).get();

      if (issuedBookContent.data() != null || bookData.data() != null || uniqueBookCode == null || uniqueBookCode == '') {
        Fluttertoast.showToast(
          msg: 'Enter Unique Code',
        );
        // print('Enter Unique Code');
      } else {
        // print('Success');
        final bookContent =
            await _firestore.collection('books').doc(bookCode).get();

        int newQuantity = bookContent['Issued Quantity'] + 1;

        _firestore.collection('users').doc(borrower).update({
          'Issued Books.$uniqueBookCode': dueDate,
        });

        _firestore.collection('books').doc(bookCode).update({
          'Issued Quantity': newQuantity,
          'Borrower.$uniqueBookCode': borrower,
        });

        _firestore.collection('issued books').doc(uniqueBookCode).set({
          'Book Code': bookCode,
          'Unique Book Code': uniqueBookCode,
          'Borrower': borrower,
          'Due Date': dueDate,
          'Book Name': bookName,
        });

        deleteApplication();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  // This Function deletes application once the action of accept or reject has been taken over it.
  // It deletes the particular application doc with id = borrower's emailAddress + BookCode
  // It deletes the entry from the applied of the particular user.
  // Then It Pops out the bottom sheet calls reviewApplications again using set state to rebuild the application screen and remove the application from screen.
  void deleteApplication() async {
    try {
      var borrower = widget.appContent['Borrower'];
      var bookCode = widget.appContent['Book Code'];
      Map applied = {};
      var applicationId = borrower + bookCode;

      final userData = await _firestore.collection('users').doc(borrower).get();
      applied = userData.data()['Applied'];

      applied.remove(bookCode);
      _firestore.collection('users').doc(borrower).update({
        'Applied': applied,
      });

      _firestore.collection('applications').doc(applicationId).delete();
      Navigator.pop(context);
      setState(() {
        Fluttertoast.showToast(
          msg: 'Application Updated',
        );
        widget.reviewAgain();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  // This Function checks if the books are available or not.
  // Changes the isAvailable to false if the book's total quantity is equal to the issued quantity.
  void canIssue() async {
    try {
      var bookCode = widget.appContent['Book Code'];
      final bookContent =
          await _firestore.collection('books').doc(bookCode).get();

      isAvailable =
          !(bookContent['Total Quantity'] == bookContent['Issued Quantity']);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0Xff737373),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/applicationBottom.png"),
                  fit: BoxFit.scaleDown,
              alignment: Alignment.lerp(Alignment.centerLeft, Alignment.center, 13)),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    'Application',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color:  Color(0Xff6C63FF),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationThickness: 4.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    elevation: 26.0,
                    shadowColor: Colors.black,
                    color:  Color(0Xffb963ff).withOpacity(0.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 15.0),
                            Text(
                              '• Name      : ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              '• Branch      : ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              '• Roll No.      : ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.0),
                            userInfoList[0],
                            SizedBox(height: 15.0),
                            userInfoList[1],
                            SizedBox(height: 15.0),
                            userInfoList[2],
                            SizedBox(height: 15.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  BottomSheetContents(
                      getIssued:getIssued,
                      deleteApplication: deleteApplication),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        // Whenever the widget is long pressed it calls the canIssue() to check its availability.
        // Then it awaits to get the userInfo of the borrower then it brings up the modal sheet.
        canIssue();
        await userInfo();
        showModalBottomSheet(
          context: context,
          builder: buildBottomSheet,
          isScrollControlled: true,
        );
      },
      child: Text(
          '${widget.appContent['Borrower']} Applied for ${widget.appContent['Book Name']}'),
    );
  }
}

// This class controls what will be displayed on the bottom sheet.
class BottomSheetContents extends StatefulWidget {
  // It takes the function getIssued and deleteApplication as arguments.
  BottomSheetContents({
    this.getIssued,
    this.deleteApplication,
  });
  final VoidCallback getIssued;
  final VoidCallback deleteApplication;

  @override
  _BottomSheetContentsState createState() => _BottomSheetContentsState();
}

class _BottomSheetContentsState extends State<BottomSheetContents> {
  // bottomSheetItems contains item that will be displayed on the bottom sheet.
  List<Widget> bottomSheetItems = [];

  Future pickDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    date = picked;
    return picked.toString();
  }

  // This Functions puts the initial widgets to be displayed.
  // It shows Accept or the Not Available depending on the isAvailable button.
  // The Reject button deletes the application using deleteApplication().
  void bottomSheetPhaseOne() {
    // print(isAvailable);
    // print(userInfoList);
    // bottomSheetItems = userInfoList;
    setState(() {
      bottomSheetItems.add(Row(
        children: [
          isAvailable
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: _boxDecoration1,
                  child: FlatButton(
                    onPressed: bottomSheetPhaseTwo,
                    child: Text(
                      'Accept',
                      style: _textStyle,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: _boxDecoration1,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Not Available',
                      style: _textStyle,
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: _boxDecoration2,
            child: FlatButton(
              onPressed: widget.deleteApplication,
              child: Text(
                'Reject',
                style: _textStyle1,
              ),
            ),
          ),
        ],
      ));
    });
  }
  String __date;
  String barcodeScanRes;
  TextEditingController c = new TextEditingController();
  TextEditingController c1 = new TextEditingController();
  // This function works when the accept button is pressed in PhaseOne.
  // This function takes the uniqueBookCode and due date from the admin when the Accept button is pressed calls getIssued to issue the book.
  void bottomSheetPhaseTwo() {
    setState(() {
      // print('Phase 2 going on!');
      bottomSheetItems = [];
      bottomSheetItems.add(
        Column(
          children: [
            TextFormField(
              controller: c,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    try{
                      setState(() async {
                        barcodeScanRes = await scanner.scan();
                        c.text = barcodeScanRes.substring(1,6);
                        uniqueBookCode = c.text;
                      });}
                    catch(e){
                      print(e);
                    }
                  },
                ),
                labelText: "Enter Unique Code",
                labelStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Email cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) {
                uniqueBookCode = value;
              },
            ),
            TextFormField(
              controller: c1,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  onPressed: (){
                      setState(() async {
                      __date = await pickDate();
                      c1.text = __date.substring(0,10);
                      c1.text = c1.text.split(" ")[0];
                      c1.text = c1.text.split('-').reversed.join('-');
                      });
                  },
                ),
                labelText: "Enter Date",
                labelStyle: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Email cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) {
                print(value);
                },
            ),

            Container(
              margin: EdgeInsets.only(top: 20.0),
              decoration: _boxDecoration2,
              child: FlatButton(
                onPressed: widget.getIssued,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Confirm',
                    style: _textStyle,),
                    Icon(Icons.check,size: 20.0,color: Color(0Xff66ff00)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    bottomSheetPhaseOne();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bottomSheetItems,
        ),
      ),
    );
  }
}

BoxDecoration _boxDecoration1 = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0Xaa6C63FF),
        Color(0Xaa6C63FF),
      ]),
  borderRadius: BorderRadius.circular(10.0),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black87,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(2.0, 2.0), // shadow direction: bottom right
    )
  ],
);

BoxDecoration _boxDecoration2 = BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0Xaa6C63FF),
        Color(0Xaa6C63FF),
      ]),
  borderRadius: BorderRadius.circular(10.0),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black87,
      blurRadius: 2.0,
      spreadRadius: 0.0,
      offset: Offset(2.0, 2.0), // shadow direction: bottom right
    )
  ],
);

TextStyle _textStyle = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontSize: 21,
    color: Color(0Xff66ff00),
    fontWeight: FontWeight.w600,
  ),
);

TextStyle _textStyle1 = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontSize: 21,
    color: Color(0Xffff0066),
    fontWeight: FontWeight.w600,
  ),
);

