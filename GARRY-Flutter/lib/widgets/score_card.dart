import 'package:flutter/cupertino.dart';

///
/// The widget representing each session entry/row on the [Scoreboard]. Each contains a:
/// 1) rank, 2) date, and 3) score (number of points the participant got). Accepts animation
/// configurations as customizable aspects.
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
  final Function reportHeight; // used to report height once rendered
  final Animation<double> scaleAnimation;
  final Animation<Color> highlightAnimation;
  final Animation<Color> fadeInAnimation;
}

class _ScoreCardState extends State<ScoreCard> {
  Color defaultTextColor = CupertinoColors.black;
  double baselineFontSize = 37;

  @override
  Widget build(BuildContext context) {
    // report height for correct scroll scale/position
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.reportHeight != null) widget.reportHeight();
    });

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    EdgeInsets verticalMargin = EdgeInsets.symmetric(vertical: height / 25);

    /// The variable shouldAnimate decides whether this particular [ScoreCard] should be
    /// animated/highlighted. A [ScoreCard] is animated if it represents the session the user
    /// just finished.
    bool shouldAnimate = widget.rank == widget.newIndex + 1;

    Container container = Container(
        margin: verticalMargin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(   // rank
              flex: 2,
              child: animatedText(
                  text: widget.rank.toString() + '.', // displayed as "1.", "2.", etc.
                  fontSize: baselineFontSize + 3,
                  textColor: defaultTextColor,
                  fontWeight: FontWeight.w600,
                  shouldAnimate: shouldAnimate),
            ),
            Expanded(   // date
              flex: 5,
              child: animatedText(
                  text: widget.date,
                  fontSize: baselineFontSize,
                  textColor: defaultTextColor,
                  fontWeight: FontWeight.normal,
                  shouldAnimate: shouldAnimate),
            ),
            Expanded(   // score
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

///
/// The widget wrapper that animates a Text widget by accepting [shouldAnimate] as a boolean
/// to determine if it should be animated/highlighted.
/// 
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
