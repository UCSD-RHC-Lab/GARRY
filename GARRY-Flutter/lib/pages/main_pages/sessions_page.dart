import 'package:flutter/cupertino.dart';
import 'package:garryapp/pages/summary_pages/past_session_page.dart';
import 'package:garryapp/widgets/navigation.dart';
import 'package:garryapp/ui/dimensions.dart';
import 'package:garryapp/globals/global_states.dart';

import 'package:garryapp/pages/main_pages/feedback_selection_page.dart';
import 'package:garryapp/widgets/text_labels.dart';


///
/// The page that allows users to 1) create a new session or 2) view previous session data
///
class SessionsPage extends StatefulWidget {
  SessionsPage({Key key}) : super(key: key);

  @override
  _SessionsPageState createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  @override
  Widget build(BuildContext context) {
    // for responsiveness
    double idLabelFontSize = Dimensions.computeSize(context, ComputeMode.width,
        Pages.sessionPage, SessionPageComponent.idLabelFontSize);
    double buttonFontSize = Dimensions.computeSize(context, ComputeMode.width,
        Pages.sessionPage, SessionPageComponent.buttonFontSize);
    double buttonPaddingSize = Dimensions.computeSize(
        context,
        ComputeMode.width,
        Pages.sessionPage,
        SessionPageComponent.startButtonPadding);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: navBar('Sessions'),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: buttonPaddingSize),
        child: Column(
          children: [
            participantIDLabel(fontSize: idLabelFontSize),
            Flexible(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  startNewSessionButton(
                      fontSize: buttonFontSize,
                      paddingSize: buttonPaddingSize),
                  viewPastSessionsButton(fontSize: buttonFontSize)
                ]))
          ],
        ),
      ),
    );
  }

  ///
  /// The button for starting a new session.
  ///
  Widget startNewSessionButton(
      {double fontSize = 40.0, paddingSize = 100.0}) {
    return Container(
        padding: EdgeInsets.only(bottom: paddingSize + 10),
        child: CupertinoButton.filled(
            padding: EdgeInsets.symmetric(
                vertical: paddingSize * (1 / 3.6),
                horizontal: paddingSize * 0.5),
            borderRadius: BorderRadius.circular(50),
            onPressed: () {
              Navigator.push(
                // moves you to the next page
                context,
                CupertinoPageRoute(
                    builder: (context) => FeedbackSelectionPage()),
              );
            },
            child: Text(
              "Start New Session",
              style: TextStyle(fontSize: fontSize),
            )));
  }

  ///
  /// The button for viewing past sessions
  ///
  Widget viewPastSessionsButton({double fontSize = 40.0}) {
    return CupertinoButton(
        onPressed: () {
          Navigator.push(
                // moves you to the next page
                context,
                CupertinoPageRoute(
                    builder: (context) => PastSessionPage(participantId: int.parse(globalData['participant_id']),)),
              );
        },
        child:
            Text("View Past Sessions", style: TextStyle(fontSize: fontSize)));
  }
}
