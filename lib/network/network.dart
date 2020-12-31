import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/functions/user_functions.dart';
import 'package:techno_dawn_erp/models/user_model.dart';
import 'package:techno_dawn_erp/network/endpoints.dart';

class Network {
  Endpoints _endpoints = Endpoints();

  Future<dynamic> loginRequest(String email, String password) async {
    http.Response response;
    Map data = {
      'email': email,
      'password': password,
    };

    var body = json.encode(data);
    response = await http.post(_endpoints.getHostUrl(_endpoints.LOGIN),
        headers: {'Content-Type': 'application/json'}, body: body);
    return (json.decode(response.body));
  }

  Future<String> refreshToken() async {
    String token = await SharedPrefData.getInstance().getUserToken();
    http.Response response;

    response = await http.get(_endpoints.getHostUrl(_endpoints.REFRESH_TOKEN),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    var res = json.decode(response.body);
    // result.containsKey('data'

    if (res.containsKey('data')) {
      return res["data"]["token"];
    } else {
      return null;
    }
  }

  Future<dynamic> getNotices() async {
    String token = await SharedPrefData.getInstance().getUserToken();
    http.Response response;

    response = await http.get(_endpoints.getHostUrl(_endpoints.NOTICE_API),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    var res = json.decode(response.body);

    return res;
  }

  Future<dynamic> getUpcomingEvents() async {
    String token = await SharedPrefData.getInstance().getUserToken();
    http.Response response;
    response = await http
        .get(_endpoints.getHostUrl(_endpoints.UPCOMING_EVENT_API), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var res = json.decode(response.body);
    return res;
  }


  Future<dynamic> getAttendanceStatus() async {

    String token = await SharedPrefData.getInstance().getUserToken();
    http.Response response;
    response = await http.get(_endpoints.getHostUrl(_endpoints.ATTENDANCE_STATUS), headers: {
      'Content-Type': 'application/json',

      'Authorization': 'Bearer $token'
    });

    return json.decode(response.body);
  }



  Future<dynamic> setAttendanceCheckIn() async{

print(_endpoints.SET_ATTENDANCE_CHECK_IN);
    String token = await SharedPrefData.getInstance().getUserToken();
    http.Response response;
    response = await http.post(_endpoints.getHostUrl(_endpoints.SET_ATTENDANCE_CHECK_IN), headers: {
      'Content-Type': 'application/json',

      'Authorization': 'Bearer $token'
    });
print(json.decode(response.body));
    return json.decode(response.body);
  }


  Future<dynamic> setAttendanceCheckOUT() async{

    String token = await SharedPrefData.getInstance().getUserToken();
    User user = await SharedPrefData.getInstance().getUserProfile();
    http.Response response;
    print(_endpoints.getHostUrl('${_endpoints.SET_ATTENDANCE_CHECK_OUT}${user.id}'));
    response = await http.post(_endpoints.getHostUrl('${_endpoints.SET_ATTENDANCE_CHECK_OUT}${user.id}'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future<dynamic> updateGps(Map userData) async{

    User user = await getUser();


    http.Response response;

    double lat = userData['latitude'];
    double lon = userData['longitude'];
    double altitude = userData['altitude'];
    double accuracy = userData['accuracy'];
    String speed = userData['speed'];
    double speedAccuracy = userData['speedAccuracy'];
    int updateTime = userData['updateTime'];
    int batteryLvl = userData['batteryLvl'];



    String sendUrl = '${_endpoints.getGPSHostUrl('email=${user.email}&lat=$lat&lon=$lon&altitude=$altitude&accuracy=$accuracy&speed=$speed&speedAccuracy=$speedAccuracy&updateTime=$updateTime&batteryLvl=$batteryLvl')}';



    response = await http.post(sendUrl, headers: {
      'Content-Type': 'application/json',

    });

    return json.decode(response.body);
  }

  Future<dynamic> getGpsUserList() async{

    http.Response response;
    response = await http.get(_endpoints.getGPSUserList(), headers: {
      'Content-Type': 'application/json',
    });

    return json.decode(response.body);

  }


  Future<dynamic> getUserTrailToday(String email) async {
    http.Response response;
    String getLocationTrailURl = "https://gps-erp.technodawn.com/public/api/auth/gps/today?email=$email";

    print(getLocationTrailURl);

    response = await http.post(getLocationTrailURl, headers: {
      'Content-Type': 'application/json',
    });
    return json.decode(response.body);
  }


  Future<dynamic> getUserTrailByTimeRange(String email, String startTime, String endTime) async {
    http.Response response;

    String getLocationTrailUrlByRange = "https://gps-erp.technodawn.com/public/api/auth/gps/between?email=$email&from=$startTime&to=$endTime";

    print(getLocationTrailUrlByRange);

    response = await http.post(getLocationTrailUrlByRange, headers: {
      'Content-Type': 'application/json',
    });

    return json.decode(response.body);

  }


  Future<dynamic> saveBulkLocationUpdate (String email,dynamic value) async {

    http.Response response;

    String updateBulkLocation = "https://gps-erp.technodawn.com/public/api/auth/gps/bulk?email=$email&gps=$value";
    print(updateBulkLocation);

    response = await http.post(updateBulkLocation, headers: {
      'Content-Type': 'application/json',
    });

    return json.decode(response.body);


  }



}
