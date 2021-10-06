import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/Screens/book_screen.dart';

class AdminBookWidget extends StatelessWidget {

  AdminBookWidget({this.bookContent});
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
          // color: Colors.black54,
        ),
        margin: EdgeInsets.symmetric(vertical: 2.0,horizontal: 35.0),
        child: Text(
          'Name : ${bookContent['Book Name']}\nBook Id : ${bookContent['Book Code']}',
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Color(0Xff14274e),
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
              ),
          ),
        ),
      ),
    );
    // child:
  }
}
