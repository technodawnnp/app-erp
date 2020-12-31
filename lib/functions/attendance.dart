
import 'package:techno_dawn_erp/data/erp_enums.dart';
import 'package:techno_dawn_erp/data/shared_pref_data.dart';
import 'package:techno_dawn_erp/functions/user_tracking.dart';
import 'package:techno_dawn_erp/models/attendance_model.dart';

import 'package:techno_dawn_erp/network/network.dart';
import 'package:intl/intl.dart';

Future<dynamic> attendanceStatus() async {
  var result = await Network().getAttendanceStatus();

  print(result);
  ATTENDANCE_STATUS attendance_status;

  String attendanceDate;

  var  response = result["data"]["attendance"];
 try{
   if(response.containsKey("clock_in_time")){
     attendance_status = ATTENDANCE_STATUS.CHECK_IN;

     var date = result["data"]["attendance"]["clock_in_time"];
     DateTime dateTime = DateTime.parse(date);
     int timeWithMillSecond = dateTime.millisecondsSinceEpoch;

     Attendance attendance = Attendance(
       attendance_status: attendance_status,
       time: getDateAndTimeFormat(timeWithMillSecond),
     );

     SharedPrefData.getInstance().setAttendanceStatus(attendance);
   }

   else  {
     attendance_status = ATTENDANCE_STATUS.CHECK_OUT;
     var date = result["data"]["time"];
     DateTime dateTime = DateTime.parse(date);
     int timeWithMillSecond = dateTime.millisecondsSinceEpoch;

     Attendance attendance = Attendance(
       attendance_status: attendance_status,
       time: getDateAndTimeFormat(timeWithMillSecond),
     );

     SharedPrefData.getInstance().setAttendanceStatus(attendance);
   }

 }

 catch(E){
   attendance_status = ATTENDANCE_STATUS.CHECK_OUT;
   var date = result["data"]["time"];
   DateTime dateTime = DateTime.parse(date);
   int timeWithMillSecond = dateTime.millisecondsSinceEpoch;

   Attendance attendance = Attendance(
       attendance_status: attendance_status,
       time: getDateAndTimeFormat(timeWithMillSecond),);

   SharedPrefData.getInstance().setAttendanceStatus(attendance);

 }
}

Future<Attendance> getAttendaceStatus() async {
  await attendanceStatus();
  Attendance res = await SharedPrefData.getInstance().getAttendanceStatus();
  return res;
}

Future<dynamic> doAttendance(ATTENDANCE_STATUS attendance_status) async {
  Attendance attendance = await getAttendaceStatus();

  if (attendance_status == ATTENDANCE_STATUS.CHECK_IN) {
    await Network().setAttendanceCheckOUT();
    await trackLocation(false);
  } else if (attendance_status == ATTENDANCE_STATUS.CHECK_OUT) {
    await Network().setAttendanceCheckIn();

    await trackLocation(true);
  }
}

String getDateAndTimeFormat(int epochTime) {
  var date = DateTime.fromMillisecondsSinceEpoch(epochTime);
  var formattedDate = DateFormat.yMMMd().format(date);
  var timeFormat = new DateFormat('hh:mm:ss aa');

  return ('${timeFormat.format(date)} \n $formattedDate');
}
