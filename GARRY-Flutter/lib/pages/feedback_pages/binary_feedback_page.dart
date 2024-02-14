import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/base_feedback_page/base_feedback_page.dart';
import 'package:myapp/pages/base_feedback_page/feedback_page_components.dart';
import 'package:myapp/pages/base_feedback_page/file_selection_page.dart';

import 'package:myapp/globals/global_states.dart';
import 'package:myapp/components/confetti_colors.dart' as confettiColors;

///
/// Binary Feedback Session page:
/// This basically controls the asethtics and game mode changes that occur on the base feedback page when
/// A Binary session is selected
///
class BinaryRoute extends FileSelectionPage {
  final String feedbackType;
  final Color pageColor;
  final String navBarText;
  const BinaryRoute({Key key, this.feedbackType, this.pageColor, this.navBarText}) : super(key: key, pageColor: pageColor, navBarText: navBarText);
}

class BinaryFeedback extends BaseFeedbackPage {
  final String filePath;
  final Color pageColor;
  final int selectedIndex;
  const BinaryFeedback({Key key, this.filePath, this.pageColor, this.selectedIndex}) : super(key: key, filePath: filePath, pageColor: pageColor, selectedIndex: selectedIndex);
  @override
  _BinaryFeedbackState createState() => _BinaryFeedbackState();
}

class _BinaryFeedbackState extends BaseFeedbackPageState<BinaryFeedback> {
  // Confetti & celebratory stuff
  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;

  // This kicks in once the page is opened
  // Adding the info for the session
  @override
  void initState() {
    globalData['feedback_type'] = 'Binary';
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(milliseconds: 200));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));

    setState(() {
        testSocket(widget.selectedIndex);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    setDimensions();

    // This section deals with the colors/celebrations
    if (0 < liquidPercent && liquidPercent < 0.5) {
      valueColor = AlwaysStoppedAnimation(Color(0xFFfc784f).withOpacity(0.5));
      status = 'Decent try';
      points -= 1;
    } else if (0.5 <= liquidPercent && liquidPercent < 0.75) {
      status = "Keep going";
      points += 1;
      _controllerCenter.play();
    } else if (0.75 <= liquidPercent && liquidPercent < 0.9) {
      status = "Keep going";
      points += 1;
      _controllerCenterRight.play();
      _controllerCenterLeft.play();
    } else if (0.9 <= liquidPercent) {
      status = "Keep going";
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
    //widget.channel.sink.close();
    super.dispose();
  }
}