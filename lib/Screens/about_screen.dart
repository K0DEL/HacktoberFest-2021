import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:library_management_system/components/about_screen_widgets.dart';

class InstructionsFormat{
  InstructionsFormat({this.question,this.answer});
  String question;
  String answer;
}

List<InstructionsFormat> userInstructionsList = [
  InstructionsFormat(question: 'How to search for books?',answer: 'One the Home screen navigate to the applications section and tap the apply button.'),
  InstructionsFormat(question: 'What do I search books with?',answer: 'Just type the name of the book and that book will appear apparently all the books are displayed already. Tap the result for more options.'),
  InstructionsFormat(question: 'Unable to request for the book?',answer: 'The book that you have already applied for or have issued already can\'t be applied again.'),
  InstructionsFormat(question: 'Applied for the book but not showing in applications?',answer: 'Try to refresh the home page to get the info. As it is not updated instantly.'),
  InstructionsFormat(question: 'How to return a particular book?',answer: 'That is something that only the admin of the app can do. Contact The Library Administrator to return the book.'),
];

List<InstructionsFormat> adminInstructionsList = [
  InstructionsFormat(question: 'How to view The Applications?',answer: 'Navigate to Applications using the bottom navigation bar and then scroll down hit the view all button'),
  InstructionsFormat(question: 'How to accept/reject Applications?',answer: 'Long press any application result and then choose the option. Enter the necessary details if you wish to accept and then hit accept. '),
  InstructionsFormat(question: 'What do I search books with?',answer: 'Just type the name of the book and that book will appear apparently all the books are displayed already. Tap the result for more options.'),
  InstructionsFormat(question: 'How to view the Due Books?',answer: 'Navigate to the issued books and hit view all. Long press any result to view the borrower details and dues.'),
  InstructionsFormat(question: 'How to remove a particular returned books?',answer: 'Navigate to the issued books page and then search with the particular unique code.'),
  InstructionsFormat(question: 'How to add a new book to the library?',answer: 'Hit the Floating Action Button. Enter the necessary details make sure they are correct and voila the book is added!'),
];

class AboutScreen extends StatefulWidget {

  AboutScreen({this.isAdmin});
  final bool isAdmin;

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {


  final List<String> developers = ['Keshav', 'Gurkirat', 'Siddhant'];
  final CarouselController _controller = CarouselController();
  final List<Widget> instructionWidgetList = [];
  InstructionsFormat _instructionsFormat = InstructionsFormat();



  @override
  void initState() {
    super.initState();
    if(widget.isAdmin){
      for(_instructionsFormat in adminInstructionsList){
        instructionWidgetList.add(InstructionsWidget(question: _instructionsFormat.question,answer: _instructionsFormat.answer,),
        );
      }
    }
    else{
      for(_instructionsFormat in userInstructionsList){
        instructionWidgetList.add(InstructionsWidget(question: _instructionsFormat.question,answer: _instructionsFormat.answer,),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06090F),
      body: ListView(
        children: [
          SizedBox(height: 50.0,),
          Center(
              child:
              Text(
                'LMS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60.0,
                    fontFamily: 'Cubano'),
              ),
          ),
          Center(
              child: Text(
                'Version 1.0.1',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Cubano'),
              ),
          ),
          SizedBox(
            height: 20.0,
            child: Divider(
              indent: 30.0,
              endIndent: 30.0,
              thickness: 3.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30.0,),
          DivideBar(title: 'The Team',colour: Colors.pink,),
          SizedBox(height: 10.0,),
          CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
              ),
              carouselController: _controller,
              items: developers.map((item) => ImageAvatar(name: item,)).toList()),
          SizedBox(height: 50.0,),
          DivideBar(title: 'Contact Us',colour: Colors.purple,),
          SizedBox(height: 10.0,),
          ContactUs(),
          SizedBox(height: 50.0,),
          DivideBar(title: 'FAQs',colour: Colors.blue,),
          SizedBox(height: 20.0,),
          SingleChildScrollView(
            child: Column(
              children: instructionWidgetList,
            ),
          ),
          SizedBox(height: 30.0,),
          MoreInfo(),
          SizedBox(height: 30.0,),
        ],
      ),
    );
  }
}



// class AboutOptions extends StatefulWidget {
//   @override
//   _AboutOptionsState createState() => _AboutOptionsState();
// }
//
// class _AboutOptionsState extends State<AboutOptions> {
//   final CarouselController _controller = CarouselController();
//
//   final List<String> test = ['User','Admin'];
//   int _current = 0;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: test.map((item) {
//             int index = test.indexOf(item);
//             return GestureDetector(
//               child: Container(
//                 child: Text(
//                   item,
//                   style: TextStyle(
//                     color: _current == index
//                         ? Colors.blue
//                         : Colors.white,
//                   ),
//                 ),
//               ),
//               onTap: (){
//                 _controller.animateToPage(_current == 0 ? 1 : 0);
//               },
//             );
//           }).toList(),
//         ),
//         CarouselSlider(items: test.map((item) => Instructions()).toList(),
//           options: CarouselOptions(
//             viewportFraction: 1,
//             initialPage: 0,
//             enableInfiniteScroll: false,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _current = index;
//                 });
//               },
//         ),
//           carouselController: _controller,
//         ),
//       ],
//     );
//   }
// }
