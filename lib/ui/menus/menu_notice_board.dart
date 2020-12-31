import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:techno_dawn_erp/functions/request_notices.dart';
import 'package:techno_dawn_erp/models/notice_object.dart';
import 'package:techno_dawn_erp/widgets/erp_app_bar.dart';

class MenuNoticeBoard extends StatefulWidget {
  static final String id = "MENU_NOTICE_BOARD_SCREEN";
  @override
  _MenuNoticeBoardState createState() => _MenuNoticeBoardState();
}

class _MenuNoticeBoardState extends State<MenuNoticeBoard> {
  List<NoticeObject> noticeObjectArray = [];
  bool loading = false;
  @override
  void initState() {
    requestNotice(refresh: false);
    super.initState();
  }

  Future<void> requestNotice({bool refresh = true}) async {
    if (refresh == false) {
      setState(() {
        loading = true;
      });
    }

    List<NoticeObject> noticeResult = await requestNotices();

    if (refresh == false) {
      setState(() {
        loading = false;
      });
    }
    setState(() {
      noticeObjectArray = noticeResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: TechnoDawnAppBar(
          title: 'Notice Board',
        ),
        body: RefreshIndicator(
          onRefresh: requestNotice,
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
                  Text('${noticeObjectArray[position].title} (To: ${noticeObjectArray[position].to})'),
                  SizedBox(height: 10,),

                  Text(noticeObjectArray[position].description),
                ],

                ),
              );
            },
            itemCount: noticeObjectArray.length,
          ),
        ),
      ),
    );
  }
}
