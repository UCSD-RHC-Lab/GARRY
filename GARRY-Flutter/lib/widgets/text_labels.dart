///
/// Contains any custom text labels.
///

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:garryapp/providers/user_model.dart';

/// 
/// Custom widget for showing the participant's ID ([pid]), typically at the top of the
/// screen, left aligned on the navigation bar.
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
