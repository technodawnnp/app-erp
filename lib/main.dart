import 'package:flutter/material.dart';

import 'package:techno_dawn_erp/ui/login_screen.dart';
import 'package:techno_dawn_erp/ui/menus/menu_gps_tracking.dart';
import 'package:techno_dawn_erp/ui/menus/menu_notice_board.dart';
import 'package:techno_dawn_erp/ui/menus/menu_upcoming_event.dart';
import 'package:techno_dawn_erp/ui/splash_screen.dart';
import 'package:techno_dawn_erp/ui/user_dashboard.dart';
import 'data/offline_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Techno Dawn Erp',
          debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFF09333),
        scaffoldBackgroundColor: Color(0xFF153E53),
        appBarTheme: AppBarTheme(
            iconTheme:  IconThemeData(
              color: Colors.white, //change your color here
            )
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //initialRoute: SplashScreen.id,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        LoginScreen.id: (context)=>LoginScreen(),
        EmployeeDashboard.id:(context)=>EmployeeDashboard(),
        MenuNoticeBoard.id:(context)=>MenuNoticeBoard(),
        MenuUpComingEvent.id:(context)=>MenuUpComingEvent(),
        GPSTrackingScreen.id:(context)=>GPSTrackingScreen()
      },

    );
  }
}


