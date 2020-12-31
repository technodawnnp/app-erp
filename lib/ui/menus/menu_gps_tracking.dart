import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:techno_dawn_erp/functions/gps_tracking_functions.dart';
import 'package:techno_dawn_erp/models/user_model.dart';
import 'package:techno_dawn_erp/network/network.dart';
import 'package:techno_dawn_erp/widgets/erp_app_bar.dart';
import 'package:intl/intl.dart';
class GPSTrackingScreen extends StatefulWidget {

  static final String id = "GPS_TRACKING_SCREEN";

  @override
  _GPSTrackingScreenState createState() => _GPSTrackingScreenState();
}

class _GPSTrackingScreenState extends State<GPSTrackingScreen> {
List<User> gpsUsers = [];
String selectedUser;
CameraPosition _kGooglePlex;
Map<MarkerId, Marker> markers = {};
List listMarkerIds = List();
BitmapDescriptor customIcon;
List<Marker> myMarkers = [];
List<Marker> filterMarkers = [];
Completer<GoogleMapController> _controller = Completer();
GoogleMapController mapController;
List<dynamic> gpsDataFromRequest = [];
String startDate = "Select Start Date and time";
String endDate = "Select Start Date and time";
String updateOfToday = "Update Of Today";
bool loading = false;

List<LatLng> myPaths = [];

  @override
  void initState() {
    getUserList();
    super.initState();
  }


  void getUserList() async {
    setState(() {
      loading = true;
    });
    gpsUsers = await getGpsUser();

    setState(() {
      loading = false;
    });
    getIcon();
  }

Future<BitmapDescriptor> getIcon() async {
  customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/icon_map.png');
}

List<DropdownMenuItem> generateDropDownItem(){

  List<DropdownMenuItem> menuitems = [];

  gpsUsers.forEach((User user) {
    menuitems.add(DropdownMenuItem(
      child: Container(

        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          Text('${user.name} (${user.email})' , style: TextStyle(color: Colors.black), ),


        ],),
      ),
      value: user.email,
    ));


  });

  return menuitems;

}

String getDateAndTimeFormatOnlyTime(String epochTime) {
  var date = DateTime.fromMillisecondsSinceEpoch(int.parse(epochTime));
  var timeFormat = new DateFormat('hh:mm:ss aa');
  return ('${timeFormat.format(date)}');
}


onSelectedUser(String email) async {
    setState(() {
      loading = true;
       startDate = "Select Start Date and time";
       endDate = "Select Start Date and time";
       updateOfToday = "Update Of Today";
    });

    gpsDataFromRequest = [];
    _kGooglePlex = null;

    var res = await getUserTrailToday(email);

    gpsDataFromRequest = res["gps"];
    requestedResult(gpsDataFromRequest);


    setState(() {
      loading = false;
    });

}

    requestedResult(dynamic gpsDataFromRequest){
       _kGooglePlex = null;

      myMarkers = [];

      for(int i=0; i<gpsDataFromRequest.length; i++){

        myMarkers.add(Marker(
          icon:customIcon,
          infoWindow: InfoWindow(
            title: '${getDateAndTimeFormatOnlyTime(
              gpsDataFromRequest[i]["updateTime"].toString(),
            )}  Battery: ${gpsDataFromRequest[i]["batteryLvl"].toString()}% ',
          ),
          markerId: MarkerId(i.toString()),
          position: LatLng(double.parse(gpsDataFromRequest[i]["lat"].toString()),

              double.parse(gpsDataFromRequest[i]["lon"].toString())),

        ));

      }


      if(gpsDataFromRequest.length>0){
        _kGooglePlex = CameraPosition(
          target: myMarkers[myMarkers.length - 1].position,
          zoom: 16.0,
        );
      }

      getPoints();
    }



