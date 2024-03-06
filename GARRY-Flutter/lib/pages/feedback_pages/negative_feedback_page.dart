import 'package:flutter/cupertino.dart';
import 'package:garryapp/pages/base_feedback_page/base_feedback_page.dart';

import 'package:garryapp/globals/global_states.dart';

///
/// The specific feedback page for the negative feedback mode. Inherits BaseFeedbackPage.
/// There is no confetti.
///
class NegativeFeedback extends BaseFeedbackPage {
  final String filePath;
  final Color pageColor;
  final int selectedIndex;
  const NegativeFeedback({Key key, this.filePath, this.pageColor, this.selectedIndex}) : super(key: key, filePath: filePath, pageColor: pageColor, selectedIndex: selectedIndex);
  @override
  _NegativeFeedbackState createState() => _NegativeFeedbackState();
}

class _NegativeFeedbackState extends BaseFeedbackPageState<NegativeFeedback> {
  // This kicks in once the page is opened
  // Adding the info for the session
  @override
  void initState() {
    globalData['feedback_type'] = 'Negative';
    handleMatlabSocket(widget.selectedIndex);
    super.initState();
  }

  Widget build(BuildContext context) {
    setDimensions();

    // This section deals with the colors/celebrations
    if (0 < liquidPercent && liquidPercent < 0.5) {
      points -= 1;
      status = 'You can do better, Keep going';
    } else if (0.5 <= liquidPercent && liquidPercent < 0.75) {
      status = 'Decent try';
    } else if (0.75 < liquidPercent && liquidPercent < 0.9) {
      status = "Ok, still room for improvement";
    } else if (0.9 <= liquidPercent) {
      status = "Wow that's impressive";
    }

    return Container(
      child: isLoading ? loadingPage() :
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...mainBody(),
        ],
      )
    );
  }

  @override
  void dispose() {
    disposed = true; // Set flag when widget is disposed
    super.dispose();
  }
}