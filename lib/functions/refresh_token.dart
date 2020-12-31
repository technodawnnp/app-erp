import 'package:flutter/cupertino.dart';
import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/network/network.dart';
import 'package:techno_dawn_erp/ui/login_screen.dart';

refreshToken(BuildContext context) async {

  var date = await SharedPrefData.getInstance().getTokenSaveDate();

  print(await SharedPrefData.getInstance().getUserToken());
  final date2 = DateTime.now();
  final difference = date2.difference(date).inDays;

  if (difference > 30) {
    String newToken = await Network().refreshToken();

    if (newToken != null) {
      await SharedPrefData.getInstance().setUserLoginStatus(true);
      await SharedPrefData.getInstance().setUserToken(newToken);
      var date = DateTime.now();
      await SharedPrefData.getInstance().setTokenDate(date);
    } else {
      await SharedPrefData.getInstance().setUserLoginStatus(false);

      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
  }
}