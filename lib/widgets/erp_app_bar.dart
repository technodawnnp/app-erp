import 'package:flutter/material.dart';
import 'package:techno_dawn_erp/functions/user_functions.dart';
import 'package:techno_dawn_erp/functions/user_tracking.dart';
import 'package:techno_dawn_erp/models/user_model.dart';
import 'package:techno_dawn_erp/ui/login_screen.dart';

import 'bottom_modal.dart';

class TechnoDawnAppBar extends StatefulWidget implements PreferredSizeWidget {
 final String title;
  final bool showBack;

  TechnoDawnAppBar({this.title="Techno Dawn", this.showBack=true});

  @override
  _TechnoDawnAppBarState createState() => _TechnoDawnAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _TechnoDawnAppBarState extends State<TechnoDawnAppBar> {
  bool userTrackingLocation = false;
  User user = User();
  bool loading = false;


  @override
  void initState() {
    initliaze();
    // TODO: implement initState
    super.initState();
  }

  initliaze() async {
    setState(() {
      loading = true;
    });
    userTrackingLocation = await getUserTrackingStatus();
    user = await getUser();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
//      leading: widget.showBack?null:Container(
//        margin: EdgeInsets.symmetric(horizontal: 10),
//        child: userTrackingLocation
//            ? IconButton(
//          icon: Icon(Icons.gps_fixed_rounded),
//          iconSize: 35.0,
//          onPressed: () async {
//            setState(() {
//              userTrackingLocation = false;
//            });
//            await trackLocation(false);
//          },
//          color: Theme.of(context).primaryColor,
//        )
//            : IconButton(
//            icon: Icon(Icons.gps_off_rounded),
//            iconSize: 35.0,
//            onPressed: () async {
//              await trackLocation(true);
//              setState(() {
//                userTrackingLocation = true;
//              });
//              await trackLocation(true);
//            },
//            color: Theme.of(context).primaryColor),
//      ),


      title: Text(widget.title),
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
                              backgroundImage: NetworkImage(user.image
                                          .toString() !=
                                      'null'
                                  ? user.image.toString()
                                  : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqGP17oUkRs3zF2VXb4iN6qd18oA6XYxQ83w&usqp=CAU'),
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
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          LoginScreen.id, (route) => false);
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
    );
  }
}
