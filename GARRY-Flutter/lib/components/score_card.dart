import 'package:flutter/cupertino.dart';

///
/// Score Card Widget:
/// Contains the code that controls the scores that appear on the sides 
/// of the screen during a session.
///
class ScoreCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScoreCardState();

  ScoreCard(
      {this.key,
      this.rank,
      this.date,
      this.score,
      this.newIndex,
      this.reportHeight,
      this.scaleAnimation,
      this.highlightAnimation,
      this.fadeInAnimation})
      : super(key: key);

  final Key key;
  final int rank;
  final String date;
  final int score;
  final int newIndex;
  final Function reportHeight;
  final Animation<double> scaleAnimation;
  final Animation<Color> highlightAnimation;
  final Animation<Color> fadeInAnimation;
}

class _ScoreCardState extends State<ScoreCard> {
  /// For animation purposes
  Color defaultTextColor = CupertinoColors.black;
  double baselineFontSize = 37;

  @override
  Widget build(BuildContext context) {
    /* --- Used to report height once rendered --- */
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.reportHeight != null) widget.reportHeight();
    });

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    EdgeInsets verticalMargin = EdgeInsets.symmetric(vertical: height / 25);
    bool shouldAnimate = widget.rank == widget.newIndex + 1;

    Container container = Container(
        margin: verticalMargin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: animatedText(
                  text: widget.rank.toString() + '.',
                  fontSize: baselineFontSize + 3,
                  textColor: defaultTextColor,
                  fontWeight: FontWeight.w600,
                  shouldAnimate: shouldAnimate),
            ),
            Expanded(
              flex: 5,
              child: animatedText(
                  text: widget.date,
                  fontSize: baselineFontSize,
                  textColor: defaultTextColor,
                  fontWeight: FontWeight.normal,
                  shouldAnimate: shouldAnimate),
            ),
            Expanded(
              flex: 3,
              child: animatedText(
                  text: widget.score.toString(),
                  fontSize: baselineFontSize + 17,
                  textColor: defaultTextColor,
                  fontWeight: FontWeight.w600,
                  shouldAnimate: shouldAnimate),
            ),
          ],
        ));

    return container;
  }

// Code that animates the text
  Widget animatedText(
      {
      String text,
      double fontSize,
      Color textColor,
      FontWeight fontWeight,
      bool shouldAnimate}) {
    return Text(text,
        style: TextStyle(
            fontSize: fontSize *
                (shouldAnimate ? widget.scaleAnimation.value : 1).toDouble(),
            fontWeight: fontWeight,
            color: (shouldAnimate
                ? widget.highlightAnimation.value
                : widget.fadeInAnimation.value)),
        textAlign: TextAlign.center);
  }
}
