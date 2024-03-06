import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:garryapp/pages/summary_pages/summary_page.dart';
import 'package:garryapp/widgets/progress_chart.dart';
import 'package:garryapp/globals/global_states.dart';
import 'package:garryapp/constants/strings.dart';
import 'package:garryapp/api/api.dart' as api;
import 'package:garryapp/globals/global_states.dart' as globals;
import 'package:garryapp/ui/dimensions.dart';
import 'package:garryapp/websockets/roscomm.dart';
import 'package:garryapp/pages/base_feedback_page/feedback_page_widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart';

///
/// Defines the base feedback page that other feedback pages will inherit. This is displayed when
/// a session is run. It displays user progress in a graph, the feedback with a thermometer,
/// the score, and an animated score change count (e.g., +41, -5).
///
class BaseFeedbackPage extends StatefulWidget {
  final String filePath;
  final Color pageColor;
  final int selectedIndex;

  const BaseFeedbackPage({Key key, this.filePath, this.pageColor, this.selectedIndex}) : super(key: key);

  @override
  BaseFeedbackPageState createState() => BaseFeedbackPageState();
}

///
/// Stores the states of the base feedback page.
///
class BaseFeedbackPageState<T extends BaseFeedbackPage> extends State<T> {  
  // --- dimensions ---
  double coinUIWidth;
  double pointsFontSize;
  double endSessionButtonWidth;
  double pointsFeedbackFontSize;
  double thermSize;
  double textFeedbackPadding;
  double textFeedbackSize;

  // --- websockets --- 
  WebSocketChannel channel;
  RosPublisher rosChannel;

  // --- points/coins --- 
  int points = 0;
  int lastPoint = 0;
  int pointsGainCount = 0;
  bool showPointsCue = false;
  DateTime lastShownTime = DateTime.now();

  // --- graph --- 
  List<FlSpot> matlabData = [];
  List<FlSpot> threshline = [];

  // --- general page states --- 
  bool disposed = false;
  bool hasSessionEnded = false;
  bool isLoading = true;

  double goalVal = 0.0; // Start at zero to avoid null errors
  double liquidPercent = 0.0;

  String status = ""; // text feedback

  Animation<Color> valueColor;  
  Stopwatch stopwatch = Stopwatch();

  // --- UI svg files --- 
  final Widget thermBg = SvgPicture.asset(assetPath + 'therm-bg.svg',
      semanticsLabel: 'Thermometer');
  final Widget thermSmiley = SvgPicture.asset(
    assetPath + 'therm-smiley-sized.svg',
    semanticsLabel: 'ThermSmiley',
  );
  // Initial position of the threshold line on the thermometer
  final Widget thermPercentLine1 = SvgPicture.asset(
      assetPath + 'therm-percent-lines-sized.svg',
      semanticsLabel: 'ThermPercentLines'
  );
  // The coin image that appears on the right of the widget
  final Widget coinUI = SvgPicture.asset(
    assetPath + 'coin-ui.svg',
    semanticsLabel: 'CoinUI',
  );

  ///
  /// Here, we don't need to define the build method but need to declare it.
  /// The child page widget will override it.
  ///
  @override
  Widget build(BuildContext context) {

  }

  ///
  /// Gets the number of points the user currently has.
  ///
  int getPointsCb() {
    return points;
  }

  ///
  /// Set the dimmensions of the page
  ///
  void setDimensions() {
    // compute by width
    coinUIWidth = Dimensions.computeSize(context, ComputeMode.width,
      Pages.feedbackPage, FeedbackPageComponent.coinUIWidth);
    pointsFontSize = Dimensions.computeSize(
      context,
      ComputeMode.width,
      Pages.feedbackPage,
      FeedbackPageComponent.pointsFontSize);
    endSessionButtonWidth = Dimensions.computeSize(
      context,
      ComputeMode.width,
      Pages.feedbackPage,
      FeedbackPageComponent.endSessionButtonWidth);

    // compute by height
    pointsFeedbackFontSize = Dimensions.computeSize(
      context,
      ComputeMode.height,
      Pages.feedbackPage,
      FeedbackPageComponent.pointsFeedbackFontSize);
    thermSize = Dimensions.computeSize(context, ComputeMode.height,
      Pages.feedbackPage, FeedbackPageComponent.thermSize);
    textFeedbackPadding = Dimensions.computeSize(
      context,
      ComputeMode.height,
      Pages.feedbackPage,
      FeedbackPageComponent.textFeedbackPadding);
    textFeedbackSize = Dimensions.computeSize(
      context,
      ComputeMode.height,
      Pages.feedbackPage,
      FeedbackPageComponent.textFeedbackSize);
  }

