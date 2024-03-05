import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:garryapp/pages/feedback_pages/binary_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/explicit_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/negative_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/positive_feedback_page.dart';

import 'package:garryapp/components/navigation.dart';
import 'package:garryapp/components/selection_menu.dart';
import 'package:garryapp/ui/dimensions.dart';

///
/// File Selection Page:
/// The code that controls how stored data is chosen and processed for simulated sessions.
///

//The options for data sets to be chosen, will be changed to a file explorer method once we update the sdk
final List<String> menuTexts = ["03 Session 1", "03 Session 2", "03 Session 3", "91 Session 1", "91 Session 2"];

class FileSelectionPage extends StatefulWidget {
  final String feedbackType;
  final Color pageColor;
  final String navBarText;

  const FileSelectionPage({Key key, this.feedbackType, this.pageColor, this.navBarText}) : super(key: key);

  @override
  FileSelectionPageState createState() => FileSelectionPageState();
}

class FileSelectionPageState<T extends FileSelectionPage> extends State<T> {
  String filePath = '';
  bool _pageLoaded = false;
  int selectedIndex = 0;

  //The file paths of the sessions we have data on
  final List<String> filePaths = [
    "assets/01.csv",
    "assets/02.csv",
    "assets/03.csv",
    "assets/04.csv",
    "assets/05.csv",
  ];

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

 // Code that selects the right dataset once chosen.
  void _pickFile() {
    setState(() {
       _pageLoaded = true;
    });
    filePath = filePaths[selectedIndex];
    print('This is the selected index: ' + selectedIndex.toString());
  }

  // The code that changes the session page to the appropriate colors/game mode before loading.
  Widget _selectPage(String feedbackType) {
    switch (feedbackType) {
      case 'positive':
        return PositiveFeedback(filePath: filePath, pageColor: widget.pageColor, selectedIndex: selectedIndex);
      
      case 'negative':
        return NegativeFeedback(filePath: filePath, pageColor: widget.pageColor, selectedIndex: selectedIndex);
      
      case 'explicit':
        return ExplicitFeedback(filePath: filePath, pageColor: widget.pageColor, selectedIndex: selectedIndex);

      default:
        return BinaryFeedback(filePath: filePath, pageColor: widget.pageColor, selectedIndex: selectedIndex);
    }
  }

  // Code that displays the page.
  @override
  Widget build(BuildContext context) {
    double selectionMenuFontSize = Dimensions.computeSize(
      context,
      ComputeMode.width,
      Pages.selectionPage,
      SelectionPageComponent.selectionMenuFontSize);
    SelectionMenu selectionMenu = SelectionMenu(
      texts: menuTexts,
      fontSize: selectionMenuFontSize,
      setSelectedIndex: setSelectedIndex,
    );

    return CupertinoPageScaffold(
      navigationBar: navBar(widget.navBarText),
      child: Container(
        alignment: Alignment.center,
        color: widget.pageColor,
        child: _pageLoaded?
        _selectPage(widget.feedbackType)
            : Column(
          children: [
            Flexible(flex: 7, child: selectionMenu),
            Spacer(flex: 1,),
            Flexible(flex: 2,child: ElevatedButton(onPressed: _pickFile, child: Text('Pick the Session'))),
          ],
        ), //defines the content of the page as a single class that we can alter
      ),
    );
  }
}
