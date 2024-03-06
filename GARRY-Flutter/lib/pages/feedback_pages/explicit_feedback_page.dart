import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garryapp/pages/base_feedback_page/base_feedback_page.dart';

import 'package:garryapp/globals/global_states.dart';

///
/// The specific feedback page for the explicit feedback mode. Inherits BaseFeedbackPage. There
/// are no messages (text feedback) or confetti.
///
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
      handleMatlabSocket(widget.selectedIndex);
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