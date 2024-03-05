import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:garryapp/globals/global_states.dart';

///
/// Code that deals with database operations
///

///Connects to the database (DB) and returns all sessions inside
Future<List<dynamic>> getSessions(int pid, String feedbackType) async {
  // build request
  Map<String, dynamic> queryParams = {
    'pid': pid.toString(),
    'feedback_type': feedbackType
  };
  final url = Uri.http('localhost:5000', 'sessions', queryParams);
  final request = http.Request('GET', url);

  // final response = await request.send();
  final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/sessions/$pid/$feedbackType'),
    );
  // final resString = await response.stream.bytesToString();
  List<dynamic> data = [[]];

  if (response.statusCode == 200) {
    // Map<String, dynamic> obj = jsonDecode(resString);
    // data = obj['data'];

    // clean up
    // data = data.where((element) => element[7] != null).toList();
    final jsonData = json.decode(response.body);
    data = jsonData['data'];

  }

  return data;
}

// Adds a session to the DB
Future<Response> addSession(dynamic data) async {
  // send the session information to the database then clear the dictionary
  final url = Uri.parse('http://localhost:5000/addsession');
  final response = await http.post(
    url,
    headers: {"content-type": "application/x-www-form-urlencoded"},
    body: data,
  );
  // Handle the response
  if (response.statusCode == 200) {
    print('Data sent successfully!');
  } else {
    print('Failed to send data.');
  }
  return response;
}

// Checks if the given PID exists in the DB
Future<bool> checkUserExists(String pid) async {
  final url = Uri.parse('http://localhost:5000/users/$pid');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    // A connection was made
    final jsonData = response.body; // Parse the response body
    var formatted = jsonData.replaceAll("'", "\"");
    formatted = formatted.replaceAll("(", "[");
    formatted = formatted.replaceAll(")", "]");
    print(jsonData);
    // print(jsonDecode(formatted)['data']);
    if (jsonDecode(formatted)['data'].length > 0) {
      // The pid is in the database
      var parsed = jsonDecode(formatted)['data'][0];
      var pid = parsed[0];
      var name = parsed[1];
      print('User $name exists at $pid');

      // Add the pid to the sessions data dictionary
      globalData['participant_id'] = pid.toString();

      return true;
    }
    else {
      print('User doesnt exist');
      return false;
    }
  }
  else {
    // The connection fails
    print('Connection could not be established');
    return false;
  }
}

// Creates a new user if the pid given does not exist in the DB
Future<void> createNewUser(String name) async {
  print('We need a new user then for this person: $name');
  final url = Uri.parse('http://localhost:5000/addusers');
  // final Map<String, String> testMap = {"content-type": "applicat/ion/x-www-form-urlencoded"};
  final response = await http.post(
    url,
    headers: {"content-type": "application/x-www-form-urlencoded"},
    body: {'name': name},
  );
  // final url2 = Uri.parse('http://localhost:5000/users/$pid');
  // final response2 = await http.get(url2);
  if (response.statusCode == 200) {
    final jsonData = response.body; // Parse the response body
    var parsed = jsonDecode(jsonData)['data'][0];
    var pid = parsed[0]; var name = parsed[1];
    // print('Newly created: $formatted');
    // connection created successfully
    print('PID: $pid');
    print('Name: $name');
    globalData['participant_id'] = pid.toString();
  } else {
    // Handle error
    print('Failed to create user');
  }
}