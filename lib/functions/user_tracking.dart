import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:battery/battery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:techno_dawn_erp/data/offline_location.dart';
import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/models/location_trail_model.dart';
import 'package:techno_dawn_erp/models/user_model.dart';
import 'package:techno_dawn_erp/network/network.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io' show Platform;
import 'dart:math' show Random, asin, cos, pow, sqrt;
Timer timer;
 SendPort uiSendPort;
const String isolateName = 'isolate';
/// A port used to communicate from a background isolate to the UI isolate.
///
///
final ReceivePort port = ReceivePort();
///
///
///
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
AndroidInitializationSettings androidInitializationSettings;
IOSInitializationSettings iosInitializationSettings;
InitializationSettings initializationSettings;


Future<bool> getUserTrackingStatus() async {
  bool value = await SharedPrefData.getInstance().getUserTrackingStatus();
  return value;
}

void trackLocation(bool isTracking) async {
  if (isTracking) {

    await sendLocationData();

  } else {
    await stopUpdate();
  }
}

sendLocationData() async {

  Wakelock.enable();
  await SharedPrefData.getInstance().setUserTrackingStatus(true);
  //var res = await SharedPrefData.getInstance().getUserTrackingStatus();


  int id = Random().nextInt(pow(2, 31));

  await SharedPrefData.getInstance().setTrackingId(id);

  if (Platform.isAndroid) {
    try{

      IsolateNameServer.registerPortWithName(
        port.sendPort,
        isolateName,
      );

      await AndroidAlarmManager.initialize();

      await AndroidAlarmManager.periodic(
        const Duration(seconds: 5),
        id,
        updateLocation,
        exact: true,
        wakeup: true,

      );
    }

    catch(e){
      print(e.toString());
    }
  } else {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => updateLocation());
  }
}

updateLocation() async {
  bool isLocationUpdateOn = await getUserTrackingStatus();
  if (isLocationUpdateOn) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    int date =  DateTime.now().millisecondsSinceEpoch;

    int batteryLvl =  await getBatteryInfo();

    Map<String, dynamic> myposition = {
      "latitude": position.latitude,
      "longitude": position.longitude,
      "altitude": position.altitude,
      "accuracy": position.accuracy,
      "speed": '${position.speed} m/s',
      "speedAccuracy": position.speedAccuracy,
      "updateTime":date,
      "batteryLvl":batteryLvl,
    };

    await initializing();
    await notification();

    var getSavedLastPosition = await SharedPrefData.getInstance().getLastPosition();
    if(getSavedLastPosition!=null){
    if(onChangeDistance(getSavedLastPosition['latitude'], getSavedLastPosition['longitude'], myposition['latitude'], myposition['longitude'] )){
      await SharedPrefData.getInstance().setLastPosition(myposition);
      await saveUserLocation(myposition);
      uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
      uiSendPort?.send(null);
    }
    }
    else{
      await SharedPrefData.getInstance().setLastPosition(myposition);
      await saveUserLocation(myposition);
      uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
      uiSendPort?.send(null);

    }

  }
}

saveUserLocation(dynamic res) async {
  LocationTrail locationTrail = LocationTrail(
    lat: res["latitude"],
    lon: res["longitude"],
    altitude: res["altitude"],
    accuracy: res["accuracy"],
    speed: res["speed"],
    speedAccuracy: res["speedAccuracy"],
    updateTime: res["updateTime"],
    battery: res["batteryLvl"]
  );
 
await DB.insert(locationTrail);

}

bool onChangeDistance(double lat1, double lon1, double lat2, double lon2){

  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  double value = 12742 * asin(sqrt(a));

  if(value>0.002){
    return true;
  }


  else{
    return false;
  }

}



void initializing() async {

  androidInitializationSettings = AndroidInitializationSettings('app_icon');
  iosInitializationSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  initializationSettings = InitializationSettings(
     android: androidInitializationSettings, iOS: iosInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

}

Future onSelectNotification(String payLoad) {

  if (payLoad != null) {
    print(payLoad);
  }

  // we can set navigator to navigate another screen
}


Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  return CupertinoAlertDialog(
    title: Text(title),
    content: Text(body),
    actions: <Widget>[
      CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            print("");
          },
          child: Text("Okay")),
    ],
  );
}

Future<void> notification() async {
  AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
      'Channel ID', 'Channel title', 'channel body',
      priority: Priority.high,
      importance: Importance.max,
      ticker: 'test');

  IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

  NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      0, 'Hello there', 'please subscribe my channel', notificationDetails);
}


stopUpdate() async {

  Wakelock.disable();

  var savedLocation;

  try{
    savedLocation = await DB.query();
  }
  catch(e){
    print(e.toString());
  }


  if(savedLocation!=null){

    User user  = await SharedPrefData.getInstance().getUserProfile();
    try{
      var res = await Network().saveBulkLocationUpdate(user.email, json.encode(savedLocation));
      print(res);
    }

    catch(e){
      print(e.toString());
    }

    await DB.purge();
    await SharedPrefData.getInstance().setLastPosition(null);

  }

  await SharedPrefData.getInstance().setUserTrackingStatus(false);

  if (Platform.isAndroid) {
    try{
      int id = await SharedPrefData.getInstance().getTrackingId();
      await AndroidAlarmManager.cancel(id);
    }
    catch(e){
      print(e.toString());
    }
  } else {
    if (timer != null) {
      timer.cancel();
    }
  }



}



Future<int> getBatteryInfo() async {
  int batteryLvl = 0;
  try {
    Battery _battery = Battery();
    batteryLvl = await _battery.batteryLevel;
  } catch (e) {
    batteryLvl = 0;
  }
  return batteryLvl;
}

