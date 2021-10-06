import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:library_management_system/Screens/gender_screen.dart';
import 'package:library_management_system/Screens/admin_search_screen.dart';
import 'package:library_management_system/Screens/application_screen.dart';
import 'package:library_management_system/authorization/login.dart';
import 'package:library_management_system/Screens/welcome_screen.dart';
import 'package:library_management_system/Screens/search_screen.dart';
import 'package:library_management_system/Screens/home_screen.dart';
import 'package:library_management_system/Screens/admin_screen.dart';
import 'package:library_management_system/Screens/issued_books_screen.dart';
import 'package:library_management_system/Screens/add_books_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_framework.dart';

// This is the Main Dart File which contains the Route to all the screens except the book screen since it requires arguments to passed to it.
// This also contains the Firebase Core which is required to use the Firebase Authenticator and FireStore.
// The initial route is set to welcome screen which is the first screen to be build.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Permission.camera.request();
  if(await Permission.camera.isGranted == true){
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, widget) => ResponsiveWrapper.builder(
            ClampingScrollWrapper.builder(context, widget),
            maxWidth: 1280,
            minWidth: 480,
            defaultScale: false,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        GenderScreen.id: (context) => GenderScreen(),
        Login.id: (context) => Login(),
        SearchScreen.id: (context) => SearchScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        AdminScreen.id: (context) => AdminScreen(),
        ApplicationScreen.id: (context) => ApplicationScreen(),
        IssuedBooks.id: (context) => IssuedBooks(),
        AddBooks.id:(context) => AddBooks(),
        AdminSearchScreen.id:(context) => AdminSearchScreen(),
      }
    ),
  );}
}

