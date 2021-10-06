import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/components/issued_book_widget.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscan/qrscan.dart' as scanner;

// This Class removes the books that are returned.
class IssuedBooks extends StatefulWidget {
  static String id = 'issued_books';
  @override
  _IssuedBooksState createState() => _IssuedBooksState();
}

class _IssuedBooksState extends State<IssuedBooks> {
  // _firestore is the Firebase Firestore instance.
  // issuedBookWidgetList stores the widget for each issued book dsiplayed.
  // enteredCode is the unique code of the book to be returned.
  final _firestore = FirebaseFirestore.instance;
  List<Widget> issuedBookWidgetList = [];
  List<Widget> enteredBookWidgetList = [];
  var enteredCode;

  // Gets the information of all the books that are issued.
  // Creates a widget for each issued book and adds to the list.
  // The list is emptied in the beginning.
  // The data is sorted in accordance to the due date to show the whose date is near on the top.
  void viewIssuedBooks() async {
    try {
      var bookData =
          await _firestore.collection('issued books').orderBy('Due Date').get();
      setState(() {
        issuedBookWidgetList = [];
        for (var apps in bookData.docs) {
          var issuedBookContent = apps.data();
          issuedBookWidgetList.add(
            IssuedBookWidget(
              issuedBookContent: issuedBookContent,
              viewIssuedBooks: viewIssuedBooks,
            ),
          );
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  // This function display the issued book whose unique code is entered if such book exists.
  // The function adds the book widget to the list after it is emptied.
  void viewEnteredBook() async {
    try {
      var bookData =
          await _firestore.collection('issued books').doc(enteredCode).get();
      if (bookData.data() == null) {
        Fluttertoast.showToast(
          msg: 'Book Not Found',
        );
        setState(() {
          enteredBookWidgetList = [];
        });
        // print('Book Not Found');
      } else {
        setState(() {
          enteredBookWidgetList = [];
          enteredBookWidgetList.add(Column(
            children: [
              IssuedBookWidget(
                  issuedBookContent: bookData,
                  viewIssuedBooks: viewEnteredBook),
            ],
          ));
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  //int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  TextEditingController c = new TextEditingController();
  String barcodeScanRes;

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TabBar(
          onTap: (value) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
          },
          labelPadding: EdgeInsets.only(top: 10.0),
          labelStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          )),
          labelColor: Colors.black,
          tabs: [
            Tab(
              icon: Icon(Icons.search),
              text: 'Search',
              iconMargin: EdgeInsets.all(0.0),
            ),
            Tab(
                icon: Icon(Icons.list),
                text: 'All',
                iconMargin: EdgeInsets.all(0.0)),
          ],
        ),
        body: TabBarView(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/allBooks.png"),
                  alignment: Alignment.lerp(Alignment.bottomCenter,Alignment.center, 0.40)
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    margin:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                    elevation: 26.0,
                    shadowColor: Colors.white,
                    color: Color(0Xaaffffff).withOpacity(0.2),
                    child: TextFormField(
                      controller: c,
                      autofocus: true,
                      keyboardAppearance: Brightness.dark,
                      onChanged: (value) {
                        enteredCode = value;
                      },
                      validator: (val) {
                        if (val.length == 0) {
                          Fluttertoast.showToast(
                            msg: 'Type The Book Code',
                          );
                          return "Please type the code of the book";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.search,color: Colors.black,
                              size: 24,),
                            onPressed: viewEnteredBook),
                        labelText: "Enter Unique Code of the Book",
                        labelStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0XAA6C63FF).withOpacity(0.9),
                              Color(0Xaa6C63FF).withOpacity(0.9),
                            ]),
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        onPressed: () {
                          try{
                            setState(() async {
                              barcodeScanRes = await scanner.scan();
                              c.text = barcodeScanRes.substring(1,6);
                              enteredCode = barcodeScanRes.substring(1,6);
                            });}
                          catch(e){
                            print(e);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: AutoSizeText('Scan',
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    margin:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    elevation: enteredBookWidgetList.length == 0 ? 0 : 26.0,
                    shadowColor: Colors.white,
                    color: Color(0Xaab963ff).withOpacity(0.2),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: enteredBookWidgetList.length == 0
                            ? EdgeInsets.all(0)
                            : const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 10.0),
                        child: DefaultTextStyle(
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Color(0Xff14274e),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.6,
                            ),
                          ),
                          child: Builder(
                            builder: (context) {
                              return Column(
                                children: enteredBookWidgetList,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/allBooks.png"),
                ),
                color: Colors.white,
              ),
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text(
                          'To view Please Press the Button',
                          style: GoogleFonts.montserrat(
                            fontSize: 21.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      )),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    margin:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    elevation: issuedBookWidgetList.length == 0 ? 0 : 26.0,
                    shadowColor: Colors.white,
                    color: Color(0Xaab963ff).withOpacity(0.2),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 15.0),
                        child: DefaultTextStyle(
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Color(0Xff14274e),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.6,
                              )),
                          child: Builder(
                            builder: (context) {
                              return SizedBox(
                                height: 400.0,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                      children: List.generate(
                                          issuedBookWidgetList.length, (index) {
                                    return Column(children: [
                                      issuedBookWidgetList[index],
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Text("****"),
                                      SizedBox(
                                        height: 15.0,
                                      )
                                    ]);
                                  })),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color(0Xaa6C63FF).withOpacity(0.9),
                                Color(0Xaa6C63FF).withOpacity(0.9),
                              ]),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: FlatButton(
                            child: AutoSizeText('Check All Issued Books',
                                maxLines: 1,
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.6,
                                  color: Colors.white,
                                )),
                            onPressed: viewIssuedBooks),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
