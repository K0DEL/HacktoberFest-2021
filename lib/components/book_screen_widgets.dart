import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            height: 30.0,
            width: 5.0,
            margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0,bottom: 20.0),
            color: colour
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.only(right: 20.0,top: 15.0,bottom: 20.0),
          child: Text(
            title,
            style: GoogleFonts.permanentMarker(
              textStyle: TextStyle(
                  fontSize: 25.0,
                  color: colour
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Details extends StatelessWidget {

  Details({this.title,this.imageName,this.value});
  final String title;
  final String imageName;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(width: 3.0,color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.concertOne(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60.0,
                margin: EdgeInsets.only(top: 10.0),
                child: Image(
                  image: AssetImage('images/$imageName'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    style: GoogleFonts.concertOne(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IssueButton extends StatelessWidget {

  IssueButton({this.text,this.colour,this.textColour});
  final String text;
  final Color colour;
  final Color textColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colour,
        border: Border.all(width: 3.0,color: textColour),
      ),
      child: Text(
        text,
        style: GoogleFonts.concertOne(
          textStyle: TextStyle(
            color: textColour,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}