import 'package:flutter/cupertino.dart';
import 'package:myapp/widgets/scoreboard.dart';
import 'package:myapp/components/navigation.dart';
import 'package:myapp/globals/global_states.dart';

///
/// Summary page:
/// The page that hosts the leaderboard that is shown after a session is concluded.
///

class SummaryRoute extends StatefulWidget {
  final int sessionId;
  final String feedbackType;
  const SummaryRoute({this.sessionId, this.feedbackType});

  @override
  State<StatefulWidget> createState() => _SummaryRouteState();
}

class _SummaryRouteState extends State<SummaryRoute> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: navBar('Summary page'),
        // backgroundColor: Color.fromARGB(40, 232, 232, 237),
        child: Container(
            color: CupertinoColors.white,
            alignment: Alignment.center,
            // The Scoreboard widget
            child: Scoreboard(sessionId: widget.sessionId, feedbackType: widget.feedbackType, participantId: int.parse(globalData['participant_id']))));
  }
}
