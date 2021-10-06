import 'package:auto_size_text/auto_size_text.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_system/Screens/application_screen.dart';
import 'package:library_management_system/Screens/admin_search_screen.dart';
import 'package:library_management_system/Screens/issued_books_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_management_system/Screens/add_books_screen.dart';
import 'package:library_management_system/Screens/about_screen.dart';

// This Screen is the home screen of the admin and provides different options than the home screen of the user.
class AdminScreen extends StatefulWidget {
  static String id = 'admin_screen';

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int x;
  int y;
  int _currentIndex = 0;
  PageController _pageController;

  void countBooks() async {
    try {
      QuerySnapshot _myDoc =
          await FirebaseFirestore.instance.collection('books').get();
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;
      var s = 0;
      for (var i = 0; i < _myDocCount.length; i++) {
        s = s + _myDocCount[i]['Total Quantity'];
      }
      setState(() {
        x = s;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    } // Count of Documents in Collection
  }

  void countIssuedBook() async {
    try {
      QuerySnapshot _myDoc =
          await FirebaseFirestore.instance.collection('issued books').get();
      List<DocumentSnapshot> _myDocCount = _myDoc.docs;
      setState(() {
        y = _myDocCount.length;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    } // Count of Documents in Collection
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    countBooks();
    countIssuedBook();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (x == null || y == null)
      return Container(
          color: Colors.black,
          child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                strokeWidth: 5.0,
                backgroundColor: Colors.pink,
              )
          ),
        );
    else
      return Scaffold(
          body: SizedBox.expand(
            child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: [
                  RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () async {
                      countIssuedBook();
                      countBooks();
                      // setState(() {
                      //   return AdminScreen();
                      // });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/admin.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.bottomCenter),
                          gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.white,
                                Colors.white,
                              ])),
                      child: ListView(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            margin: EdgeInsets.only(left: 40.0,top: 20.0,right: 40.0,bottom: 10.0),
                            elevation: 26.0,
                            shadowColor: Colors.white,
                            color: Color(0Xaab963ff).withOpacity(0.2),
                            child: Container(
                                alignment: Alignment.bottomLeft,
                                height: 60,
                                width: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image(
                                          image: AssetImage("images/sonepat.png"),
                                          fit: BoxFit.fill,
                                          alignment: Alignment.topLeft,
                                        ),
                                        SizedBox(width: 10,),
                                        Text('IIITS',
                                          style: GoogleFonts.arvo(
                                            fontSize: 32.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0Xcc33415c),
                                            letterSpacing: 1.6,
                                          ),),
                                      ],
                                    ),
                                    Container(
                                      child: FlatButton(
                                        child: Icon(
                                          Icons.info,
                                          size: 38.0,
                                          color: Color(0Xff6B63FF),
                                        ),
                                        onPressed: (){
                                          Navigator.push(context,MaterialPageRoute(builder: (context){
                                            return AboutScreen(isAdmin: true,);
                                          }
                                          ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0)),
                                  margin: EdgeInsets.only(left: 40.0,top: 3.0,right: 5.0),
                                  elevation: 26.0,
                                  shadowColor: Colors.white,
                                  color: Color(0Xaab963ff).withOpacity(0.2),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Text('Total Books',style: _textStyle,),
                                        Text('$x',style: _style,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0)),
                                  margin: EdgeInsets.only(left:5,right: 40.0,top: 3.0),
                                  elevation: 26.0,
                                  shadowColor: Colors.white,
                                  color: Color(0Xaab963ff).withOpacity(0.2),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                            child: Text(
                                          'Available',
                                              style: _textStyle,
                                        )),
                                        Text('${x - y}',style: _style,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 10.0),
                            elevation: 26.0,
                            shadowColor: Colors.white,
                            color: Color(0Xaab963ff).withOpacity(0.2),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 2.0),
                                        ),
                                        child: ColoredBox(
                                          color: Color(0XFFff6b63),
                                          child:
                                              SizedBox(width: 12, height: 12),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      AutoSizeText(
                                        'Total Books',
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                          color: Color(0Xaa000839),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 2.0),
                                        ),
                                        child: ColoredBox(
                                          color: Colors.blue,
                                          child:
                                              SizedBox(width: 12, height: 12),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      AutoSizeText(
                                        'Total No. of Issued Books',
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                              color: Color(0Xaa000839),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                        )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      PieChart(PieChartData(
                                        sections: [
                                          PieChartSectionData(
                                            value:
                                                ((y / x) * 100).roundToDouble(),
                                            title:
                                                '${((y / x) * 100).roundToDouble()}%',
                                            color: Color(0Xff6C63FF),
                                            radius: 100.0,
                                            titlePositionPercentageOffset: 0.75,
                                            titleStyle: GoogleFonts.montserrat(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          PieChartSectionData(
                                              value: ((x - y) * 100 / x)
                                                  .roundToDouble(),
                                              radius: 100.0,
                                              color: Color(0XffFF6584).withOpacity(0.9),
                                              title:
                                                  '${((x - y) * 100 / x).roundToDouble()}%',
                                              titlePositionPercentageOffset:
                                                  0.5,
                                              titleStyle:
                                                  GoogleFonts.montserrat(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ],
                                        centerSpaceRadius: 8.0,
                                        centerSpaceColor: Color(0Xaa2E2E42),
                                        sectionsSpace: 5,
                                        pieTouchData: PieTouchData(
                                          enabled: true,
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: ApplicationScreen(),
                  ),
                  Container(
                    child: AdminSearchScreen(),
                  ),
                  Container(
                    child: IssuedBooks(),
                  ),
                ]),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // Takes the user to the Application screen
              Navigator.pushNamed(context, AddBooks.id);
            },
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _currentIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              _currentIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 400), curve: Curves.ease);
            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: AutoSizeText('Home'),
                activeColor: Colors.red,
              ),
              BottomNavyBarItem(
                  icon: Icon(Icons.assignment_ind_outlined),
                  title: AutoSizeText('Applications'),
                  activeColor: Colors.purpleAccent),
              BottomNavyBarItem(
                  icon: Icon(Icons.search),
                  title: AutoSizeText('Search'),
                  activeColor: Colors.pink),
              BottomNavyBarItem(
                  icon: Icon(Icons.library_books_outlined),
                  title: AutoSizeText('Issued Books'),
                  activeColor: Colors.blue),
            ],
          ));
  }
}

TextStyle _style = GoogleFonts.montserrat(
  fontSize: 34.0,
  fontWeight: FontWeight.w700,
  color: Color(0Xaa394867)
);


TextStyle _textStyle = GoogleFonts.montserrat(
  fontSize: 24.0,
  fontWeight: FontWeight.w700,
  color: Color(0Xaa14274e)
);
