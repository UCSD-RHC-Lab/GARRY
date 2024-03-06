import 'package:flutter/cupertino.dart';
import 'package:garryapp/widgets/scoreboard.dart';
import 'package:garryapp/widgets/navigation.dart';
import 'package:garryapp/globals/global_states.dart';

///
/// The page that hosts the leaderboard that is shown after a session is concluded.
///
class SummaryPage extends StatefulWidget {
  final int sessionId;
  final String feedbackType;
  const SummaryPage({this.sessionId, this.feedbackType});

  @override
  State<StatefulWidget> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: navBar('Summary page'),
        child: Container(
            color: CupertinoColors.white,
            alignment: Alignment.center,
            // The Scoreboard widget
            child: Scoreboard(sessionId: widget.sessionId, feedbackType: widget.feedbackType, participantId: int.parse(globalData['participant_id']))));
  }
}
