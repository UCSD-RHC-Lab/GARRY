#!/usr/bin/env python2.7
import rospy

import os

from std_msgs.msg import String, Bool

from geometry_msgs.msg import Twist
import time

class GestureGenerator:
    def __init__(self):
        self.gesture_state = "Stop"
        self.step_state = "Normal"
        self.goal_val = 1.0
        self.should_perform_gesture = False
        self.stop_cmd = self._init_stop_cmd()
        self.frwd_cmd = self._init_frwd_cmd()
        self.backwrd_cmd = self._init_bwd_cmd()
        self.turn_left_cmd = self._init_left_cmd()
        self.turn_right_cmd = self._init_right_cmd()
        self.cmd_vel_pub = rospy.Publisher('/mobile_base/commands/velocity', Twist, queue_size=10) # Publisher to the topic that the robot listens to

    def _init_stop_cmd(self):
        stop_cmd = Twist()
        return stop_cmd
    
    def _init_frwd_cmd(self):
        frwd_cmd = Twist()
        frwd_cmd.linear.x = 0.2
        return frwd_cmd

    def _init_bwd_cmd(self):
        bwd_cmd = Twist()
        bwd_cmd.linear.x = -0.2
        return bwd_cmd

    def _init_right_cmd(self):
        right_cmd = Twist()
        right_cmd.angular.z = -1.8
        return right_cmd

    def _init_left_cmd(self):
        left_cmd = Twist()
        left_cmd.angular.z = 1.8
        return left_cmd

    def rcv_good_step(self, msg):
        self.should_perform_gesture = msg.data

    def rcv_feedback_type(self, msg): #This is the code that gets run on every value that is received
        if msg.data.lower() not in ['positive', 'negative', 'binary', 'explicit']:
            rospy.logwarn("Invalid data format received: %s", msg.data)
        else:
            self.gesture_state = msg.data
            rospy.loginfo('Gesture state is now: %s', self.gesture_state)
        
    def perform_gesture(self):
        if self.gesture_state == 'Positive':
            self.positive_gesture()
        elif self.gesture_state == "Negative":
            self.negative_gesture()
        elif self.gesture_state == "Binary":
            self.binary_gesture()
        
    def positive_gesture(self):
        # Perform the predefined gesture (forward, stop, left, right, backward)
        self.cmd_vel_pub.publish(self.frwd_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.stop_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.turn_left_cmd)
        rospy.sleep(2.0)
        self.cmd_vel_pub.publish(self.turn_right_cmd)
        rospy.sleep(2.0)
        self.cmd_vel_pub.publish(self.backwrd_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.stop_cmd)

    def negative_gesture(self):
        # Perform the predefined gesture (spin left for a while, then spin right)
        self.cmd_vel_pub.publish(self.turn_left_cmd)
        rospy.sleep(2.0)
        self.cmd_vel_pub.publish(self.turn_right_cmd)
        rospy.sleep(2.0)
        self.cmd_vel_pub.publish(self.stop_cmd)

    def binary_gesture(self):
        # Perform the predefined gesture (spin left, go forward, then spin right then go forwards)
        self.cmd_vel_pub.publish(self.turn_left_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.frwd_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.turn_right_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.turn_right_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.frwd_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.turn_left_cmd)
        rospy.sleep(1.0)
        self.cmd_vel_pub.publish(self.stop_cmd)


if __name__ == '__main__':
    rospy.init_node('gesture_generation')
    ggn = GestureGenerator()

    # Subscribe to the /data topic
    good_step_sub = rospy.Subscriber('/garry/good_step', Bool, ggn.rcv_good_step)
    feedback_sub = rospy.Subscriber('/garry/feedback_type', String, ggn.rcv_feedback_type)

    rate = rospy.Rate(10) # set the publishing rate
    # Set the duration in seconds for data collection
    duration = 5

    while not rospy.is_shutdown():
        rate.sleep()

        # Get the current time
        start_time = rospy.Time.now()

        # wait duration seconds before performing another gesture
        while (rospy.Time.now() - start_time).to_sec() < duration:
            rospy.sleep(0.1)

        # as long as the robot shouldn't perform a gesture, we keep checking
        while not ggn.should_perform_gesture:
            rospy.sleep(0.1)
            
        ggn.perform_gesture()
