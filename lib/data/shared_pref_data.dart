import 'dart:convert';


import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techno_dawn_erp/models/attendance_model.dart';
import 'package:techno_dawn_erp/models/user_model.dart';

class SharedPrefData {
  static final String USER_TOKEN_KEY = "TOKEN";
  static final String USER_TOKEN_SAVE_DATE = "USER_TOKEN_SAVE_DATE";
  static final String USER_LOGIN_STATUS = "USER_LOGIN_STATUS";
  static final String USER_PROFILE = "USER_PROFILE";
  static final String USER_ATTENDANCE_STATUS = "USER_ATTENDANCE_STATUS";



  static final String USER_TRACKING_STATUS = "IS_TRACKING_USER";
  static final String USER_LAST_POSITION = "USER_LAST_POSITION";
  static final String USER_TRACKING_ID = "USER_TRACKING_BACKGROUND_ALARM_ID";

//static final String USER_ROLE = "USER_ROLE";



  SharedPreferences prefs;

  static SharedPrefData _instance;

  SharedPrefData._internal() {
    getPref();
  }

  Future<SharedPreferences> getPref() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  static SharedPrefData getInstance() {
    if (_instance == null) {
      _instance = SharedPrefData._internal();
    }
    return _instance;
  }

  Future<bool> getUserLoginStatus() async {
    if (prefs == null) {
      await getPref();
    }
    bool loginValue = await prefs.getBool(USER_LOGIN_STATUS) ?? false;
    return loginValue;
  }

  void setUserLoginStatus(bool loginStatus) async {
    if (prefs == null) {
      await getPref();
    }

    await prefs.setBool(USER_LOGIN_STATUS, loginStatus);
  }

  Future<String> getUserToken() async {
    if (prefs == null) {
      await getPref();
    }
    String userToken = await prefs.getString(USER_TOKEN_KEY);
    return userToken;
  }

  void setUserToken(String token) async {
    if (prefs == null) {
      await getPref();
    }
    await prefs.setString(USER_TOKEN_KEY, token);
  }

  Future<DateTime> getTokenSaveDate() async {
    if (prefs == null) {
      await getPref();
    }

    var date = await prefs.getString(USER_TOKEN_SAVE_DATE);

    DateTime dateTime;
    if (date != null) {
      dateTime = DateTime.parse(date);
    }

    return dateTime;
  }

  void setTokenDate(DateTime date) async {
    if (prefs == null) {
      await getPref();
    }

    await prefs.setString(USER_TOKEN_SAVE_DATE, date.toString());
  }

  void setUserProfile(dynamic user) async {
    if (prefs == null) {
      await getPref();
    }
    User saveUser = User();
    if(user!=null){
       saveUser = User(
        name: user['name'].toString(),
        email: user['email'].toString(),
        image: user["image_url"].toString(),
        id: int.parse(user["id"].toString()),
        phoneNumber: user['mobile'].toString(),
         role: user["user_other_role"].toString(),
      );
    }

    await prefs.setString(USER_PROFILE, saveUser.toJson());
  }

  Future<User> getUserProfile() async {
    if (prefs == null) {
      await getPref();
    }
    var result = await prefs.getString(USER_PROFILE);
    return User().getUser(jsonDecode(result));
  }

  void setAttendanceStatus(Attendance attendance) async {
    if (prefs == null) {
      await getPref();
    }

    try{await prefs.setString(USER_ATTENDANCE_STATUS, attendance.toJson());}

    catch(e){
      print(e.toString());
    }
  }

  Future<Attendance> getAttendanceStatus() async {
    if (prefs == null) {
      await getPref();
    }
    var result = await prefs.getString(USER_ATTENDANCE_STATUS);
    return Attendance().getAttendanceStatus(jsonDecode(result));
  }



  Future<bool> getUserTrackingStatus() async {
    if (prefs == null) {
      await getPref();
    }
    bool userTracking = await prefs.getBool(USER_TRACKING_STATUS)??false;

    return userTracking;

  }


  Future<bool> setUserTrackingStatus(bool trackingStatus) async {


    if (prefs == null) {
      await getPref();
    }

    //print(trackingStatus);

    await prefs.setBool(USER_TRACKING_STATUS, trackingStatus);
  }


  Future<int> getTrackingId() async {
    if (prefs == null) {
      await getPref();
    }
    int trackingId = await prefs.getInt(USER_TRACKING_ID);
    return trackingId;
  }


  void setTrackingId(int id) async {
    if (prefs == null) {
      await getPref();
    }
     await prefs.setInt(USER_TRACKING_ID, id);
  }


  Future<dynamic> getLastPosition()async{
    if (prefs == null) {
      await getPref();
    }
   var position =  await prefs.getString(USER_LAST_POSITION)??'null';
    return json.decode(position);

  }


  void setLastPosition(dynamic position) async {
    if(prefs==null){
      await getPref();
    }

    await prefs.setString(USER_LAST_POSITION, json.encode(position).toString());

  }


//  Future<String> getUserRole() async {
//      if(prefs==null){
//        await getPref();
//      }
//
//      var res = await prefs.getString(USER_ROLE)??'null';
//
//      return res;
//
//  }
//
//
//
//  void setUserRole(String userRole) async{
//    if(prefs==null){
//      await getPref();
//    }
//    await prefs.setString(USER_ROLE, userRole);
//}




}
