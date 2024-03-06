import 'package:garryapp/api/api.dart' as api;
import 'package:garryapp/pages/main_pages/sessions_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:garryapp/ui/dimensions.dart';
import 'package:garryapp/providers/user_model.dart';
import 'package:provider/provider.dart';

import 'widgets/navigation.dart';

///
/// The landing page of the application, an entry point that deals with user authentication.
///
void main() => runApp(
    ChangeNotifierProvider(create: ((context) => UserModel()), child: GarryApp())
);

///
/// Main app
///
class GarryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: Login(),
    );
  }
}

///
/// The widget that allows a user/researcher to enter their participant ID.
/// If this ID does not already exist, it also prompts the user to enter
/// their name, and they will then be registered in the database.
/// 
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ///
  /// Text Field Controllers that contain user input
  ///
  final pidController = TextEditingController();
  final newUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double baseFontSize = Dimensions.computeSize(context, ComputeMode.width,
        Pages.mainPage, MainPageComponent.nextButton);
    double headerFontSize = Dimensions.computeSize(
        context, ComputeMode.width, Pages.mainPage, MainPageComponent.label);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: navBar('GARRY Demo'),
      child: Stack(
        children: [
          Container(
              alignment: Alignment
                  .center, // Align the box that everything is loaded in
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    participantIDPrompt(fontSize: headerFontSize),
                    // Responsive spacer between label and text field
                    Flexible(
                        child: FractionallySizedBox(
                      heightFactor: 0.15,
                    )),
                    participantIDTextField(),
                    // Responsive spacer/padding on bottom
                    Flexible(
                        child: FractionallySizedBox(
                      heightFactor: 0.25,
                    )),
                  ])),
          Align(
            alignment: Alignment.bottomCenter,
            child: nextPageButton(
                text: 'next',
                fontSize: baseFontSize * (1 / 1.4),
                onPressed: () => {
                      if (pidController.text.isNotEmpty)
                        {
                          // If the user has input a PID
                          _checkUserExists(pidController.text),
                          _nextPage(context)
                        }
                    },
                color: CupertinoTheme.of(context).primaryColor),
          )
        ],
      ),
    );
  }

  ///
  /// Return the text widget for labeling the text field ("Enter Participant
  /// ID").
  ///
  Widget participantIDPrompt({double fontSize = 52}) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Enter Participant ID: ",
        style: TextStyle(
            color: CupertinoColors.black,
            fontSize: fontSize,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  ///
  /// The actual text field, where you put in the PID.
  ///
  Widget participantIDTextField() {
    return FractionallySizedBox(
        widthFactor: 0.7,
        child: CupertinoTextField(
          controller: pidController,
          placeholder: 'ID',
          prefix: Container(
              padding: EdgeInsets.only(left: 15),
              child: Icon(CupertinoIcons.person)),
          suffix: CupertinoButton(
              child: Icon(CupertinoIcons.clear),
              onPressed: () => pidController.clear()),
          textInputAction: TextInputAction.done,
        ));
  }

  ///
  /// Button that pops up when the user enters a pid number not currently in the database
  /// Allows them to add a new name
  ///
  Widget newUserButton() {
    return FractionallySizedBox(
        widthFactor: 0.7,
        child: CupertinoTextField(
          controller: newUserController,
          placeholder: 'New User Name',
          prefix: Container(
              padding: EdgeInsets.only(left: 15),
              child: Icon(CupertinoIcons.person)),
          suffix: CupertinoButton(
              child: Icon(CupertinoIcons.clear),
              onPressed: () => newUserController.clear()),
          textInputAction: TextInputAction.done,
        ));
  }

  /// 
  /// This section checks if the pid entered exists in the database, only accepts numerical input
  ///
  Future<void> _checkUserExists(String pid) async {
    var userCheck = await api.checkUserExists(pid);
    if (userCheck == false) {
      // User does not exist, create a new user
      // Add a popup so they can enter a new name for a user
      await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text('Create new User'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [newUserButton()],
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('Submit'),
                      isDefaultAction: true,
                      onPressed: () {
                        api.createNewUser(newUserController
                            .text); // Send the name to the database
                        Navigator.pop(context);
                      }),
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
      return newUserButton();
    }
  }

  ///
  /// Moves the user to the next page, which is the [SessionsPage] that allows
  /// them to choose to view past sessions or to start a new session.
  ///
  void _nextPage(BuildContext context) {
    String textToSend = pidController.text;
    Provider.of<UserModel>(context, listen: false)
        .setPid(int.parse(textToSend));

    Navigator.push(
      // moves you to the next page
      context,
      CupertinoPageRoute(builder: (context) => SessionsPage()),
    );
  }
}
