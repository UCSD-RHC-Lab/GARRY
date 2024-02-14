import 'package:flutter/cupertino.dart';
import 'package:myapp/pages/base_feedback_page/base_feedback_page.dart';
import 'package:myapp/pages/base_feedback_page/file_selection_page.dart';

import 'package:myapp/globals/global_states.dart';

///
/// Negative Feedback Session page:
/// This basically controls the asethtics and game mode changes that occur on the base feedback page when
/// A Negative session is selected
///
class NegativeRoute extends FileSelectionPage {
  final Color pageColor;
  final String navBarText;
  const NegativeRoute({Key key, this.pageColor, this.navBarText}) : super(key: key, pageColor: pageColor, navBarText: navBarText);
}

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
    testSocket(widget.selectedIndex);
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
    //widget.channel.sink.close();
    super.dispose();
  }
}