import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/globals/global_states.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/components/navigation.dart';

///
/// Past Session Page:
/// Allows users or clinicians to view previous data generated during the sessions separated by session type 
/// and presented on cards.
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

  void _colorCallback() {
    setState(() {
      buttonBackground = Color(0xFF246CFF);
    });
  }
  List<CardData> cards = [];

  // Creates cards which include important information about each session in the database with 
  //scores and dates of the session presented when their corresponding session type is clicked

  Future<void> fetchRecentValues(String feedbackType) async {
    // Fetch the recent values based on the provided PID
    var participant_id = globalData['participant_id'];
    // var feedback_type = 'Positive'; //globalData['feedback_type'];
    // print('Now to get the sessions for User $participant_id with feedback: $feedbackType');
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/sessions/$participant_id/$feedbackType'),
    );
    // print('http://127.0.0.1:5000/sessions/$participant_id/$feedbackType');

    if (response.statusCode == 200) {
      // Get the data from the database (DB)
      final jsonData = json.decode(response.body);
      sessionData = jsonData['data'];

      setState(() {
        cards = List.generate(sessionData.length, (index) {
          var current = sessionData[index];
          // year = index-2, month = index-3, day = index-4, score = index-7
          if (current[2] == null) { // if there is no date present in the DB entry
            print('Not a valid date');
            if (current[7] == null) {
              print('Or a valid score');
            }
            current[2] = 2023; current[3] = 8; current[4] = 15; // dummy date, can be changed
            var date = '${current[3]}/${current[4]}/${current[2]}';
            return CardData(
            id: index + 1,
            date: date,
            score: current[7] != null ? current[7]: 0.0, // dummy score if none is provided
          );
          }
          var date = '${current[3]}/${current[4]}/${current[2]}';
          return CardData(
            id: index + 1,
            date: date,
            score: current[7] != null ? current[7]: 0.0,
          );
        });
      });
      
    } else {
      // Handle error
      print('Failed to fetch recent values');
    }
  }


 @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: navBar('Past Sessions'),
      child: Material(
        child: ListView(
          children: <Widget>[
            // Top bar with feedback types
            HorizontalList(
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
                    // Get the session data for the tapped card
                    var sessionDataForCard = sessionData[index];

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
                      'Path to Dataset': sessionData[index][10],
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
            // TempCard(),
          ],
        ),
      ),
      backgroundColor: Colors.amber[400],
    );
  }
  
}

// The card tiles instances that are displayed when a session type is clicked
class CardData{
  final int id;
  final String date;
  final double score;
  
  CardData({this.id, this.date, this.score});
}


class HorizontalList extends StatelessWidget {
  final int selectedIndex;
  final List<String> buttonLabels;
  final Function(int) onPressed;

  HorizontalList({this.selectedIndex, this.buttonLabels, this.onPressed});

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