import 'package:techno_dawn_erp/models/notice_object.dart';
import 'package:techno_dawn_erp/network/network.dart';

Future<List<NoticeObject>>requestNotices() async {
  List<NoticeObject> noticeObjectArray = [];
  var result =  await Network().getNotices();

  if(result!=null){
    var res = result["data"];

    res = res.reversed.toList();

    for(int i=0; i<res.length;i++){


      NoticeObject getNotice = NoticeObject(
          title: res[i]["heading"],
          description: res[i]["description"],
          to: res[i]["to"],
          noticeId:res[i]["id"]

      );
      noticeObjectArray.add(getNotice);
    }

  }

  return noticeObjectArray;

}
