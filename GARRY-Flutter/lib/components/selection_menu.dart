import 'package:flutter/cupertino.dart';

///
/// The SelectionMenu class is a Column widget that groups buttons together but
/// will only highlight the selected one. It must be a StatefulWidget because it
/// keeps track of which option is currently being selected, and builds (and
/// highlights) accordingly.
///
class SelectionMenu extends StatefulWidget {
  final List<String> texts;
  final double fontSize;
  final Function setSelectedIndex;

  SelectionMenu({Key key, this.texts, this.fontSize, this.setSelectedIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionMenu();
}

class _SelectionMenu extends State<SelectionMenu> {
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.setSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> options = [];

    for (var i = 0; i < widget.texts.length; i++) {
      options.add(SelectionMenuOption(
        index: i,
        setSelected: setSelectedIndex,
        fontSize: widget.fontSize,
        text: widget.texts[i],
        selected: selectedIndex == i,
      ));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: options);
  }
}

///
/// Selection menu option class
///
class SelectionMenuOption extends StatelessWidget {
  final double fontSize;
  final int index;
  final String text;
  final Function setSelected;
  final bool selected;

  SelectionMenuOption(
      {Key key,
      this.index,
      this.setSelected,
      this.fontSize,
      this.text,
      this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.symmetric(
            vertical: this.fontSize / 1.8, horizontal: this.fontSize * 1.2),
        color: selected ? CupertinoTheme.of(context).primaryColor : null,
        borderRadius: BorderRadius.circular(50),
        onPressed: () {
          this.setSelected(this.index);
        },
        child: Text(this.text,
            style: TextStyle(
                fontSize: this.fontSize,
                color:
                    selected ? CupertinoColors.white : CupertinoColors.black)));
  }
}
