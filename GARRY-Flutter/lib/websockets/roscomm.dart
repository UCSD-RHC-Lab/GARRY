import 'package:roslibdart/roslibdart.dart';

class RosPublisher {
  Ros ros;
  Topic topic;

  RosPublisher(String rosWsUrl, String topicName, String msgType) {
    ros = Ros(url: rosWsUrl);
    topic = Topic(ros: ros, name: topicName, type: msgType, reconnectOnClose: true, queueLength: 10, queueSize: 10);
  }

  void connect() {
    ros.connect();
  }

  void publish(dynamic msg) async {
    Map<String, dynamic> json = {"data": msg.toString()};
    await topic.publish(json);
  }
}