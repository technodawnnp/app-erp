class Endpoints {
  String ERP_VERSION = "v1";


  String LOGIN = "auth/login";
  String REFRESH_TOKEN = "auth/refresh";
  String NOTICE_API = "notice?fields=id,heading,description,to";
  String UPCOMING_EVENT_API = "event?fields=id,event_name,where,description,start_date_time,end_date_time";

  String ATTENDANCE_STATUS = "attendance/today";

  String SET_ATTENDANCE_CHECK_IN = "attendance/clock-in";

  String SET_ATTENDANCE_CHECK_OUT = "attendance/clock-out/";

  String getHostUrl(String endpoints){
    return 'https://www.erp.technodawn.com/api/$ERP_VERSION/$endpoints';
  }

  String getGPSHostUrl(String endpoints){
    return 'https://gps-erp.technodawn.com/public/api/auth/gps?$endpoints';
  }

  String getGPSUserList(){
    return "https://gps-erp.technodawn.com/public/api/auth/gps/users";
  }



}