List<LatLng> getPoints() {

myPaths.clear();

if(gpsDataFromRequest.length>0){
  for (int i = 0; i < gpsDataFromRequest.length; i++) {

    myPaths.add(LatLng(double.parse(gpsDataFromRequest[i]["lat"].toString()),
        double.parse(gpsDataFromRequest[i]["lon"].toString())));

  }

}
print(gpsDataFromRequest.length);
print(myPaths.length);
setState(() {
 if(myPaths.length==0){
   myPaths.clear();
   myPaths.remove("adasd");
 }
});
}


changeCamera() async {
  if (mapController != null) {
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(_kGooglePlex));
  } else {
    // await availableCameras();
    try {
      mapController.moveCamera(
          CameraUpdate.newCameraPosition(_kGooglePlex));
    } catch (e) {
      print('something went wrong  ${e.toString()}');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).userGestureInProgress)
            return false;
          else
            return true;
        },
        child: Scaffold( appBar: TechnoDawnAppBar(
          title: 'GPS Tracking',
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [

              Container(
                margin: EdgeInsets.all(25.0),
                padding: EdgeInsets.all(2),

                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 0.8),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: DropdownButton(
                  underline: SizedBox(),
                  style: TextStyle(color: Colors.white),

                  isExpanded: true,
                  hint: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('Select Users', style: TextStyle(color: Colors.black, fontSize: 18.0),)),

                    onChanged: (value) {
                      setState(() {
                        selectedUser = value.toString();
                        onSelectedUser(selectedUser);
                      });
                    },

                  value: selectedUser,
                  items: generateDropDownItem(),
                ),
              ),

            Expanded(

  child:   Container(
    child:_kGooglePlex!=null? Stack(
      children: [
        GoogleMap(

            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,

            markers: Set.from(myMarkers),
            polylines: Set<Polyline>.of(<Polyline>[
              Polyline(
                  polylineId: PolylineId(('adasd')),


                  //  startCap: Cap.customCapFromBitmap(bitmapDescriptor),
                  // polygonId: PolygonId(selectedTime),

                  points: myPaths,
                  visible: true,
                  color: Theme.of(context).primaryColor,
                  width: 5,
                  patterns: [

                    PatternItem.dash(2),

                    PatternItem.gap(5),

                  ]
              ),
            ]),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            }
        ),
        Positioned(
          bottom: 20,
          left: 22,
          child: GestureDetector(
            onTap: (){
            showModalBottomSheet(context: context, builder: (BuildContext context){
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height/3,
                child: StatefulBuilder(
                  builder: (context,state){
                    return Column(
                      children: [
                         GestureDetector(
                        onTap: (){
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2018, 3, 5),
                          maxTime: DateTime.now(), onChanged: (date) {

                          }, onConfirm: (date) {
                            state(() {

                              startDate = (date.millisecondsSinceEpoch).toString();
                            });
                          }, currentTime: DateTime.now(), locale: LocaleType.en);


                    },
                    child: Container(color: Theme.of(context).scaffoldBackgroundColor,  width: MediaQuery.of(context).size.width,

                    child: Column(children: [

                    Container(
                    padding:EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),

                    decoration:BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(color: Theme.of(context).primaryColor),
                    ),

                    child: Text(startDate, style: TextStyle(color: Colors.white),))

                    ],),
                    ),
                    ),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime.now(), onChanged: (date) {

                                }, onConfirm: (date) {
                                  state(() {
                                    endDate = (date.millisecondsSinceEpoch).toString();
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);


                          },
                          child: Container(color: Theme.of(context).scaffoldBackgroundColor,  width: MediaQuery.of(context).size.width,

                            child: Column(children: [

                              Container(
                                  padding:EdgeInsets.all(10.0),
                                  margin: EdgeInsets.all(10.0),

                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(color: Theme.of(context).primaryColor),
                                  ),

                                  child: Text(endDate, style: TextStyle(color: Colors.white),))


                            ],),
                          ),
                        ),

                        GestureDetector(child: RaisedButton(child: Text('Confirm'), onPressed: () async {
                          setState(() {
                            loading = true;

                          });

                          Navigator.pop(context);

                          var res = await Network().getUserTrailByTimeRange(selectedUser, startDate, endDate);
                          print(res);
                          setState(() {
                            gpsDataFromRequest = res["gps"];
                          });

                          if(gpsDataFromRequest.length==0){
                            gpsDataFromRequest = [];
                          }
                          requestedResult(gpsDataFromRequest);

                          setState(() {
                            updateOfToday = '$startDate - $endDate';
                            loading = false;
                          });
                        },),)

                      ],
                    );
                  },

                ),
              );
            });


            },
            child: Card(
              elevation: 10,
              child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Row(children: [
                    SizedBox(width: 7,),
                    Icon(Icons.timer, color: Theme.of(context).primaryColor,),
                    SizedBox(width: 3,),

                    Expanded(child: Text(updateOfToday, overflow:TextOverflow.ellipsis,   style: TextStyle(color:Theme.of(context).primaryColor, ),)),
                  ],)),
            ),
          ),
        ),
      ],
    ):Stack(children: [
      SizedBox(height: 100, width:MediaQuery.of(context).size.width,
          child: Text('No Result', textAlign: TextAlign.center,)),

      Positioned(
        bottom: 20,
        left: 22,
        child: selectedUser!=null?GestureDetector(
          onTap: (){
            showModalBottomSheet(context: context, builder: (BuildContext context){
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: MediaQuery.of(context).size.height/3,
                child: StatefulBuilder(
                  builder: (context,state){
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime.now(), onChanged: (date) {

                                }, onConfirm: (date) {
                                  state(() {
                                    startDate = date.toString();
                                  });
                                },

                                currentTime: DateTime.now(), locale: LocaleType.en);

                          },
                          child: Container(color: Theme.of(context).scaffoldBackgroundColor,  width: MediaQuery.of(context).size.width,

                            child: Column(children: [

                              Container(
                                  padding:EdgeInsets.all(10.0),
                                  margin: EdgeInsets.all(10.0),

                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(color: Theme.of(context).primaryColor),
                                  ),

                                  child: Text(startDate, style: TextStyle(color: Colors.white),))


                            ],),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime.now(), onChanged: (date) {

                                }, onConfirm: (date) {
                                  state(() {
                                    endDate = date.toString();
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);


                          },
                          child: Container(color: Theme.of(context).scaffoldBackgroundColor,  width: MediaQuery.of(context).size.width,

                            child: Column(children: [

                              Container(
                                  padding:EdgeInsets.all(10.0),
                                  margin: EdgeInsets.all(10.0),

                                  decoration:BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(color: Theme.of(context).primaryColor),
                                  ),

                                  child: Text(endDate, style: TextStyle(color: Colors.white),))


                            ],),
                          ),
                        ),

                        GestureDetector(child: RaisedButton(child: Text('Confirm'), onPressed: () async {
                          setState(() {
                            loading = true;

                          });

                          Navigator.pop(context);

                          var res = await Network().getUserTrailByTimeRange(selectedUser, startDate, endDate);
                          print(res);
                          setState(() {
                            gpsDataFromRequest = res["gps"];
                          });

                          if(gpsDataFromRequest.length==0){
                            gpsDataFromRequest = [];
                          }
                          requestedResult(gpsDataFromRequest);

                          setState(() {

                            updateOfToday = '$startDate - $endDate';
                            loading = false;
                          });
                        },),)

                      ],
                    );
                  },

                ),
              );
            });


          },
          child: Card(
            elevation: 10,
            child: Container(

                height: 55,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,

                child: Row(children: [
                  SizedBox(width: 7,),
                  Icon(Icons.timer, color: Theme.of(context).primaryColor,),
                  SizedBox(width: 3,),

                  Expanded(child: Text(updateOfToday, overflow:TextOverflow.ellipsis,   style: TextStyle(color:Theme.of(context).primaryColor, ),)),
                ],)),
          ),
        ): SizedBox(height: 0,),
      ),

    ],),


  ),
),


            ],
          ),
        ),

        ),
      ),
    );

  }
}
