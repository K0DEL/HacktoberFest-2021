import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Carousel extends StatelessWidget {
  Carousel({this.bookNameList});
  final List<String> bookNameList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
        ),
        items: bookNameList.map((item) => Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.black45,
            border: Border.all(width: 3.0,color: Colors.white),
          ),
          child: Center(
            child: Text(item,
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 18.0,
                fontFamily: 'Cubano',
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  SmallButton({this.buttonString,this.onPressed,this.colour});
  final String buttonString;
  final Function onPressed;
  final Color colour;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0,),
      padding: EdgeInsets.all(3.0),
      height: 40.0,
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        border: Border.all(
          color: colour,
          width: 4.0,
        ),
        color: Colors.black,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: RaisedButton(
        child: AutoSizeText(buttonString,maxLines: 1,),
        color: colour,
        textColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class UserDataWidget extends StatelessWidget {
  UserDataWidget({this.userData});
  final userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 30.0),
      padding: EdgeInsets.only(left: 25.0,top: 20.0,bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.black45,
        border: Border.all(width: 3.0,color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          SmallUserWidget(
            title: 'Name: ',
            name: '${userData['First Name']} ${userData['Last Name']}',
            iconData: Icon(Icons.person_outline_rounded,color: Colors.pinkAccent,),
          ),
          SizedBox(height: 20.0,),
          SmallUserWidget(
            title: 'Branch: ',
            name: '${userData['Branch']}',
            iconData: Icon(Icons.account_balance_outlined,color: Colors.pinkAccent,),
          ),
          SizedBox(height: 20.0,),
          SmallUserWidget(
            title: 'Roll Number: ',
            name: '${userData['Roll Number']}',
            iconData: Icon(Icons.assignment_ind_outlined,color: Colors.pinkAccent,),
          ),
          SizedBox(height: 20.0,),
          SmallUserWidget(
            title:  'Email ID:',
            name: '${userData['Email Id']}',
            iconData: Icon(Icons.mail_outline_outlined,color: Colors.pinkAccent,),
          ),
          SizedBox(height: 20.0,),
        ],
      ),
    );
  }
}

class SmallUserWidget extends StatelessWidget {
  SmallUserWidget({this.name,this.title,this.iconData});
  final String name;
  final String title;
  final Icon iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: GoogleFonts.concertOne(
              textStyle: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            thickness: 2.0,
            endIndent: 40.0,
            color: Colors.pinkAccent,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconData,
              SizedBox(width: 40.0,),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(name,
                  style: GoogleFonts.concertOne(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
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


class DivisionTitle extends StatelessWidget {

  DivisionTitle({this.title,this.colour});
  final String title;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 60.0,
            width: 5.0,
            margin: EdgeInsets.only(left: 20.0,top: 20.0,bottom: 20.0),
            color: colour
        ),
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.62,
          margin: EdgeInsets.only(top: 20.0,bottom: 20.0),
          padding: EdgeInsets.only(left: 20.0,right: 5.0,top: 5.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0),bottomRight: Radius.circular(5.0)),
          ),
          child: Text(
            title,
            style: GoogleFonts.concertOne(
              textStyle: TextStyle(
                  fontSize: 35.0,
                  color: colour
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ApplicationWidget extends StatelessWidget {

  ApplicationWidget({this.appData});
  final appData;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 35.0,vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(width: 3.0,color: Colors.white),
        color: Colors.black45,
      ),
      child: Text('Book Name: ${appData.data()['Book Name']} \nBook Code: ${appData.data()['Book Code']}',
        style: TextStyle(
          color: Colors.indigoAccent,
          fontSize: 18.0,
          fontFamily: 'Cubano',
        ),
      ),
    );
  }
}

class UserImage extends StatelessWidget {
  UserImage({this.name,this.gender});
  final String name;
  final String gender;

  @override
  Widget build(BuildContext context) {

    Path customPath1 = Path();
    customPath1.addOval(Rect.fromCircle(
      center: Offset(52, 52),
      radius: 56.0,
    ));

    Path customPath2 = Path();
    customPath2.addOval(Rect.fromCircle(
      center: Offset(54, 54),
      radius: 66.0,
    ));


    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(top: 40.0,bottom: 30.0,right: 10.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 3.0,color: Colors.white),
      ),
      child: Column(
        children: [
          DottedBorder(
            customPath: (_) => customPath2,
            color: Colors.purple,
            dashPattern: [18, 10],
            strokeWidth: 8,
            strokeCap: StrokeCap.round,
            child: DottedBorder(
              customPath: (_) => customPath1,
              color: Colors.pink,
              dashPattern: [10, 9],
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              child: CircleAvatar(
                backgroundImage: ExactAssetImage('images/$gender.png'),
                radius: 50.0,
                backgroundColor: Colors.black54,
              ),
            ),
          ),
          SizedBox(height: 25.0,),
          Text(
            'Hey There! $name',
            style: GoogleFonts.lobster(
              textStyle:  TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 30.0,right: 20.0,left: 20.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(width: 3.0,color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'When in doubt go to the Library',
                style: GoogleFonts.oldenburg(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Icon(Icons.format_quote,color: Colors.white,size: 24.0,),
            ],
          ),
          Text(
            '- J.K. Rowling',
            style: GoogleFonts.oldenburg(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
