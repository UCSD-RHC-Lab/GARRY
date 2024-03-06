import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garryapp/pages/base_feedback_page/base_feedback_page.dart';
import 'package:garryapp/pages/base_feedback_page/feedback_page_widgets.dart';

import 'package:garryapp/globals/global_states.dart';
import 'package:garryapp/constants/confetti_colors.dart' as confettiColors;


///
/// The specific feedback page for the binary feedback mode. Inherits BaseFeedbackPage.
///
class BinaryFeedback extends BaseFeedbackPage {
  final Color pageColor;
  final int selectedIndex;
  const BinaryFeedback({Key key, this.pageColor, this.selectedIndex}) : super(key: key, pageColor: pageColor, selectedIndex: selectedIndex);
  @override
  _BinaryFeedbackState createState() => _BinaryFeedbackState();
}

class _BinaryFeedbackState extends BaseFeedbackPageState<BinaryFeedback> {
  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;

  @override
  void initState() {
    globalData['feedback_type'] = 'Binary';
    // initializes the confetti controller states
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));

    setState(() {
        handleMatlabSocket(widget.selectedIndex);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    setDimensions();

    // This section deals with the text feedback and celebrations
    if (0 < liquidPercent && liquidPercent < 0.5) {
      status = "You can do better, keep going";
      valueColor = AlwaysStoppedAnimation(Color(0xFFfc784f).withOpacity(0.5));
      points -= 1;
    } else if (0.5 <= liquidPercent && liquidPercent < 0.75) {
      status = "Decent try";
      points += 1;
      _controllerCenter.play();
    } else if (0.75 <= liquidPercent && liquidPercent < 0.9) {
      status = "Wow!, you're killing it!";
      points += 1;
      _controllerCenterRight.play();
      _controllerCenterLeft.play();
    } else if (0.9 <= liquidPercent) {
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
        // body includes confetti and main content
        children: [
          confettiCenter(controllerCenter: _controllerCenter, confettiColors: confettiColors.binaryConfetti),
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
    super.dispose();
  }
}