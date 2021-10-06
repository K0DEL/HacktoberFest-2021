import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/Screens/book_screen.dart';

// BookWidget takes the bookContent fetched by firestore for each book that matches search.
// It then pushes to the book_screen.
class BookWidget extends StatelessWidget {

  BookWidget({this.bookContent});
  final bookContent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector detects whenever the widget is pressed.
      // Then it passes the current book content to the next screen.
      // Due to the passing of data we can't use Navigator.pushNamed().
      onTap: (){
        //Navigator.pushNamed(context,BookScreen.id,arguments: bookContent);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context){
                return BookScreen(bookContent: bookContent);}
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black54,
        ),
        margin: EdgeInsets.symmetric(vertical: 2.0,horizontal: 30.0),
        padding: EdgeInsets.only(left:40.0,top: 10.0,right: 10.0,bottom: 10.0),
        child: Text(
          'Book Name : ${bookContent['Book Name']}\nBook Code : ${bookContent['Book Code']}',
          style: GoogleFonts.permanentMarker(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          )
        ),
      ),
    );
    // child:
  }
}

class TitleBar extends StatelessWidget {

  TitleBar({this.title,this.colour});
  final String title;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 50.0,
            width: 5.0,
            margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0,bottom: 20.0),
            color: colour
        ),
        Container(
          margin: EdgeInsets.only(right: 20.0,top: 20.0,bottom: 20.0),
          child: Text(
            title,
            style: GoogleFonts.concertOne(
              textStyle: TextStyle(
                  fontSize: 40.0,
                  color: colour
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchBox extends StatelessWidget {

  SearchBox({@required this.icon, @required this.onPressed,this.onChanged});
  final IconData icon;
  final Function onPressed;
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.white,
          width: 5.0,
        ),
        color: Colors.white70,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Book Name',
              ),
              cursorColor: Colors.black,
              style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              onChanged: onChanged,
            ),
          ),
          RawMaterialButton(
            onPressed: onPressed,
            child: Icon(
              icon,
              color: Colors.black,
            ),
            elevation: 6.0,
            constraints: BoxConstraints.tightFor(
              width: 56.0,
              height: 56.0,
            ),
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }
}