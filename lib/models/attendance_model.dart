import 'dart:convert';

import 'package:techno_dawn_erp/data/erp_enums.dart';

class Attendance {
  ATTENDANCE_STATUS attendance_status;
  String time;
  Attendance({this.attendance_status, this.time});

  String toJson() {
    String attendanceStatus;

    if(attendance_status==ATTENDANCE_STATUS.CHECK_IN){
      attendanceStatus = "CHECK_IN";
    }

    else{
      attendanceStatus = "CHECK_OUT";
    }

    Map<String, dynamic> myMap = {
      'attendance_status': attendanceStatus,
      'time': time,
    };

    return jsonEncode(myMap).toString();
  }

  Attendance getAttendanceStatus(Map<String, dynamic> map) {
    ATTENDANCE_STATUS GET_attendance_status;
    if(map['attendance_status']=="CHECK_IN"){
      GET_attendance_status = ATTENDANCE_STATUS.CHECK_IN;
    }

    else{
      GET_attendance_status = ATTENDANCE_STATUS.CHECK_OUT;
    }

    Attendance attendance = Attendance(
      attendance_status: GET_attendance_status,
      time: map['time'],
    );
    return attendance;
  }
}
