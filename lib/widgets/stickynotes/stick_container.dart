
import 'package:flutter/material.dart';
import 'package:techno_dawn_erp/widgets/stickynotes/sticky_notes.dart';

class StickyNoteContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  StickyNoteContainer({this.child, this.height=200, this.width=200});

  @override
  Widget build(BuildContext context) {
    return Container(

        child: Center(
            child: SizedBox(
                width: width,
                height: height,

                child: Container(
                    child: StickyNote(

                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: child),)
                )
            )
        )
    );
  }
}

