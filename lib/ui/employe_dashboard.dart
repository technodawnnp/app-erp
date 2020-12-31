import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:techno_dawn_erp/data/erp_enums.dart';
import 'package:techno_dawn_erp/functions/attendance.dart';
import 'package:techno_dawn_erp/functions/refresh_token.dart';
import 'package:techno_dawn_erp/functions/request_notices.dart';
import 'package:techno_dawn_erp/functions/request_upcoming_event.dart';
import 'package:techno_dawn_erp/functions/user_functions.dart';
import 'package:techno_dawn_erp/functions/user_tracking.dart';
import 'package:techno_dawn_erp/models/attendance_model.dart';
import 'package:techno_dawn_erp/models/notice_object.dart';
import 'package:techno_dawn_erp/models/upcoming_event.dart';
import 'package:techno_dawn_erp/models/user_model.dart';
import 'package:techno_dawn_erp/ui/login_screen.dart';
import 'package:techno_dawn_erp/widgets/bottom_modal.dart';
import 'package:techno_dawn_erp/widgets/notice_widget.dart';
import 'package:techno_dawn_erp/widgets/techno_btn.dart';
import 'package:techno_dawn_erp/widgets/upcoming_event_widget.dart';

class TestEmployeeDashboard extends StatefulWidget {
  static final String id = "EMPLOYEE_DASHBOARD";
  @override
  _TestEmployeeDashboardState createState() => _TestEmployeeDashboardState();
}

class _TestEmployeeDashboardState extends State<TestEmployeeDashboard> {
  List<NoticeObject> noticeObjectArray = [];
  List<UpComingEvent> upComingEventArray = [];
  User user = User();
  bool loading = false;
  bool userTrackingLocation = false;

  Attendance attendance = Attendance();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    setState(() {
      loading = true;
    });


    userTrackingLocation =  await getUserTrackingStatus();
    await trackLocation(userTrackingLocation);
    await refreshToken(context);
    List<NoticeObject> noticeResult = await requestNotices();
    List<UpComingEvent> upcomingEventResult = await getUpComingEvent();
    user = await getUser();
    //await attendanceStatus();
    Attendance getAttendance = await getAttendaceStatus();
    attendance.attendance_status = getAttendance.attendance_status;
    attendance.time = getAttendance.time;

    setState(() {
      noticeObjectArray = noticeResult;
      upComingEventArray = upcomingEventResult;
    });

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: userTrackingLocation? IconButton(icon: Icon(Icons.gps_fixed_rounded),
                  iconSize: 35.0,
                  onPressed: () async {
                    setState(() {
                      userTrackingLocation = false;
                    });
                    await trackLocation(false);
                  },color: Theme.of(context).primaryColor,):IconButton(icon: Icon(Icons.gps_off_rounded),
                  iconSize: 35.0,
                  onPressed: () async{
                await trackLocation(true);
                setState(() {
                  userTrackingLocation = true;
                });
                await trackLocation(true);
              },color: Theme.of(context).primaryColor),

          ),
          title: Text('Techno Dawn'),
          actions: [
            user.image.toString() != 'null'
                ? GestureDetector(
                    onTap: () {
                      bottomModal(
                          context: context,
                          height: MediaQuery.of(context).size.height - 100,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                CircleAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      NetworkImage(user.image.toString()!='null'?user.image.toString(): 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqGP17oUkRs3zF2VXb4iN6qd18oA6XYxQ83w&usqp=CAU' ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  user.name.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  user.email.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  user.phoneNumber.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Log Out',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          signOut();
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              LoginScreen.id,
                                              (route) => false);
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 25,
                        backgroundImage: NetworkImage(user.image.toString()),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
          ],
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NoticeBoardWidget(
              noticeObjects: noticeObjectArray,
            ),
            SizedBox(
              height: 50,
            ),
            UpComingEventWidget(upcomingEvents: upComingEventArray),
          ],
        ),
        bottomSheet: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  attendance.attendance_status == ATTENDANCE_STATUS.CHECK_IN
                      ? "CLOCK IN AT"
                      : "CLOCK OUT AT",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  attendance.time.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      margin: EdgeInsets.only(
                          bottom: 25.0, left: 25.0, right: 25.0),
                      child: TechnoBtn(
                        title: attendance.attendance_status ==
                                ATTENDANCE_STATUS.CHECK_IN
                            ? "CLOCK OUT"
                            : "CLOCK IN",
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });

                          print(attendance.attendance_status);
                          await doAttendance(attendance.attendance_status);

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
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
