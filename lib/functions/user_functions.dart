import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/models/user_model.dart';

Future<User> getUser() async {
  User user = await SharedPrefData.getInstance().getUserProfile();
  return user;
}


void signOut() async {

  await SharedPrefData.getInstance().setUserLoginStatus(false);
  await SharedPrefData.getInstance().setTokenDate(null);
  await SharedPrefData.getInstance().setUserProfile(null);
  await SharedPrefData.getInstance().setUserToken(null);
  await SharedPrefData.getInstance().setAttendanceStatus(null);
  await SharedPrefData.getInstance().setLastPosition(null);


}