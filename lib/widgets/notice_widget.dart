import 'package:flutter/material.dart';
import 'package:techno_dawn_erp/models/notice_object.dart';
import 'package:techno_dawn_erp/network/network.dart';
import 'package:techno_dawn_erp/widgets/stickynotes/stick_container.dart';

import 'bottom_modal.dart';

class NoticeBoardWidget extends StatelessWidget {
  final List<NoticeObject> noticeObjects;
  NoticeBoardWidget({this.noticeObjects});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

     Container(
       margin: EdgeInsets.only(left:20.0, bottom: 5),
       child:
     Text('Notices',style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),),
       ),

      Container(

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

                Text(noticeObjects[position].title,style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold)),

                SizedBox(height: 30,),

                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(noticeObjects[position].description,style: TextStyle(color: Colors.white))),

              ],),), context: context,height: MediaQuery.of(context).size.height-100,);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: StickyNoteContainer(child: Text(noticeObjects[position].title),)),
          );
        }, itemCount: noticeObjects.length,),
    ),
    ],);
  }
}