  ///
  /// Loading page that appears before streamed data is received.
  ///
  Widget loadingPage() {
    return 
      Scaffold(
        backgroundColor: widget.pageColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingAnimationWidget.prograssiveDots(
                color: Colors.white,
                size: 100,
              ),
              Text(
                "Waiting for connection...",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 36,
                ),
                textAlign: TextAlign.center,
              ),
            ]
          ),
        )
      );
  }

  ///
  /// The main widget container used in all feedback pages. Includes (from top to bottom):
  /// 1. Spacer
  /// 2. Main feedback interface
  ///   2.1. Left column that holds the end session button
  ///   2.2. Middle column that holds the thermometer
  ///   2.3. Right column that holds the points/coin UI
  /// 3. Text feedback
  /// 4. Progress/history graph
  ///
  List<Widget> mainBody() {
    return [
      Spacer(flex: 1),
      Flexible(
          flex: 21,
          child: Row(
              children: [
                endSessionColumn(
                  endSessionButtonWidth: endSessionButtonWidth,
                  onclick: () => endSessionCallback(
                    stopwatch: stopwatch,
                    globalData: globalData,
                    channel: channel,
                  )
                ),
                thermometerColumn(
                  goalVal: goalVal,
                  thermSize: thermSize,
                  liquidPercent: liquidPercent
                ),
                coinUIColumn(
                  coinUIWidth: coinUIWidth,
                  pointsFontSize: pointsFontSize,
                  points: points,
                  pointsFeedbackFontSize: pointsFeedbackFontSize,
                  showPointsCue: showPointsCue,
                  pointsGainCount: pointsGainCount
                )
              ])),
      textFeedback(
        padding: textFeedbackPadding,
        fontSize: textFeedbackSize,
        status: status
      ),
      graph(matlabData: matlabData, threshline: threshline)
    ];
  }
  
  ///
  /// The column that holds the stop button to end the session.
  ///
  Widget endSessionColumn({double endSessionButtonWidth, dynamic onclick}) {
    return
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: endSessionButton(
                          width: endSessionButtonWidth, func: onclick)),
                ],
              )));
  }

  ///
  /// The column that holds the thermometer widget.
  /// 
  Widget thermometerColumn({double goalVal, double thermSize, double liquidPercent}) {
    return
      Flexible(
          flex: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(alignment: Alignment.center,
                  // stack widgets on top of another in layers
                  children: <Widget>[
                    thermBg,
                    Transform.translate(
                      offset: Offset(
                          constraints.smallest.width,
                          -goalVal * 22),
                      child: thermPercentLine1,
                    ),
                    progressBar(thermSize: thermSize, percent: liquidPercent, color: widget.pageColor),
                    thermSmiley,
                  ]);
            },
          ));
  }

  ///
  /// The column that holds the number of points/percentage the user has/reaches.
  ///
  Widget coinUIColumn({
    double coinUIWidth,
    double pointsFontSize,
    int points,
    double pointsFeedbackFontSize,
    bool showPointsCue,
    int pointsGainCount}) 
    {
      return
        Flexible(
          flex: 1,
          child: Column(children: [
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  coinUIWidget(coinUI: coinUI, width: coinUIWidth),
                  globalData['feedback_type'] != 'Explicit' ? 
                    pointDisplay(fontSize: pointsFontSize, points: points) :
                    percentDisplay(fontSize: pointsFontSize, percentage: matlabData[matlabData.length - 1].y)
                ],
              ),
            ),
            Flexible(
                flex: 5,
                child: pointsFeedback(
                    fontSize: pointsFeedbackFontSize, showPointsCue: showPointsCue, pointsGainCount: pointsGainCount))
        ]));
  }

  ///
  /// The graph widget at the bottom of the feedback page.
  ///
  Widget graph({List<FlSpot> matlabData, List<FlSpot> threshline}) {
    return
      Flexible(
        flex: 7,
        fit: FlexFit.tight,
        child: ProgressChart(
          height: 100,
          dataPoints: matlabData,
          colors: [const Color(0xff23b6e6), CupertinoColors.systemRed,],
          thresholdLine: threshline));
  }

  ///
  /// Connects to the necessary websockets
  ///
  void socketConnect(var selectedIndex) async {
    final wsUrl = Uri.parse(globals.networkConfigs["websocketAddr"]);
    channel = WebSocketChannel.connect(wsUrl);
    rosChannel = RosPublisher(globals.networkConfigs["rosWebSocketAddr"], 'garry/feedback_type', 'std_msgs/String');
    rosChannel.connect();
    rosChannel.publish(globalData['feedback_type']);

    // Start a timer to keep track of the duration
    stopwatch.start();
    // Grab the exact time
    DateTime currentTime = new DateTime.now();
    globalData['start_time'] = currentTime.toString();

    // Send a message to the WebSocket server to pick the corresponding example dataset
    if (selectedIndex == 0) {
      channel.sink.add('one');
    }
    else if (selectedIndex == 1) {
      channel.sink.add('two');
    }
    else if (selectedIndex == 2) {
      channel.sink.add('three');
    }
    else if (selectedIndex == 3) {
      channel.sink.add('four');
    }
    else if (selectedIndex == 4) {
      channel.sink.add('five');
    }
    // Listen to the server
    channel.stream.listen((message) async {
      if (matlabData.length == 0) {
        setState(() {
          isLoading = false;
        });
      }

      if (message != 'end') {
        // Preprocess the data into a list
        var socketData = message.split(',').map((part) => part.trim()).toList();
        var a2Val = double.parse(socketData[0]);
        goalVal = double.parse(socketData[1]);

        // Grab the goal Value as the threshold for the session
        globalData['threshold'] = goalVal.toString();

        // Add the date
        DateTime today = DateTime.now();
        globalData['year'] = today.year.toString();
        globalData['month'] = today.month.toString();
        globalData['day'] = today.day.toString();

        if (a2Val.isNaN) {
          a2Val = 0.0;
        }

        // Adding to the arrays
        matlabData.add(FlSpot(matlabData.length.toDouble(), a2Val/goalVal * 100.0));
        threshline.add(FlSpot(threshline.length.toDouble(), 100));

        // update the liquid and thermometer
        if (!disposed) { 
          setState(() {
          liquidPercent = ((a2Val / goalVal) - 0.5).abs(); // set the thermometer percent value
        });
        }
        checkPointsChange(); // checks how many coins have been gained in the meantime
      }
      else {
        channel.sink.close();
      }

    }, onDone: () {
      // Stream has completed, close the WebSocket connection
      channel.sink.close(normalClosure);
      if (!disposed) {
        setState(() {
        liquidPercent = 0.0; // set the thermometer percent value to 0 to stop adding points
      });
      }
    });
  }

  ///
  /// Ends the session and sends user to the [Scoreboard].
  ///  
  void endSessionCallback({Stopwatch stopwatch, dynamic globalData, dynamic channel}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          'Are you sure you want to end this session?',
          style: TextStyle(fontSize: 15.0),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
              child: Text('End Session'),
              isDefaultAction: true,
              onPressed: () async {
                channel.sink.close();
                // Grab the duration of the session
                stopwatch.stop();
                globalData['duration'] = stopwatch.elapsed.toString();
                // Add the score
                globalData['score'] = points.toString();

                final response = await api.addSession(globalData);
                int sessionId = jsonDecode(response.body)['data']['session_id'];
                
                setState(() {
                  hasSessionEnded = true;
                });
                // Sends user to the right Scoreboard page based on their session ID
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            SummaryPage(sessionId: sessionId, feedbackType: globalData['feedback_type'])));
              }),
          CupertinoDialogAction(
            child: Text(
              'Resume',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
    ));
  }

  ///
  /// Returns the number of seconds since the points cue was last shown.
  ///
  int secondsSinceLastShown() {
    return lastShownTime.difference(DateTime.now()).inSeconds.abs();
  }
  
  ///
  /// Returns whether the points cue for gained/lost should show (e.g., +4, -5)
  /// on a time interval basis.
  ///
  void checkPointsChange() {
    // if it has been more than 3 seconds since last shown, and we haven't shown
    // any point cues, and user's points has changed, then show
    if (!showPointsCue && secondsSinceLastShown() >= 3 && (points - lastPoint).abs() > 0) {
      showPointsCue = true;
      pointsGainCount = points - lastPoint;
      lastPoint = points;
      lastShownTime = DateTime.now();
    }

    // after showing points cue for 2 seconds, we can safely wait for it to show again
    if (showPointsCue && secondsSinceLastShown() >= 2) {
      showPointsCue = false;
    }
  }
}
