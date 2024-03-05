import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:garryapp/pages/base_feedback_page/base_feedback_page.dart';
import 'package:garryapp/pages/base_feedback_page/feedback_page_components.dart';
import 'package:garryapp/globals/global_states.dart';
import 'package:garryapp/components/confetti_colors.dart' as confettiColors;

import 'package:garryapp/pages/base_feedback_page/file_selection_page.dart';

///
/// Positive Feedback Session page:
/// This basically controls the asethtics and game mode changes that occur on the base feedback page when
/// A Positive session is selected
///
class PositiveRoute extends FileSelectionPage {
  final Color pageColor;
  final String navBarText;
  const PositiveRoute({Key key, this.pageColor, this.navBarText}) : super(key: key, pageColor: pageColor, navBarText: navBarText);
}

class PositiveFeedback extends BaseFeedbackPage {
  final String filePath; // chosen file from the options list
  final Color pageColor;
  final int selectedIndex;
  const PositiveFeedback({Key key, this.filePath, this.pageColor, this.selectedIndex}) : super(key: key, filePath: filePath, pageColor: pageColor, selectedIndex: selectedIndex);
  @override
  _PositiveFeedbackState createState() => _PositiveFeedbackState();
}

class _PositiveFeedbackState extends BaseFeedbackPageState<PositiveFeedback> {
  // Confetti & celebratory stuff
  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;

  // This kicks in once the page is opened
  // Adding the info for the session
  @override
  void initState() {
    super.initState();
    globalData['feedback_type'] = 'Positive';
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));

    testSocket(widget.selectedIndex);
    super.initState();
  }

  Widget build(BuildContext context) {
    setDimensions();

    // This section deals with the colors/celebrations
    if (0 < liquidPercent && liquidPercent < 0.5) {
      valueColor = AlwaysStoppedAnimation(Color(0xFFfc784f).withOpacity(0.5));
      status = 'Decent try!';
    } else if (0.5 <= liquidPercent && liquidPercent < 0.75) {
      valueColor = AlwaysStoppedAnimation(Color(0xFF46c262).withOpacity(0.5));
      status = 'You got it! Keep going!';
      points += 1;
      _controllerCenter.play();
    } else if (0.75 <= liquidPercent && liquidPercent < 0.9) {
      valueColor = AlwaysStoppedAnimation(Color(0xFF46c262).withOpacity(0.5));
      status = "Wow!, you're killing it!";
      points += 1;
      _controllerCenterRight.play();
      _controllerCenterLeft.play();
    } else if (0.9 <= liquidPercent) {
      valueColor = AlwaysStoppedAnimation(Colors.yellowAccent[700].withOpacity(0.5));
      status = "You're an absolute STAR!!!";
      points += 1;
      _controllerCenterRight.play();
      _controllerCenterLeft.play();
      _controllerCenter.play();
    }

    return Container(
      child: isLoading ? loadingPage() :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          confettiCenter(controllerCenter: _controllerCenter, confettiColors: confettiColors.confetti),
          ...mainBody()
        ],
      )
    );
  }

  @override
  void dispose() {
    disposed = true; // Set flag when widget is disposed
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    channel.sink.close();
    super.dispose();
  }
}