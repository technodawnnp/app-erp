class  LocationTrail{
  double lat;
  double lon;
  String speed;
  double accuracy;
  double speedAccuracy;
  double altitude;
  int battery;
  int updateTime;


  LocationTrail({this.lat, this.lon, this.speed,this.accuracy,this.speedAccuracy,this.altitude, this.battery,this.updateTime});


  Map<String, dynamic> toMap() {

    Map<String,dynamic> map = {

      "latitude": (this.lat).toString(),
      "longitude": (this.lon).toString(),
      "altitude":(this.altitude).toString(),
      "updateTime":this.updateTime,
      "batteryLvl":this.battery,
      "accuracy":(this.accuracy).toString(),
      "speed":(this.speed).toString(),
      "speedAccuracy":(this.speedAccuracy).toString()
    };


    return map;
  }




}