import 'package:flutter/material.dart';

bottomModal({double height, BuildContext context, Widget child}) {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: height,
          child: SingleChildScrollView(child: child),
        );
      });
}
