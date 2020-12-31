import 'package:flutter/material.dart';
import 'package:techno_dawn_erp/models/upcoming_event.dart';
import 'package:techno_dawn_erp/widgets/stickynotes/stick_container.dart';
import 'bottom_modal.dart';

class UpComingEventWidget extends StatelessWidget {
  final List<UpComingEvent> upcomingEvents;
  UpComingEventWidget({this.upcomingEvents});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          margin: EdgeInsets.only(left:20.0, bottom: 5),
          child:
          Text('Up Coming Events',style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),),
        ),

        upcomingEvents.length>0?Container(

          width: MediaQuery.of(context).size.width,
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            itemBuilder: (context,position){

              return GestureDetector(
                onTap: (){
                  bottomModal(child: SingleChildScrollView(child: Column(children: [
                    SizedBox(height: 5,),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(icon: Icon(Icons.close,color: Colors.white,), onPressed: (){
                        Navigator.pop(context);
                      }),
                    ),

                    Text(upcomingEvents[position].eventName,style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold)),



                    SizedBox(height: 30,),

                    Container(

                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                      child: Column(children: [
                        Text(upcomingEvents[position].description,style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10,),
                        Text('start time: '+upcomingEvents[position].startTime,style: TextStyle(color: Colors.white, ),),
                        SizedBox(height: 10,),
                        Text('end time: '+upcomingEvents[position].endTime,style: TextStyle(color: Colors.white, ),),

                      ],),)


                  ],),), context: context,height: MediaQuery.of(context).size.height-100,);
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  padding: EdgeInsets.all(10.0),

                  child: Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 10,

                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0))),


                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(upcomingEvents[position].eventName,style: TextStyle(color: Colors.white, ),),
                            SizedBox(height: 15,),
                            Text('start time: '+upcomingEvents[position].startTime,style: TextStyle(color: Colors.white, ),),
                            Text('end time: '+upcomingEvents[position].endTime,style: TextStyle(color: Colors.white, ),),

                          ],)),
                  ),
                ),
              );
            }, itemCount: upcomingEvents.length,),
        ): Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text('No Upcoming Event',style: TextStyle(color: Colors.white),)),
      ],);
  }
}
