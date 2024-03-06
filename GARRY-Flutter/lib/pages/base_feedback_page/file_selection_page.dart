import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:garryapp/pages/feedback_pages/binary_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/explicit_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/negative_feedback_page.dart';
import 'package:garryapp/pages/feedback_pages/positive_feedback_page.dart';

import 'package:garryapp/widgets/navigation.dart';
import 'package:garryapp/widgets/selection_menu.dart';
import 'package:garryapp/ui/dimensions.dart';


// The options for data sets to be chosen, will be changed to a file explorer method once we update the sdk
final List<String> menuTexts = ["03 Session 1", "03 Session 2", "03 Session 3", "91 Session 1", "91 Session 2"];

///
/// The page to select which data to stream for simulated sessions.
///
class FileSelectionPage extends StatefulWidget {
  final String feedbackType;
  final Color pageColor;
  final String navBarText;

  const FileSelectionPage({Key key, this.feedbackType, this.pageColor, this.navBarText}) : super(key: key);

  @override
  FileSelectionPageState createState() => FileSelectionPageState();
}

class FileSelectionPageState<T extends FileSelectionPage> extends State<T> {
  bool _pageLoaded = false;
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  ///
  /// Code that selects the right dataset once chosen.
  ///
  void _pickFile() {
    setState(() {
      _pageLoaded = true;
    });
  }

  ///
  /// Returns the appropriate session page and sets corresponding colors/game mode before loading.
  /// 
  Widget _selectPage(String feedbackType) {
    switch (feedbackType) {
      case 'positive':
        return PositiveFeedback(pageColor: widget.pageColor, selectedIndex: selectedIndex);
      
      case 'negative':
        return NegativeFeedback(pageColor: widget.pageColor, selectedIndex: selectedIndex);
      
      case 'explicit':
        return ExplicitFeedback(pageColor: widget.pageColor, selectedIndex: selectedIndex);

      default:
        return BinaryFeedback(pageColor: widget.pageColor, selectedIndex: selectedIndex);
    }
  }

  ///
  /// Builds a simple selection menu to choose the data file.
  ///
  @override
  Widget build(BuildContext context) {
    double selectionMenuFontSize = Dimensions.computeSize(
      context,
      ComputeMode.width,
      Pages.selectionPage,
      SelectionPageComponent.selectionMenuFontSize);

    // utilizes selection menu widget
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
        child: _pageLoaded? // if loaded
        _selectPage(widget.feedbackType) // then display feedback page
            : Column(
          children: [ // otherwise, display the selection menu
            Flexible(flex: 7, child: selectionMenu),
            Spacer(flex: 1,),
            Flexible(flex: 2,child: ElevatedButton(onPressed: _pickFile, child: Text('Pick the Session'))),
          ],
        ),
      ),
    );
  }
}
