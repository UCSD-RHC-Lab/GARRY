#!/usr/bin/env python2.7

import rospy
from websocket_server import WebsocketServer
from std_msgs.msg import String


def publish_data_to_ros(data):
    rate = rospy.Rate(10)  # The publishing rate
    message = String()  # Create an instance of String message
    message.data = data  # Set the data field
    pub.publish(message)
    
# Define a callback function to handle incoming Websocket connections and messages
def on_message(client, server, message):
    print("Received message from {} : {}".format(client['address'], message))
    publish_data_to_ros(message)

def main():
    rospy.init_node('externalConnection', anonymous=True)
    global pub
    pub = rospy.Publisher('data', String, queue_size=10)
    # Set up the WebSocket server
    server = WebsocketServer(8081, host='0.0.0.0')
    server.set_fn_message_received(on_message)

    # Start the WebSocket server
    server.run_forever()

if __name__ == '__main__':
    main()
