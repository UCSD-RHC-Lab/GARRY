import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:myapp/providers/user_model.dart';

/// Text Labels:
/// The custom widget for showing the participant's ID
///
Widget participantIDLabel({String pid, double fontSize=25}) {
  return Container(
      padding: EdgeInsets.all(30),
      alignment: Alignment.centerLeft,
      child: Consumer<UserModel>(
        builder: (context, user, child) {
          return Text(
            "Participant ID: " + user.pid.toString(),
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                decoration: TextDecoration.none)
          );
        }
      )
  );
}
