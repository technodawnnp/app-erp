import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:techno_dawn_erp/network/network.dart';
import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/ui/employe_dashboard.dart';
import 'package:techno_dawn_erp/ui/user_dashboard.dart';
import 'package:techno_dawn_erp/widgets/techno_btn.dart';
import 'package:techno_dawn_erp/widgets/techno_text.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "LOGIN_SCREEN_ID";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool isValid() {
    if (email == null || email == "") {
      showInSnackBar('email is empty or null');
      return false;
    }

    if (password == null || password == "") {
      showInSnackBar('password is empty or null');
      return false;
    }

    return true;
  }

  void login() async {
    setState(() {
      loading =true;
    });
    var result = await Network().loginRequest(email, password);
    setState(() {
      loading =false;
    });

    if(result.containsKey('data')){
      await SharedPrefData.getInstance().setUserLoginStatus(true);
      await SharedPrefData.getInstance().setUserToken(result['data']['token']);
      var date = DateTime.now();
      await SharedPrefData.getInstance().setTokenDate(date);
      await SharedPrefData.getInstance().setUserProfile(result['data']['user']);

      Navigator.pushNamedAndRemoveUntil(
          context, EmployeeDashboard.id, (route) => false);

    }

    else{
      showInSnackBar(result["error"]["message"]);

    }

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Image(
                  image: AssetImage(
                    'assets/logo.png',
                  ),
                  height: 200,
                  width: 200,
                )),
            Text(
              'Techno Dawn ERP',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            TechnoText(
              hintText: 'email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
            ),
            TechnoText(
              hintText: 'password',
              hideText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            SizedBox(
              height: 22,
            ),
            TechnoBtn(
              title: 'Login',
              onPressed: () {
                if (isValid()) {
                  login();
                }
              },
            ),
          ],
        )),
      ),
    );
  }
}
