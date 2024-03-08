#!/usr/bin/env python2.7
import rospy

from std_msgs.msg import String, Bool
from garry_ros.msg import UserData

class DataProcessor:
    def __init__(self):
        self.feedback_type = "Positive"
        self.received_data = []
        self.goal_val = 0.9 # default to 0.9 to avoid division by 0
        self.average_val = 0
        self.goal_threshold = 0.9
        self.good_step_pub = rospy.Publisher('/garry/good_step', Bool, queue_size=10)
        self.good_step_msg = Bool()

    def calc_avg_val(self):
        average_val = 0
        if len(self.received_data) > 0:
            average_val = sum(self.received_data) / len(self.received_data)
            self.received_data = []

        self.average_val = average_val
        return average_val
    
    def handle_data(self, data):
        a2value, goal = data.a2, data goal
        self.update_data(a2value)
        self.update_goal(goal)

    def handle_feedback_type(self, data):
        self.set_feedback_type(data)

    def calc_good_step(self):
        self.good_step_msg.data = self.average_val / self.goal_val > self.goal_threshold

    def publish_good_step(self):
        # don't send good_step if in negative or explicit feedback type
        if self.feedback_type in ["Negative", "Explicit"]: return
        self.calc_avg_val()
        self.calc_good_step()
        self.good_step_pub.publish(self.good_step_msg)

    def set_feedback_type(self, data):
        if data in ["Positive", "Negative", "Binary", "Explicit"]:
            self.feedback_type = data

    def update_data(self, data):
        self.received_data.append(data)

    def update_goal(self, goal):
        self.goal_val = goal

    
if __name__ == "__main__":
    rospy.init_node('data_processing')
    dpn = DataProcessor()

    # Subscribers and publishers
    data_sub = rospy.Subscriber('/data', UserData, dpn.handle_data)
    feedback_type_sub = rospy.Subscriber('/feedback_type', String, dpn.handle_feedback_type)

    rate = rospy.Rate(10) # set the publishing rate
    # Set the duration in seconds for data collection
    duration = 5

    while not rospy.is_shutdown():
        rate.sleep()

        # Get the current time
        start_time = rospy.Time.now()

        # wait for duration (5) seconds
        while (rospy.Time.now() - start_time).to_sec() < duration:
            rospy.sleep(0.1)

        # determine average and send good step (True or False) to ggn
        dpn.publish_good_step()
    
