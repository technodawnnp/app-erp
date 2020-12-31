import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:techno_dawn_erp/models/location_trail_model.dart';
//import 'package:sqlpractise/model/task.dart';

class DB {


  static Database _db;

  static int get _version => 1;

  static String TABLE_NAME_LOCATION = "locationTrack";

  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'technoDawnERP';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch (ex) {
      print(ex);
    }
  }



  static void onCreate(Database db, int version) async {
    db.execute("CREATE TABLE $TABLE_NAME_LOCATION("
        "updateTime INTEGER PRIMARY KEY,"
        "batteryLvl INTEGER,"
        "latitude TEXT,"
        "longitude TEXT,"
        "altitude TEXT,"
        "accuracy TEXT,"
        "speed TEXT,"
        "speedAccuracy TEXT"
        ")");
  }




  static Future<int> insert(LocationTrail locationTrail ) async {
    print(_db.path);
    var raw = await _db.rawInsert(
        "INSERT Into $TABLE_NAME_LOCATION (updateTime,batteryLvl,latitude,longitude,altitude,accuracy,speed,speedAccuracy)"
            " VALUES (?,?,?,?,?,?,?,?)",
        [locationTrail.updateTime, locationTrail.battery, locationTrail.lat,locationTrail.lon,locationTrail.altitude,locationTrail.accuracy,locationTrail.speed,locationTrail.speedAccuracy]);
        return raw;
      
  }



  static Future<List<Map<String, dynamic>>> query() async {
    var res =  await  _db.query("$TABLE_NAME_LOCATION");

 if(res!=null){
   return res;
 }

 else{
   return null;
 }

  }



  static Future<int> update (LocationTrail locationTrail) async{
    await  _db.update("$TABLE_NAME_LOCATION", locationTrail.toMap(), where: 'updateTime = ?', whereArgs: [locationTrail.updateTime] );

  }


  static Future<int> purge() async {
    await _db.transaction((txn) async {
        var batch = txn.batch();
        batch.delete("$TABLE_NAME_LOCATION");
        await batch.commit();

    });
  }


}