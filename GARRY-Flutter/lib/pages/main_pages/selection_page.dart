import 'package:flutter/cupertino.dart';
import 'package:garryapp/components/navigation.dart';
import 'package:garryapp/components/selection_menu.dart';

import 'package:garryapp/ui/dimensions.dart';
import 'package:garryapp/pages/feedback_pages/binary_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/explicit_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/negative_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/positive_feedback_page.dart';
import 'package:garryapp/components/text_labels.dart';

final List<String> menuTexts = ["Positive", "Negative", "Binary", "Explicit"];
final String serverAddr = "ws://localhost:4000";

///
/// The Selection page:
/// Users can pick the specific type of session they want to partake in.
///
class SelectionPage extends StatefulWidget {
  SelectionPage({Key key}) : super(key: key);

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  int selectedIndex = 0;
  final emailController = TextEditingController();
  final List<Function> menuBuilders = [
    (context) => PositiveRoute(
          pageColor: Color(0xFF246CFF),
          navBarText: 'Positive Feedback',
        ),
    (context) => NegativeRoute(
          pageColor: Color(0xFFFF7E55),
          navBarText: 'Negative Feedback',
        ),
    (context) => BinaryRoute(
          pageColor: Color.fromARGB(96, 169, 114, 114),
          navBarText: 'Binary Feedback',
        ),
    (context) => ExplicitRoute(
          pageColor: Color.fromARGB(255, 39, 36, 36),
          navBarText: 'Explicit Feedback',
        ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  ///
  /// Feedback selection picker
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
              nextPageButton(
                  text: "start",
                  fontSize: idLabelFontSize,
                  onPressed: () => Navigator.push(context,
                      CupertinoPageRoute(builder: menuBuilders[selectedIndex])),
                  color: CupertinoTheme.of(context).primaryColor),
            ],
          )),
    );
  }
}
