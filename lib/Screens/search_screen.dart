import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_management_system/components/search_screen_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';


// This Page simply searches for the book of the given name.
class SearchScreen extends StatefulWidget {
  static String id = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  // _firestore is the Firestore Instance.
  // bookWidgetList are the search results for the entered name.
  // bookName is entered by the user.
  String bookName;
  final _firestore = FirebaseFirestore.instance;
  List <Widget> bookWidgetList = [];
  bool ignore = false;


  // This functions searches for the books with the name entered by the user.
  // Then for each book found, it adds a BookWidget to bookWidgetsList.
  // bookWidgetsList is emptied before every search.
  void bookSearch(String bookName) async {
    try{
      bookWidgetList.clear();
      final bookData = await _firestore.collection('books').where('Book Name', isEqualTo: bookName).get();
      if(bookData.docs.isEmpty){
        Fluttertoast.showToast(msg: 'Book Not Found',);
      }
      for(var book in bookData.docs) {
        var bookContent = book.data();
        setState(() {
          bookWidgetList.add(BookWidget(bookContent: bookContent));
          ignore = false;
        });
      }
    }catch(e){
      setState(() {
        ignore = false;
      });
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  @override
  void initState() {
    super.initState();
    bookSearch(bookName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Alone.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 20.0,),
            TitleBar(
              title: 'Search Books',
              colour: Colors.white,
            ),
            IgnorePointer(
              ignoring: ignore,
              child: SearchBox(
                icon: Icons.search,
                onPressed: (){
                  setState(() {
                    ignore = true;
                  });
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  bookSearch(bookName == null ? bookName : bookName.toLowerCase());
                },
                onChanged: (value){
                  bookName = value;
                },
              ),
            ),
            Column(
              children: bookWidgetList,
            ),
            SizedBox(height: 40.0,),
          ],
        ),
      ),
    );
  }
}