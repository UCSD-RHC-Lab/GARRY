import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garryapp/globals/global_states.dart';
import 'package:garryapp/anim/ease_out_back_scaled.dart';
import 'package:intl/intl.dart';

import 'package:garryapp/backend/score_entry.dart';
import 'package:sorted_list/sorted_list.dart';

import 'package:garryapp/widgets/score_card.dart';
import 'package:garryapp/api/api.dart' as api;


/// Scoreboard Widget:
/// Implements a self-contained, standalone scoreboard widget that could be
/// initialized without any parameters.The reason for this is because there are
/// multiple animations in this widget, and cascading them up and down makes
/// the code too complex. It's easier to manage them in one file.
///
/// It also implements CRUD operations like [load] (from file), [save] (to file),
/// and [add] (to internal sorted list).
class Scoreboard extends StatefulWidget {
  final int sessionId;
  final String feedbackType;
  final int participantId;
  const Scoreboard({this.sessionId, this.feedbackType, this.participantId});

  @override
  State<StatefulWidget> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> with TickerProviderStateMixin {
  SortedList<ScoreEntry> scores =
      SortedList((a, b) => -a.score.compareTo(b.score));

  AnimationController _preScrollController;
  AnimationController _coinsAnimationController1;
  AnimationController _coinsAnimationController2;
  AnimationController _postScrollController;

  Animation<double> _scaleTextAnimation;
  Animation<Color> _highlightTextAnimation;
  Animation<double> _flyInScoreboardAnimation;
  Animation<Color> _fadeInScoreboardAnimation;
  Animation<double> _flyInThermAnimation;
  Animation<double> _fadeInThermOpacityAnimation;
  Animation<double> _fadeInCoinsOpacityAnimation;
  Animation<double> _floatingCoinsAnimation1;
  Animation<double> _floatingCoinsAnimation2;
  ScrollController scrollController = ScrollController(keepScrollOffset: false);

  int scrollIndex = -1;
  int newScoreIndex = -1;
  bool scrollAnimated = false;
  int idx = -1;
  double scoreboardHeight = 0;
  final String assetPath = 'assets/images/';
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Animation controller inits
    _preScrollController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            setState(() {});
          });
    _coinsAnimationController1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900))
          ..addListener(() {
            setState(() {});
          });
    _coinsAnimationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            setState(() {});
          });
    _postScrollController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700))
          ..addListener(() {
            setState(() {});
          });

    // Highlighting score card animation
    _scaleTextAnimation = Tween<double>(begin: 1, end: 1.2).animate(
        CurvedAnimation(
            parent: _postScrollController,
            curve: Interval(0.2, 1.0, curve: EaseOutBackScaled(scale: 4.5))));

    _highlightTextAnimation = ColorTween(
            begin: CupertinoColors.black, // Color starts as black
            end: Color.fromARGB(0xFF, 0x00, 0x19, 0xFF)) // Changes the color of the most recent score to blue
        .animate(CurvedAnimation(
            parent: _postScrollController,
            curve: Interval(0.2, 1.0, curve: Curves.easeOutCirc)));

    // Scoreboard animations
    _flyInScoreboardAnimation = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(
            parent: _preScrollController,
            curve: Interval(0.2, 0.6, curve: EaseOutBackScaled(scale: 4))));

    _fadeInScoreboardAnimation =
        ColorTween(begin: Colors.transparent, end: Colors.black).animate(
            CurvedAnimation(
                parent: _preScrollController,
                curve: Interval(0.2, 0.8, curve: Curves.easeOutExpo))
              ..addStatusListener(_startScrollingAnimation));

    // Thermometer animations
    _flyInThermAnimation = Tween<double>(begin: 0.85, end: 1).animate(
        CurvedAnimation(
            parent: _preScrollController,
            curve: Interval(0.4, 0.8, curve: EaseOutBackScaled(scale: 3))));

    _fadeInThermOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _preScrollController,
            curve: Interval(0.4, 0.8, curve: Curves.easeOutExpo)));

    //Coin animations
    _fadeInCoinsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _preScrollController,
            curve: Interval(0.6, 1.0, curve: Curves.easeOut)));

    _floatingCoinsAnimation1 = Tween<double>(begin: -0.5, end: 0.5).animate(
        CurvedAnimation(
            parent: _coinsAnimationController1,
            curve: Interval(0.0, 1.0, curve: Curves.easeInOutSine)));

    _floatingCoinsAnimation2 = Tween<double>(begin: -0.5, end: 0.5).animate(
        CurvedAnimation(
            parent: _coinsAnimationController2,
            curve: Interval(0.0, 1.0, curve: Curves.easeInOutSine)));

    // Start pre-scroll and coin animations
    _preScrollController.forward();
    _coinsAnimationController1.repeat(reverse: true);
    _coinsAnimationController2.repeat(reverse: true);

    load().then((scores) => {setState(() => {})});
  }

  void dispose() {
    _preScrollController.dispose();
    _coinsAnimationController1.dispose();
    _coinsAnimationController2.dispose();
    _postScrollController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _startScrollingAnimation(status) {
    if (status == AnimationStatus.completed) {
      scrollController
          .animateTo((scrollIndex + 1) * scoreboardHeight,
              duration: Duration(seconds: 2), curve: Curves.decelerate)
          .then((_) => {
                setState(() => {
                      newScoreIndex = idx,
                      scrollAnimated = true,
                      _postScrollController.forward()
                    }),
              });
    }
  }

  // load into sortedlist and insert
  Future<void> load() async {
    // if scores already loaded, don't load again
    if (scores != null && scores.length != 0) {
      return;
    }

    // API call
    final res = await api.getSessions(
      int.parse(globalData['participant_id']),
      globalData['feedback_type'] // TODO: why is this here?
    );

    var newScoreEntry;
    for (final data in res) {
      if (data[8].toString() == widget.feedbackType) {
        int year = data[2], month = data[3], day = data[4];
        DateTime date = DateTime(year, month, day);
        int score = data[7];
        ScoreEntry newScore = ScoreEntry(date.toString(), score);

        // check for session id
        if (data[0] == widget.sessionId) {
          newScoreEntry = newScore;
        }
        scores.add(newScore);
      
        idx = scores.indexOf(newScoreEntry);
      }
    }
  }

  // save
  void save({SortedList<ScoreEntry> scores}) async {
    
  }

  void add(ScoreEntry score, {SortedList<ScoreEntry> scores}) {
    this.scores.add(score);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
        alignment: Alignment.center,
        child: Stack(children: [
          // a placeholder ScoreCard used just to measure its height
          //
          // needs fade in score board animation because all score cards play
          // the animation at the beginning
          Visibility(
            child: ScoreCard(
              key: key,
              rank: -1,
              date: DateFormat('MMMM d,\nyyyy').format(DateTime.now()),
              score: 777,
              newIndex: -1,
              reportHeight: _reportHeight,
              fadeInAnimation: _fadeInScoreboardAnimation,
            ),
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
          ),
          // allow overflowing to compensate for animations where the children
          // might be out of screen
          OverflowBox(
              maxHeight: height * 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(height: height * _flyInAnimation.value),
                    Text(
                      "Score Board",
                      style: TextStyle(
                          fontSize: 75,
                          fontWeight: FontWeight.w700,
                          color: _fadeInScoreboardAnimation.value),
                    ),
                    Container(
                        height: height / 2,
                        width: (width - (2 * width / 7)),
                        margin: EdgeInsets.only(
                            bottom: (height / 20) *
                                _flyInScoreboardAnimation.value),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _fadeInScoreboardAnimation.value,
                                width: 7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: listView(scoreboardHeight))
                  ])),
          Positioned(
              left: width - (width / 4.25),
              top: height - (height / 1.9) * _flyInThermAnimation.value,
              child: Opacity(
                  opacity: _fadeInThermOpacityAnimation.value,
                  child: SvgPicture.asset(
                    assetPath + 'side-therm.svg',
                  ))),
          Positioned(
              left: width - (width / 1.05),
              top: height -
                  (height / 4.7) +
                  (_floatingCoinsAnimation1.value * 25),
              child: Opacity(
                  opacity: _fadeInCoinsOpacityAnimation.value,
                  child: SvgPicture.asset(assetPath + 'lower-left-coins.svg',
                      height: height / 10))),
          Positioned(
              left: width - (width / 4.2),
              top: height -
                  (height / 1.02) +
                  (_floatingCoinsAnimation2.value * 25),
              child: Opacity(
                  opacity: _fadeInCoinsOpacityAnimation.value,
                  child: SvgPicture.asset(assetPath + 'top-right-coins.svg',
                      height: height / 6))),
        ]));
  }

  Widget listView(double boxHeight) {
    ListView listview = ListView.builder(
      shrinkWrap: true,
      controller: scrollController,
      itemCount: scores.length,
      itemBuilder: (context, index) {
        DateTime date = DateTime.parse(scores[index].date);

        return ScoreCard(
          rank: index + 1,
          date: DateFormat('MMMM d,\nyyyy').format(date),
          score: scores[index].score,
          newIndex: newScoreIndex,
          scaleAnimation: _scaleTextAnimation,
          highlightAnimation: _highlightTextAnimation,
          fadeInAnimation: _fadeInScoreboardAnimation,
        );
      },
    );

    scrollIndex = idx - 1;

    return listview;
  }

  void _reportHeight() {
    if (key.currentContext != null) {
      scoreboardHeight =
          (key.currentContext.findRenderObject() as RenderBox).size.height;
    }
  }
}
