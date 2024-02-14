import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_svg/svg.dart';

///
/// Feedback Page Components Page:
/// Contains the methods that control the animation/logic behind the widgets on the feedback page.


///
/// Defines the method for rendering the progress bar/silver on the thermometer
///
Widget progressBar({double thermSize = 60, double percent = 0.0, Color color}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsetsDirectional.only(bottom: 50, top: 15),
    child: Column(children: [
      Expanded(
        child: FAProgressBar(
          size: thermSize,
          currentValue: (percent * 100 + 40), // +40 for graphic offset
          direction: Axis.vertical,
          verticalDirection: VerticalDirection.up,
          progressColor: color,
          borderRadius: BorderRadius.circular(35), // rounds edge
        ),
      ),
    ]),
  );
}

///
/// The method for rendering the actual coin score design (where the points
/// go).
///
Widget coinUIWidget({@required Widget coinUI, width = 250}) {
  return Container(
      padding: EdgeInsets.only(right: 20, top: width / 25),
      height: width / 3,
      child: coinUI);
}

///
/// The method for rendering the points on the coin UI.
///
Widget pointDisplay({double fontSize = 40, int points = 0}) {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: fontSize * 1.125, top: fontSize / 8),
      child: Text(
        points.toString(), // The message that displays point value
        style: TextStyle(
          fontFamily: 'ReemKufi',
          color: Colors.black,
          fontSize: fontSize,
          decoration: TextDecoration.none,
        ),
      ));
}

///
/// The method for rendering the percentage on the coin UI.
///
Widget percentDisplay({double fontSize = 40, double percentage = 0.0}) {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: fontSize * 1.125, top: fontSize / 8),
      child: Text(
          (percentage).toStringAsFixed(2), // The message that displays point value
        style: TextStyle(
          fontFamily: 'ReemKufi',
          color: Colors.black,
          fontSize: fontSize,
          decoration: TextDecoration.none,
        ),
      ));
}

///
/// The method for rendering the 'End Session' button.
///
Widget endSessionButton({double width = 80, func}) {
  return Container(
      margin: EdgeInsets.only(left: width - (width / 2)),
      width: width,
      height: width,
      child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: IconButton(
            icon: Container(
              child: SvgPicture.asset(
                'assets/images/end-button.svg',
              ),
            ),
            onPressed: () {
              func();
            },
          )));
}

///
/// The method for rendering the text feedback.
///
Widget textFeedback({double padding = 30, double fontSize = 19, String status = ""}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: padding),
    child: Text(
      status, // The message that displays based on how good their doing
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none),
    ),
  );
}

///
/// The method that renders the points feedback on the side of the screen.
///
Widget pointsFeedback({double fontSize = 120, bool showPointsCue, int pointsGainCount}) {
  return Container(
    // color: Colors.brown,
      alignment: Alignment.topCenter,
      child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: "ReemKufi",
            color: Color(0xFFFFEF6C),
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
          child: showPointsCue
              ? AnimatedTextKit(
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              animatedTexts: [
                RotateAnimatedText(
                    "+" +
                        (pointsGainCount)
                            .toString(), // The message that displays based on how good their doing
                    transitionHeight: fontSize * 2,
                    textAlign: TextAlign.center)
              ])
              : SizedBox.shrink()));
}

String getScoreChangeSign(int pointsGainCount) {
  return pointsGainCount >= 0 ? "+" : "";
}

///
/// The controller that fires confetti from the left of the screen.
///
Widget confettiLeft({ConfettiController controllerCenterRight, List<Color> confettiColors}) {
  return Align(
    alignment: Alignment.centerRight,
    child: ConfettiWidget(
      confettiController: controllerCenterRight,
      blastDirection: pi, // radial value, shoots left
      particleDrag: 0.05, //applies drag to the confetti
      emissionFrequency: 0.6, //how often it emits
      numberOfParticles: 2, //number of particles to emit
      gravity: 0.15, // fall speed
      shouldLoop: false,
      colors: confettiColors,
    ),
  );
}

///
/// The controller that fires confetti from the right of the screen.
///
Widget confettiRight({ConfettiController controllerCenterLeft, List<Color> confettiColors}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: ConfettiWidget(
      confettiController: controllerCenterLeft,
      blastDirection: 0, // radial value, shoots right
      particleDrag: 0.05, //applies drag to the confetti
      emissionFrequency: 0.6, //how often it emits
      numberOfParticles: 2, //number of particles to emit
      maximumSize: const Size(
          20, 20), // max potential size of the confetti (width, height)
      gravity: 0.15, // fall speed
      shouldLoop: false,
      colors: confettiColors,
    ),
  );
}

///
/// The controller that fires confetti from the center bottom of the screen.
///
Widget confettiCenter({ConfettiController controllerCenter, List<Color> confettiColors}) {
  return
    //Center --Blast  --> All the confetti cannons
    Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: controllerCenter,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: confettiColors,
      ),
    );
}