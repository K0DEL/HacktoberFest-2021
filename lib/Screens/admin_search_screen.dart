import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/components/admin_search_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscan/qrscan.dart' as scanner;

// This Page simply searches for the book of the given name.
class AdminSearchScreen extends StatefulWidget {
  static String id = 'admin_search_screen';
  @override
  _AdminSearchScreenState createState() => _AdminSearchScreenState();
}

class _AdminSearchScreenState extends State<AdminSearchScreen> {
  // bookName is entered by the user.
  // _firestore is the Firestore Instance.
  // bookWidgetList are the search results for the entered name.
  String bookName;
  bool ignore = false;
  final _firestore = FirebaseFirestore.instance;
  List<Widget> bookWidgetList = [];

  // This functions searches for the books with the name entered by the user.
  // Then for each book found, it adds a BookWidget to bookWidgetsList.
  // bookWidgetsList is emptied before every search.
  void bookSearch(String bookName) async {
    try {
      bookWidgetList.clear();
      var bookData = await _firestore
          .collection('books')
          .where('Book Name', isEqualTo: bookName)
          .get();
      if (bookData.docs.isEmpty) {
        bookData = await _firestore
            .collection('books')
            .where('Book Code', isEqualTo: bookName)
            .get();
        if (bookData.docs.isEmpty) {
          Fluttertoast.showToast(
            msg: 'Book Not Found',
          );
        }
      }
      for (var book in bookData.docs) {
        var bookContent = book.data();
        setState(() {
          bookWidgetList.add(AdminBookWidget(bookContent: bookContent));
        });
      }
      setState(() {
        ignore = false;
      });
    } catch (e) {
      setState(() {
        ignore = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  TextEditingController c = new TextEditingController();
  String barcodeScanRes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/Search.png"),
                alignment: Alignment.lerp(
                    Alignment.bottomCenter, Alignment.center, 0.20)),
            color: Colors.white),
        child: Container(
          margin: EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0)),
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                elevation: 26.0,
                shadowColor: Colors.white,
                color: Color(0Xaaffffff).withOpacity(0.2),
                child: TextFormField(
                  controller: c,
                  autofocus: true,
                  onChanged: (value) {
                    bookName = value;
                  },
                  validator: (val) {
                    if (val.length == 0) {
                      return "Search Books";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IgnorePointer(
                      ignoring: ignore,
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            ignore = true;
                          });
                          bookSearch(bookName == null ? '' : bookName);
                        },
                      ),
                    ),
                    labelText: "Search Books",
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
                      borderSide: BorderSide(color: Colors.white),
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
                      try {
                        setState(() async {
                          barcodeScanRes = await scanner.scan();
                          c.text = barcodeScanRes.substring(7, 12);
                          bookName = barcodeScanRes.substring(7, 12);
                        });
                      } catch (e) {
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
                    borderRadius: BorderRadius.circular(35.0)),
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                elevation: bookWidgetList.length == 0 ? 0 : 26.0,
                shadowColor: Colors.white,
                color: Color(0Xaab963ff).withOpacity(0.2),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: bookWidgetList.length == 0
                        ? EdgeInsets.all(0)
                        : const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                    child: Builder(
                      builder: (context) {
                        return Column(
                          children: bookWidgetList,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
