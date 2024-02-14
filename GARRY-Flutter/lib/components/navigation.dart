import 'package:flutter/cupertino.dart';

///
/// Navigation:
/// Contains the Next Page button widget along with the navigation bar at the top of each page.
///
CupertinoNavigationBar navBar(String text) {
  return CupertinoNavigationBar(
    middle: Text(text),
    backgroundColor: CupertinoColors.white,
  );
}

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
