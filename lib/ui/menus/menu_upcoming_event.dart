import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:techno_dawn_erp/functions/request_upcoming_event.dart';
import 'package:techno_dawn_erp/models/upcoming_event.dart';
import 'package:techno_dawn_erp/widgets/erp_app_bar.dart';

class MenuUpComingEvent extends StatefulWidget {

  static final String id = "MENU_UPCOMING_EVENT_SCREEN";


  @override
  _MenuUpComingEventState createState() => _MenuUpComingEventState();
}



class _MenuUpComingEventState extends State<MenuUpComingEvent> {
  List<UpComingEvent> UpComingEventArray = [];
  bool loading = false;

  @override
  void initState() {
    requestUpComingEvent(refresh: false);

    super.initState();
  }


  Future<void> requestUpComingEvent({bool refresh = true}) async  {

    if (refresh == false) {
      setState(() {
        loading = true;
      });
    }

    List<UpComingEvent> upcomingEventResult = await getUpComingEvent();

    setState(() {
      UpComingEventArray = upcomingEventResult;
    });

    if (refresh == false) {
      setState(() {
        loading = false;
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: TechnoDawnAppBar(
          title: 'UpComing Event',
        ),
        body: RefreshIndicator(
          onRefresh: requestUpComingEvent,
          child: ListView.builder(

            itemBuilder: (context, position) {
              return Container(

                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(20.0),


                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Text('${UpComingEventArray[position].eventName} (At: ${UpComingEventArray[position].location})'),
                    SizedBox(height: 10,),
                    Text('${UpComingEventArray[position].description}'),
                    SizedBox(height: 10,),
                    Row(children: [
                      Icon(Icons.lock_clock),
                      Text('Start Time: ${UpComingEventArray[position].startTime}')

                    ],),
                    SizedBox(height: 10,),
                    Row(children: [
                      Icon(Icons.lock_clock),
                      Text('End Time: ${UpComingEventArray[position].endTime}')

                    ],),
                    SizedBox(height: 10,),

                    //Text(noticeObjectArray[position].description),
                  ],

                ),
              );
            },
            itemCount: UpComingEventArray.length,
          ),
        ),
      ),
    );
  }
}
