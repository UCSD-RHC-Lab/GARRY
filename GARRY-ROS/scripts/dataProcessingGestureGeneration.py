#!/usr/bin/env python2.7
import rospy

import os

from std_msgs.msg import String

from websocket_server import WebsocketServer
from socket import gethostname
from json import loads, dumps
from geometry_msgs.msg import Twist
import time

# For the gestures
gesture_state = "stop"
step_state = "Normal"
goal_val = 1.0

# initialize list to store received data
received_data = [0.0]

def calculate_control_command(value, goal):
  gain = 0.5
  control_command = gain * (goal - value)
  return control_command

def data_callback(data):
    # Split the received message by comma to separate individual values
    values = data.data.split(',')
    print(values)
    global gesture_state
    global step_state
    global goal_val
    global received_data

    global turn_right_cmd
    global frwd_cmd
    global backwrd_cmd
    global turn_left_cmd

    frwd_cmd = Twist()
    frwd_cmd.linear.x = 0.2
    backwrd_cmd = Twist()
    backwrd_cmd.linear.x = -0.2
    turn_left_cmd = Twist()
    turn_left_cmd.angular.z = 1.8
    turn_right_cmd = Twist()
    turn_right_cmd.angular.z = -1.8
    
    if len(values) == 1:
      print('This is session type: ', values[0])
      if values[0].lower() not in ['positive', 'negative', 'binary', 'explicit']:
          rospy.logwarn("Invalid data format received: %s", data.data)
      else:
        gesture_state = data.data
        rospy.loginfo('Gesture state is now: %s', gesture_state)
    elif len(values) == 2:
        try:
            value = float(values[0])
            goal = float(values[1])

            received_data.append(value)
            goal_val = goal
            # Calculate the control command based on the received value and goal
            control_command = calculate_control_command(value, goal)

            # Publish the control command as a Twist message
            twist_msg = Twist()
            twist_msg.linear.x = control_command
            twist_msg.angular.z = 1.0
            #print("This is the control command: %s", control_command)
            #cmd_vel_publisher.publish(twist_msg)
            #cmd_vel_pub.publish(twist_msg)
        except ValueError:
            rospy.logwarn("Invalid data received: %s", data.data)

def rcv_feedback_type(msg):
  print("received " + str(msg) + "!")

if __name__ == '__main__':
  rospy.init_node('dataProcessingGestureGeneration')

  # Subscribe to the /data topic
  data_sub = rospy.Subscriber('/data', String, data_callback)
  feedback_sub = rospy.Subscriber('/garry/feedback_type', String, rcv_feedback_type)
  print('I have subscribed to the data topic')
  #Publisher to the topic that the robot listens to
  cmd_vel_pub = rospy.Publisher('/mobile_base/commands/velocity', Twist, queue_size=10)

  rate = rospy.Rate(10) #set the publishing rate

  # Test to publish
  stop_cmd = Twist()

  while not rospy.is_shutdown():
    #rospy.loginfo('Gesture state is: %s', gesture_state)
    rate.sleep()

    # Set the duration in seconds for data collection
    duration = 5
    # Get the current time
    start_time = rospy.Time.now()

    while (rospy.Time.now() - start_time).to_sec() < duration:
      rospy.sleep(0.1)
  
    # Print the collected data
    average_val = 0
    if len(received_data) > 0:
      average_val = sum(received_data)/len(received_data)
    print('Collected data: ', received_data)
    print('And a goal value of: ', goal_val)
    print('And an average step value % of: ', average_val/goal_val)
    received_data = []

    if average_val/goal_val > 0.9:
      print('Since we are above 90%, we get a boost!')
      step_state = 'Great'
      turn_left_cmd.angular.z += 1.5
      turn_right_cmd.angular.z -= 1.5

    if gesture_state == "Positive":
      # Perform the predefined gesture (forward, stop, left, right, backward)
      cmd_vel_pub.publish(frwd_cmd)
      rospy.sleep(1.0)
      cmd_vel_pub.publish(stop_cmd)
      rospy.sleep(1.0)
      cmd_vel_pub.publish(turn_left_cmd)
      rospy.sleep(2.0)
      cmd_vel_pub.publish(turn_right_cmd)
      rospy.sleep(2.0)
      cmd_vel_pub.publish(backwrd_cmd)
      rospy.sleep(1.0)
      cmd_vel_pub.publish(stop_cmd)

      
    elif gesture_state == "Negative":
      # Perform the predefined gesture (spin left for a while, then spin right)
      #turn_left_cmd.angular.z = 2.8
      cmd_vel_pub.publish(turn_left_cmd)
      rospy.sleep(2.0)
      #turn_right_cmd.angular.z = -2.8
      cmd_vel_pub.publish(turn_right_cmd)
      rospy.sleep(2.0)
      cmd_vel_pub.publish(stop_cmd)

    elif gesture_state == "Binary":
      # Perform the predefined gesture (spin left, go forward, then spin right then go forwards)
      #turn_left_cmd.angular.z = 2.8
      cmd_vel_pub.publish(turn_left_cmd)
      rospy.sleep(4.0)
      cmd_vel_pub.publish(frwd_cmd)
      #turn_right_cmd.angular.z = -2.8
      cmd_vel_pub.publish(turn_right_cmd)
      cmd_vel_pub.publish(turn_right_cmd)
      rospy.sleep(4.0)
      cmd_vel_pub.publish(frwd_cmd)
      cmd_vel_pub.publish(turn_left_cmd)
      cmd_vel_pub.publish(stop_cmd)
    else:
      #cmd_vel_pub.publish(frwd_cmd)
      #rospy.sleep(0.5)
      cmd_vel_pub.publish(stop_cmd)
      #rospy.sleep(1.0)
      #cmd_vel_pub.publish(turn_left_cmd)
      #rospy.sleep(0.5)
      #cmd_vel_pub.publish(turn_right_cmd)
      #rospy.sleep(0.5)
      #cmd_vel_pub.publish(backwrd_cmd)
      #rospy.sleep(1.0)
      #cmd_vel_pub.publish(stop_cmd)
      #rate.sleep()
