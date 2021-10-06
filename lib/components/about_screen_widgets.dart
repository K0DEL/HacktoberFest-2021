import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageAvatar extends StatelessWidget {

  ImageAvatar({this.name});
  final String name;

  @override
  Widget build(BuildContext context) {

    Path customPath1 = Path();
    customPath1.addOval(Rect.fromCircle(
      center: Offset(47, 47),
      radius: 51.0,
    ));

    Path customPath2 = Path();
    customPath2.addOval(Rect.fromCircle(
      center: Offset(49, 49),
      radius: 61.0,
    ));

    Path customPath3 = Path();
    customPath3.addOval(Rect.fromCircle(
      center: Offset(51, 51),
      radius: 70.0,
    ));


    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 40.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 3.0,color: Colors.white),
      ),
      child: Column(
        children: [
          DottedBorder(
            customPath: (_) => customPath3,
            color: Colors.pink,
            dashPattern: [25, 10],
            strokeWidth: 6,
            strokeCap: StrokeCap.round,
            child: DottedBorder(
              customPath: (_) => customPath2,
              color: Colors.purple,
              dashPattern: [15, 9],
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              child: DottedBorder(
                customPath: (_) => customPath1,
                color: Colors.indigo,
                dashPattern: [10, 9],
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/$name.jpg'),
                  radius: 45.0,
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Text(
            name,
            style: GoogleFonts.permanentMarker(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DivideBar extends StatelessWidget {

  DivideBar({this.title,this.colour});
  final String title;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top:10.0,bottom: 20.0),
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 3.0,
              color: colour,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.concertOne(
                textStyle: TextStyle(
                  fontSize: 40.0,
                  color: colour,
                ),
              ),
            ),
          ),
        ),
        // SizedBox(
        //   child: Divider(
        //     color: colour,
        //     thickness: 3.0,
        //     indent: 30.0,
        //     endIndent: 30.0,
        //   ),
        // ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}

class MoreInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info,color: Colors.white,),
            SizedBox(width: 10.0,),
            Text('MoreInfo',
              style: GoogleFonts.concertOne(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        showAboutDialog(
          applicationName: 'LMS',
          context: context,
          applicationVersion: 'v1.0.1',
          applicationIcon: Image(image: AssetImage('images/small_logo.png'),),
          applicationLegalese: 'Icon made by Darius Dan and Freepik from www.flaticon.com\nWallpapers made Available by\nunsplash.com\nundraw.io\nFiqih Anggun from artstation.com',
        );
      },
    );
  }
}

class InstructionsWidget extends StatefulWidget {
  InstructionsWidget({this.question,this.answer});
  final String question;
  final String answer;
  @override
  _InstructionsWidgetState createState() => _InstructionsWidgetState();
}

class _InstructionsWidgetState extends State<InstructionsWidget> {

  List<Widget> displayList = [];
  double _height = 50;

  @override
  void initState() {
    super.initState();
    displayList = [];
    displayList.add(
      Text(
        widget.question,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: AnimatedContainer(
            width: MediaQuery.of(context).size.width,
            height: _height,
            margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
            decoration: BoxDecoration(
            ),
            duration: Duration(milliseconds: 500),
            child: ListView(
              children: displayList,
            ),
          ),
          onTap: (){
            setState(() {
              if(_height == 50){
                _height = 130;
                displayList.add(
                  Text(
                    '\n${widget.answer}',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              }
              else{
                _height = 50;
                displayList = [];
                displayList.add(
                  Text(
                    widget.question,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              }
            });
          },
        ),
        SizedBox(
          child: Divider(
            thickness: 2.0,
            color: Colors.white,
            indent: 30.0,
            endIndent: 30.0,
          ),
        ),
      ],
    );
  }
}

class ContactUs extends StatelessWidget {

  void sendMail() async {
    const uri =
        'mailto:thecodepolice@gmail.com?subject=Greetings&body=Hello%20World';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $uri');
    }
  }

  void sendGitHub() async {
    const uri = 'https://github.com/Im-gkira/library_management_system';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0,color: Colors.white),
      ),
      child: Column(
        children: [
          Text(
            'If you are facing any issues then feel free to contact us any time.\n\nContact Info\n',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.mail,color: Colors.white,size: 32,),
                    Text(
                      'Mail Us',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: sendMail,
              ),
              GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage(
                        'images/github.png',
                      ),
                      height: 32.0,
                      width: 32.0,
                    ),
                    Text(
                      'Github',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: sendGitHub,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

