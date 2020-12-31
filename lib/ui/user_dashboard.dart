import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:techno_dawn_erp/data/erp_enums.dart';
import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/functions/attendance.dart';
import 'package:techno_dawn_erp/functions/gps_tracking_functions.dart';
import 'package:techno_dawn_erp/functions/refresh_token.dart';

import 'package:techno_dawn_erp/models/attendance_model.dart';
import 'package:techno_dawn_erp/models/user_model.dart';

import 'package:techno_dawn_erp/ui/menus/menu_notice_board.dart';

import 'package:techno_dawn_erp/widgets/erp_app_bar.dart';


import 'login_screen.dart';
import 'menus/menu_gps_tracking.dart';
import 'menus/menu_upcoming_event.dart';

class EmployeeDashboard extends StatefulWidget {
  static String id = "USER_DASHBOARD_SCREEN";

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {

  bool loading = false;
  Attendance attendance = Attendance();
  bool isAdminOn = false;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    setState(() {
      loading = true;
    });
    await refreshToken(context);
    Attendance getAttendance = await getAttendaceStatus();
    attendance.attendance_status = getAttendance.attendance_status;
    attendance.time = getAttendance.time;

    setState(() {
      loading = false;
    });

    isAdminOn =  await isAdmin();

  }


  /*
  * user_other_role:
  * */

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: TechnoDawnAppBar(showBack: false,),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0)),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(left: 35, top: 25),
                        height: 150,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Attendance',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_present,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                Text(
                                  attendance.attendance_status ==
                                          ATTENDANCE_STATUS.CHECK_IN
                                      ? "CLOCK IN AT"
                                      : "CLOCK OUT AT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_sharp,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                Text(
                                  attendance.time.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            RaisedButton(
                              elevation: 10.0,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });

                                print(attendance.attendance_status);
                                await doAttendance(
                                    attendance.attendance_status);

                                if (attendance.attendance_status ==
                                    ATTENDANCE_STATUS.CHECK_IN) {
                                  attendance.attendance_status =
                                      ATTENDANCE_STATUS.CHECK_OUT;
                                } else if (attendance.attendance_status ==
                                    ATTENDANCE_STATUS.CHECK_OUT) {
                                  attendance.attendance_status =
                                      ATTENDANCE_STATUS.CHECK_IN;
                                }
                                initialize();
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  attendance.attendance_status ==
                                          ATTENDANCE_STATUS.CHECK_IN
                                      ? "CLOCK OUT"
                                      : "CLOCK IN",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),





                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),

                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GridView.count(
                      physics: ScrollPhysics(),
                      crossAxisCount: 2,  children: <Widget>[

                      MenuTile(
                        onPress: (){

                        Navigator.pushNamed(context, MenuNoticeBoard.id);


                        },
                        title: 'Notice', icon: Icons.notifications_on, ),
                      MenuTile(title: 'UPComing Event', icon: Icons.event,
                      onPress: (){
                        Navigator.pushNamed(context, MenuUpComingEvent.id);
                      },
                      ),
                      MenuTile(title: 'Projects', icon: Icons.group_work,),
                      MenuTile(title: 'Tasks', icon: Icons.work,),
                      MenuTile(title: 'Holiday', icon: Icons.calendar_today,),
                      MenuTile(title: 'Leaves', icon: Icons.exit_to_app,),

                      isAdminOn? MenuTile(
                        onPress: (){
                            Navigator.pushNamed(context, GPSTrackingScreen.id);
                        },
                        title: 'Employee Tracking', icon: Icons.gps_fixed,):SizedBox(height:0),


                    ],),
                  ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPress;
  MenuTile({this.title="", this.icon = Icons.title,this.onPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(title, style: TextStyle(color: Colors.white),),
              SizedBox(height: 20,),

              Icon(icon, color: Colors.white,  size: 30.0, )

          ],),

        ),

      ),
    );
  }
}

