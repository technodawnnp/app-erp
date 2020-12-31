

import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/models/user_model.dart';
import 'package:techno_dawn_erp/network/network.dart';

Future<bool> isAdmin() async{
  User user =  await SharedPrefData.getInstance().getUserProfile();
  if(user.role.trim().toLowerCase()=='admin'){
    return true;
  }
  else{
    return false;
  }
}



Future<List<User>> getGpsUser() async{
  List<User> gpsUser = [];
  var result = await Network().getGpsUserList();
var userList = result["users"];

    for(int i=0; i<userList.length; i++){
      String firstName = userList[i]["first_name"];
      String lastName = userList[i]["last_name"];
      String email = userList[i]["email"];
      gpsUser.add(User(name: "$firstName $lastName", email: email));
    }

    return gpsUser;
}



Future<dynamic> getUserTrailToday(String email)async {
  var res = await Network().getUserTrailToday(email);
  return res;
}





