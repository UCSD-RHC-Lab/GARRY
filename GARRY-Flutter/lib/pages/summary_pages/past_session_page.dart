import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garryapp/globals/global_states.dart';
import 'package:garryapp/widgets/navigation.dart';
import 'package:garryapp/api/api.dart' as api;

///
/// Allows users or clinicians to view previous data generated during the sessions
/// separated by session type and presented on cards.
///
class PastSessionPage extends StatefulWidget {
  final int participantId;
  const PastSessionPage({this.participantId});

  @override
  State<PastSessionPage> createState() => _PastSessionPageState();
}

class _PastSessionPageState extends State<PastSessionPage> {
  int _selectedButtonIndex = 0; // Index of the selected button

  List<String> buttonLabels = ['Positive', 'Negative', 'Binary', 'Explicit'];

  List<dynamic> sessionData = [];

  // For the page with the details
  var sessionDetailsMap;

  var buttonBackground = Colors.grey[600];

  List<CardData> cards = [];

  @override
  void initState() {
    super.initState();

    fetchRecentValues(buttonLabels[_selectedButtonIndex]);
  }

  ///
  /// Creates cards which include important information about each session in the database with 
  /// scores and dates of the session presented when their corresponding session type is clicked
  /// 
  Future<void> fetchRecentValues(String feedbackType) async {
    // Fetch the recent values based on the provided PID
    var participantId = globalData['participant_id'];

    sessionData = await api.getSessions(int.parse(participantId), feedbackType);

    setState(() {
      cards = getCardDataListFromSessionData(sessionData);
    });
  }

  ///
  /// A helper method to get the list of CardData from the returned session data from the
  /// API call.
  ///
  List<CardData> getCardDataListFromSessionData(List<dynamic> data) {
    List<CardData> sessionCards = [];

    for (int i = 0; i < sessionData.length; i++) {
      var session = sessionData[i];
      var year = session[2];
      var month = session[3];
      var day = session[4];
      var score = 0.0;
      var date = 'unrecorded';

      if (year != null) {
        date = '$month/$day/$year';     // set date
      }

      if (session[7] != null) {
        score = session[7];             // set score
      }

      sessionCards.add(CardData(        // add CardData to sessionCards
        id: i + 1,
        date: date,
        score: score
      ));
    }

    return sessionCards;
  }


 @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: navBar('Past Sessions'),
      child: Material(
        child: ListView(
          children: <Widget>[
            // Top bar with feedback types
            HorizontalChipList(
              selectedIndex: _selectedButtonIndex,
              buttonLabels: buttonLabels,
              onPressed: (index) {
                setState(() {
                  _selectedButtonIndex = index;
                });
                fetchRecentValues(buttonLabels[index]);
              },
            ),
            SizedBox(height: 20.0,),
            // Where we want the cards list
            ListView.builder(
              shrinkWrap: true,
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Make the data a map now
                    sessionDetailsMap = {
                      'Session ID': sessionData[index][0],
                      'Participant ID': sessionData[index][1],
                      'Year': sessionData[index][2],
                      'Month': sessionData[index][3],
                      'Day': sessionData[index][4],
                      'Start Time': sessionData[index][5],
                      'Duration': sessionData[index][6],
                      'Score': sessionData[index][7],
                      'Feedback Type': sessionData[index][8],
                      'Threshold': sessionData[index][9],
                    };

                    // Navigate to the new page with session data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionDetailsPage(sessionDetails: sessionDetailsMap),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('Session #${cards[index].id}'),
                      subtitle: Text(cards[index].date, style: TextStyle(fontSize: 12)),
                      trailing: Text(
                        'Score: ${cards[index].score.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
              ),
          ],
        ),
      ),
      backgroundColor: Colors.amber[400],
    );
  }
  
}

/// 
/// The card tiles instances that are displayed when a session type is clicked
/// 
class CardData{
  final int id;
  final String date;
  final double score;
  
  CardData({this.id, this.date, this.score});
}

///
/// A horizontal chip radio button list
///
class HorizontalChipList extends StatelessWidget {
  final int selectedIndex;
  final List<String> buttonLabels;
  final Function(int) onPressed;

  HorizontalChipList({this.selectedIndex, this.buttonLabels, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      // To round the corners
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: Colors.grey[600],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(buttonLabels.length, (index) {
          return ElevatedButton(
            onPressed: () {
              onPressed(index); // Call the provided onPressed function
            },
            child: Text(buttonLabels[index]),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedIndex == index ? Colors.blue : Colors.grey[600],
            ),
          );
        }),
        )
    );
  }
}


///
/// Page that displays the details of a session when its card is clicked on
///
class SessionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> sessionDetails;

  SessionDetailsPage({this.sessionDetails});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text('Session Details'),
        ),
        body: ListView.builder(
          itemCount: sessionDetails.length,
          itemBuilder: (context, index) {
            final key = sessionDetails.keys.elementAt(index);
            final val = sessionDetails[key];
            return ListTile(
              title: Text('$key: $val'),
            );
          },
        ),
      ),
    );
  }
}