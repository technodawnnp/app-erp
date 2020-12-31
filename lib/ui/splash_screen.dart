import 'package:flutter/material.dart';
import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/ui/employe_dashboard.dart';
import 'package:techno_dawn_erp/ui/user_dashboard.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static final String id = "SPLASH_SCREEN_ID";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    bool login = await SharedPrefData.getInstance().getUserLoginStatus();
    if (login) {
      Navigator.pushReplacementNamed(context, EmployeeDashboard.id);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png'),
        ),
      ),
    );
  }
}
