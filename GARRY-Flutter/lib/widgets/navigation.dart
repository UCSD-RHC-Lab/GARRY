///
/// Widgets related to navigation.
///
import 'package:flutter/cupertino.dart';

///
/// A simple wrapper for the navigation bar at the top of each page. Displays some text
/// in the middle of the nav bar.
///
CupertinoNavigationBar navBar(String text) {
  return CupertinoNavigationBar(
    middle: Text(text),
    backgroundColor: CupertinoColors.white,
  );
}

///
/// A custom button that shows a right arrow to indicate going to next page. Displays some [text]
/// of [fontSize] and [color] to the left of the arrow and accepts a function [onPressed] for
/// what to do when pressed.
///
Widget nextPageButton(
    {String text, double fontSize, Function onPressed, Color color}) {
  return Container(
      padding: EdgeInsets.all(25),
      child: CupertinoButton(
          onPressed: onPressed,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  text,
                  style: TextStyle(
                      color: color,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold),
                )),
            Icon(
              CupertinoIcons.arrow_right,
              color: color,
            ),
          ])));
}
