// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

// This class build the widget for the issued books displayed and also brings up the bottom sheet.
class IssuedBookWidget extends StatefulWidget {
  IssuedBookWidget({this.issuedBookContent, this.viewIssuedBooks});
  // issuedBookContents contains the data of that particular issued book that is displayed.
  // viewIssuedBooks is called whenever changes are mad to the issued books.
  final issuedBookContent;
  final Function viewIssuedBooks;

  @override
  _IssuedBookWidgetState createState() => _IssuedBookWidgetState();
}

class _IssuedBookWidgetState extends State<IssuedBookWidget> {
  // _firestore is Firebase Firestore instance.
  // fine is calculated by the subtracting the due date from current date.
  // userInfoList contains the details of the borrower.
  final _firestore = FirebaseFirestore.instance;
  var fine;
  var trimmedDate;
  List<Widget> userInfoList = [];

  // This Function fetches the data of the particular document with the borrower's email address
  // Then adds the data to userInfoList which was public in the application_screen.dart.
  // The userInfoList is emptied each time this function runs.
  Future userInfo() async {
    try{
      userInfoList = [];
      var borrower = widget.issuedBookContent['Borrower'];
      final userData = await _firestore.collection('users').doc(borrower).get();
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
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This function calculated the due days of each books by subtracting the due date from the current days.
  // If it is -ve it means that the book is returned in time hence the fine is rounded to zero.
  // If It is +ve it means that the book is returned after the due and hence the no.of extra days are displayed.
  void fineCalculated() {
    try{
      var due = widget.issuedBookContent['Due Date'].toDate();
      var cur = DateTime.now();
      fine = cur.difference(due).inDays;
      if (fine <= 0) {
        fine = 0;
      }
      trimmedDate = due.toString().split(" ")[0];
      trimmedDate = trimmedDate.split('-').reversed.join('-');
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This function deletes the issued book from the issued books collection and the issued map of users.
  // It updates the issued quantity by subtracting one.
  // It uses the uniqueBookCode to delete the users issued map entry.
  void deleteIssuedBook() async {
    try {
      var uniqueBookCode = widget.issuedBookContent['Unique Book Code'];
      var borrower = widget.issuedBookContent['Borrower'];
      var bookCode = widget.issuedBookContent['Book Code'];
      int newQuantity;
      Map issuedBooks = {};
      Map borrowerList = {};

      final userData = await _firestore.collection('users').doc(borrower).get();
      issuedBooks = userData.data()['Issued Books'];

      issuedBooks.remove(uniqueBookCode);
      _firestore.collection('users').doc(borrower).update({
        'Issued Books': issuedBooks,
      });

      final bookData = await _firestore.collection('books').doc(bookCode).get();
      borrowerList = bookData.data()['Borrower'];
      newQuantity = bookData.data()['Issued Quantity'] - 1;

      borrowerList.remove(uniqueBookCode);
      _firestore.collection('books').doc(bookCode).update({
        'Borrower': borrowerList,
        'Issued Quantity': newQuantity,
      });

      _firestore.collection('issued books').doc(uniqueBookCode).delete();
      Navigator.pop(context);
      setState(() {
        widget.viewIssuedBooks();
        Fluttertoast.showToast(msg: 'Books Updated',);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This builds the bottom sheet/
  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0Xff737373),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/issuedbottomSheet.png"),fit: BoxFit.fitWidth),
            color: Color(0Xff737373),
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
                  'Borrower Details',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Color(0Xff6B63FF),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationThickness: 4.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                  elevation: 26.0,
                  shadowColor: Colors.black,
                  color:  Color(0Xffb963ff).withOpacity(0.5),
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
                          Text('• Branch   : ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          SizedBox(height: 15.0),
                          Text('• Roll No   : ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          SizedBox(height: 15.0),
                          Text('• Fine         : ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          SizedBox(height: 15.0),
                          Text('• Due Date: ',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
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
                          Text('$fine',style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),),),
                          SizedBox(height: 15.0),
                          Text('$trimmedDate',style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),),),
                          SizedBox(height: 15.0),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0,),
                Container(
                  decoration: BoxDecoration(
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
                        offset: Offset(
                            2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120.0),
                    child: Text('Remove',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),),),
                    onPressed: deleteIssuedBook,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        // userInfo and fineCalculated run before the bottom sheet starts building.
        await userInfo();
        fineCalculated();
        showModalBottomSheet(
          context: context,
          builder: buildBottomSheet,
          isScrollControlled: true,
        );
      },
      child: Text(
          '${widget.issuedBookContent['Book Name']} with the unique code ${widget.issuedBookContent['Unique Book Code']}'),
    );
  }
}
