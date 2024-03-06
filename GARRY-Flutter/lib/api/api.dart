///
/// Contains API calls that makes requests to the GARRY server for database inquiries about the
/// participant or session data.
///
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:garryapp/globals/global_states.dart';

/// 
/// Connects to the database and returns all sessions.
/// 
Future<List<dynamic>> getSessions(int pid, String feedbackType) async {
  final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/sessions/$pid/$feedbackType'),
    );
  List<dynamic> data = [[]];

  if (response.statusCode != 200) {
    print("Failed to fetch sessions data.");
  }
  
  final jsonData = json.decode(response.body);
  data = jsonData['data'];

  return data;
}

///
/// Adds a session to the database.
/// 
Future<Response> addSession(dynamic data) async {
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

///
/// Checks if the given PID exists in the DB
/// 
Future<bool> checkUserExists(String pid) async {
  final url = Uri.parse('http://localhost:5000/users/$pid');
  final response = await http.get(url);

  // Connection cannot be established
  if (response.statusCode != 200) {
    print('Connection could not be established');
    return false;
  }

  // Clean up data
  final jsonData = response.body; // Parse the response body
  var formatted = jsonData.replaceAll("'", "\"");
  formatted = formatted.replaceAll("(", "[");
  formatted = formatted.replaceAll(")", "]");
  
  // User does not exist
  if (jsonDecode(formatted)['data'].length <= 0) {
    print('User doesnt exist');
    return false;
  }

  // The pid is in the database
  var parsed = jsonDecode(formatted)['data'][0];
  var parsedPid = parsed[0];
  var parsedName = parsed[1];

  // Add the pid to the sessions data dictionary
  globalData['participant_id'] = parsedPid.toString();  // Set participant id state

  return true;
}

/// 
/// Creates a new user if the given [name] does not exist in the database.
/// 
Future<void> createNewUser(String name) async {
  final url = Uri.parse('http://localhost:5000/addusers');
  final response = await http.post(
    url,
    headers: {"content-type": "application/x-www-form-urlencoded"},
    body: {'name': name},
  );

  // Handle error
  if (response.statusCode != 200) {
    print('Failed to create user');
  }

  final jsonData = response.body; // Parse the response body
  var parsed = jsonDecode(jsonData)['data'][0];
  var parsedPid = parsed[0];
  var parsedName = parsed[1];

  globalData['participant_id'] = parsedPid.toString();  // Set participant id state
}