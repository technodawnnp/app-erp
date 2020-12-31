import 'package:techno_dawn_erp/models/upcoming_event.dart';
import 'package:techno_dawn_erp/network/network.dart';
import 'package:intl/intl.dart';

Future<List<UpComingEvent>> getUpComingEvent() async {
  var result = await Network().getUpcomingEvents();
  List<UpComingEvent> upcomingEvents = [];
  if (result != null) {
    var res = result["data"];


    for (int i = 0; i < res.length; i++) {
      var startDAte = res[i]["start_date_time"];

      DateTime tempDate =
          new DateFormat("yyyy-MM-dd hh:mm:ss").parse(startDAte);

      int startEpoch = tempDate.millisecondsSinceEpoch;
      int currentDate = DateTime.now().millisecondsSinceEpoch;

      int diff = startEpoch - currentDate;

      if (diff >= 0 || diff == 0) {
        upcomingEvents.add(UpComingEvent(
          eventId: res[i]["id"],
          eventName: res[i]["event_name"],
          location: res[i]["where"],
          description: res[i]["description"],
          startTime: res[i]["start_date_time"],
          endTime: res[i]["end_date_time"],

        ));

      }
    }
  }

  return upcomingEvents;
}
