import 'package:flutter/cupertino.dart';
import 'package:garryapp/pages/base_feedback_page/file_selection_page.dart';
import 'package:garryapp/widgets/navigation.dart';
import 'package:garryapp/widgets/selection_menu.dart';

import 'package:garryapp/ui/dimensions.dart';
import 'package:garryapp/widgets/text_labels.dart';

final List<String> menuTexts = ["Positive", "Negative", "Binary", "Explicit"];
final String serverAddr = "ws://localhost:4000";

///
/// Allows the user to pick the specific type of session they want to partake in:
/// Positive, Negative, Binary, Explicit. After choosing the feedback type, the
/// user will be allowed to choose which file they want to stream the data in with
/// (for simulation purposes).
///
class FeedbackSelectionPage extends StatefulWidget {
  FeedbackSelectionPage({Key key}) : super(key: key);

  @override
  _FeedbackSelectionPageState createState() => _FeedbackSelectionPageState();
}


class _FeedbackSelectionPageState extends State<FeedbackSelectionPage> {
  int selectedIndex = 0;
  final emailController = TextEditingController();

  ///
  /// Contains the file selection pages for each type of feedback. Parameters include
  /// the page color and text for the navigation bar. This list will be used to route
  /// the user to the respective file selection page.
  ///
  final List<Function> fileSelectionRoutes = [
    (context) => FileSelectionPage(
          feedbackType: 'positive',
          pageColor: Color(0xFF246CFF),
          navBarText: 'Positive Feedback',
        ),
    (context) => FileSelectionPage(
          feedbackType: 'negative',
          pageColor: Color(0xFFFF7E55),
          navBarText: 'Negative Feedback',
        ),
    (context) => FileSelectionPage(
          feedbackType: 'binary',
          pageColor: Color.fromARGB(96, 169, 114, 114),
          navBarText: 'Binary Feedback',
        ),
    (context) => FileSelectionPage(
          feedbackType: 'explicit',
          pageColor: Color.fromARGB(255, 39, 36, 36),
          navBarText: 'Explicit Feedback',
        ),
  ];

  @override
  void initState() {
    super.initState();
  }

  ///
  /// Sets the selected menu item index
  ///
  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  ///
  /// Feedback selection picker label
  ///
  Widget selectFeedbackLabel(
      {double fontSize = Dimensions.DEFAULT_FONT_SIZE,
      double paddingSize = 30.0}) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: paddingSize),
        child: Text("Select Feedback: ",
            style: TextStyle(
                color: CupertinoColors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none)));
  }

  ///
  /// Returns a selection menu for feedback type. Includes:
  /// 1. Participant ID label
  /// 2. Spacer
  /// 3. A label to prompt user to select a feedback type
  /// 4. Spacer
  /// 5. The selection menu
  /// 6. A next page button
  ///
  Widget build(BuildContext context) {
    double selectFeedbackLabelFontSize = Dimensions.computeSize(
        context,
        ComputeMode.width,
        Pages.selectionPage,
        SelectionPageComponent.selectFeedbackLabelFontSize);
    double selectionMenuFontSize = Dimensions.computeSize(
        context,
        ComputeMode.width,
        Pages.selectionPage,
        SelectionPageComponent.selectionMenuFontSize);
    double idLabelFontSize = Dimensions.computeSize(context, ComputeMode.width,
        Pages.selectionPage, SelectionPageComponent.idLabelFontSize);
    double paddingSize = Dimensions.computeSize(context, ComputeMode.width,
        Pages.selectionPage, SelectionPageComponent.feedbackLabelPaddingSize);

    SelectionMenu selectionMenu = SelectionMenu(
      texts: menuTexts,
      fontSize: selectionMenuFontSize,
      setSelectedIndex: setSelectedIndex,
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: navBar('Feedback Selection'),
      child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              participantIDLabel(fontSize: idLabelFontSize),
              Spacer(flex: 1),
              selectFeedbackLabel(
                  fontSize: selectFeedbackLabelFontSize,
                  paddingSize: paddingSize),
              Spacer(flex: 1),
              Flexible(flex: 8, child: selectionMenu),
              nextPageButton(     // the next page button will transition users to go to [FileSelectionPage].
                  text: "start",
                  fontSize: idLabelFontSize,
                  onPressed: () => Navigator.push(context,
                      CupertinoPageRoute(builder: fileSelectionRoutes[selectedIndex])),
                  color: CupertinoTheme.of(context).primaryColor),
            ],
          )),
    );
  }
}
