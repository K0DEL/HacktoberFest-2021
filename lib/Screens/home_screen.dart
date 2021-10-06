import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_management_system/components/home_screen_widgets.dart';
import 'package:library_management_system/Screens/search_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_management_system/Screens/about_screen.dart';

// This is the home screen of the normal user and displays all the information of the user.
class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // A Refresh Indicator requires a Key to work which is declared here.
  // currentBackPressTime is used by onWillPop() to check the difference of time in 2 consecutive back presses.
  // _auth is Firebase Authorization Instance.
  // _firestore is Firebase Firestore Instance.
  // emailAddress is taken with the help of loggedInUser which automatically fetches user's email address using Firebase Authorization.
  // fine is the fine calculated for the issued/due books.
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  DateTime currentBackPressTime;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String emailAddress;
  var fine;
  Map userData = {
    'First Name' : ' ',
    'Last Name' : ' ',
    'Applied' : {},
    'Branch' : ' ',
    'Issued Books' : {},
    'Roll Number' : ' ',
    'Email Id' : ' ',
  };
  List<String> bookNameList = [];
  List<Widget> applicationList = [];
  bool isLoading = true;

  // This function calculated the due days of each books by subtracting the due date from the current days.
  // If it is -ve it means that the book is returned in time hence the fine is rounded to zero.
  // If It is +ve it means that the book is returned after the due and hence the no.of extra days are displayed.
  void fineCalculated(var data){
    var dueDate = data['Due Date'].toDate();
    var currentDate = DateTime.now();
    fine = currentDate.difference(dueDate).inDays;
    if(fine <= 0){
      fine = 0;
    }
  }

  // This function fetches the all the data of the users including the details, issued books and applications you send for the various books.
  // userData fetches the specific doc data with the document id == logged in users's email address, from the users collection.
  // bookData fetches the specific doc data where the borrower == logged in users's email Address, from the issued books collection and calls fineCalculate() to calculate fine on each book.
  // applicationData fetches the specific doc data where the borrower == logged in users's email Address, from the applications collection
  Future<void> fetchData() async {
    try{
      var trimmedDate;
      var dueDate;
      final uData = await _firestore.collection('users').doc(emailAddress).get();

      bookNameList = [];
      final bookData = await _firestore.collection('issued books').where('Borrower',isEqualTo: emailAddress).get();
      for(var data in bookData.docs){
        fineCalculated(data.data());
        dueDate = data.data()['Due Date'].toDate().toString();
        trimmedDate = dueDate.split(" ")[0];
        trimmedDate = trimmedDate.split('-').reversed.join('-');

        bookNameList.add('Book Code: ${data.data()['Book Code']} \nBook Name: ${data.data()['Book Name']} \nUnique Book Code: ${data.data()['Unique Book Code']} \nDue Date: $trimmedDate \nFine: $fine');
      }

      if(bookData.docs.isEmpty){
        bookNameList.add('No Books Issued Yet!');
      }

      applicationList = [];
      final applicationData = await _firestore.collection('applications').where('Borrower',isEqualTo: emailAddress).get();
      for(var appData in applicationData.docs){
        applicationList.add(ApplicationWidget(appData: appData,));
      }

      setState(() {
        userData = uData.data();
      });

    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
  }

  // This function returns a bool for onWillPop.
  // It checks if the button is pressed 2 times within the interval of 2 seconds then it will close the app.
  // It returns false always which will prohibit the user from going back to the login or enter_details screen.
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(false);
  }

  void delayBuild() async {
    Duration threeSeconds = Duration(seconds: 3);
    await Future.delayed(threeSeconds,(){});
    setState(() {
      isLoading = false;
    });
  }

  // This function is executed as soon as the widget is build.
  // The function calls the fetchData()
  @override
  void initState() {
    super.initState();
    try{
      final user = _auth.currentUser;
      if(user != null){
        emailAddress = user.email;
      }
      fetchData();
    }catch(e){
      Fluttertoast.showToast(msg: e.toString(),);
    }
    delayBuild();
  }

  @override
  Widget build(BuildContext context) {
    //Wrapped the scaffold into the WillPopScope to control the popping of screen.
    //onWillPop takes a bool which allows the screen to popped or not on the basis of it.
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/unsplash.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: isLoading ?
          Container(
            color: Colors.black,
            child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  strokeWidth: 5.0,
                  backgroundColor: Colors.pink,
                )
            ),
          ) :
          RefreshIndicator(
            // RefreshIndicator is added to bring the scroll down to refresh functionality.
            // key takes the global key declared.
            // onRefresh takes the function to be called when app is refreshed.
            // child of this widget can only on ListView.
            key: _refreshIndicatorKey,
            onRefresh: fetchData,
            child: ListView(
              children: [
                SizedBox(height: 20.0,),
                UserImage(name: userData['First Name'],gender: userData['Gender']),
                Quote(),
                DivisionTitle(
                  title: 'Profile',
                  colour: Color(0xDDff499e),
                ),
                UserDataWidget(userData:userData,),
                DivisionTitle(
                  title: 'Issued Books',
                  colour: Colors.purpleAccent,
                ),
                Carousel(bookNameList: bookNameList),
                SizedBox(height: 50.0,),
                Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    DivisionTitle(
                      title: 'Applications',
                      colour: Colors.indigo,
                    ),
                    SmallButton(
                      buttonString: 'Apply',
                      onPressed: (){
                        Navigator.pushNamed(context, SearchScreen.id);
                      },
                      colour: Colors.indigoAccent,
                    ),
                  ],
                ),
                Column(
                  children: applicationList,
                ),
                SizedBox(height: 20.0,),
                FlatButton(
                  child: Icon(
                    Icons.info,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context){
                      return AboutScreen(isAdmin: false,);
                        }
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}