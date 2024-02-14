import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/base_feedback_page/base_feedback_page.dart';
import 'package:myapp/pages/base_feedback_page/file_selection_page.dart';

import 'package:myapp/globals/global_states.dart';

///
/// Explicit Feedback Session page:
/// This basically controls the asethtics and game mode changes that occur on the base feedback page when
/// A Explicit session is selected. There are no messages or confetti.
///
class ExplicitRoute extends FileSelectionPage {
  final String feedbackType;
  final Color pageColor;
  final String navBarText;
  const ExplicitRoute({Key key, this.feedbackType, this.pageColor, this.navBarText}) : super(key: key, pageColor: pageColor, navBarText: navBarText);
}

class ExplicitFeedback extends BaseFeedbackPage {
  final String filePath;
  final Color pageColor;
  final int selectedIndex;
  const ExplicitFeedback({Key key, this.filePath, this.pageColor, this.selectedIndex}) : super(key: key, filePath: filePath, pageColor: pageColor, selectedIndex: selectedIndex);
  @override
  _ExplicitFeedbackState createState() => _ExplicitFeedbackState();
}

class _ExplicitFeedbackState extends BaseFeedbackPageState<ExplicitFeedback> {
  @override
  void initState() {
    globalData['feedback_type'] = 'Explicit';

    setState(() {
      testSocket(widget.selectedIndex);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    setDimensions();

    return Container(
        child: isLoading ? loadingPage() :
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...mainBody()
          ],
        ));
  }

  @override
  void dispose() {
    disposed = true; // Set flag when widget is disposed
    //widget.channel.sink.close();
    super.dispose();
  }
}