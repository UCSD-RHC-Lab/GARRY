///
/// Defines global constants and data.
/// Includes the network configuration information and the global data that Flutter needs.
/// Planning to merge the constants and use the Provider pattern to store global app states.
///

///
/// Network configurations.
///
final Map<String, dynamic> networkConfigs = {
  "serverAddr": "http://127.0.0.1:5000",
  "websocketAddr": "ws://localhost:4000",
  "rosWebSocketAddr": 'ws://100.84.30.80:9090'
};

///
/// Global app states - include participant ID, session data, etc.
///
Map<String, dynamic> globalData = {};