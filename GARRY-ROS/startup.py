import subprocess
import time

subprocess.Popen('ifconfig', shell=True)
p = subprocess.call(['gnome-terminal', '-e', 'roscore'])
time.sleep(5)
subprocess.call(['gnome-terminal', '-e', 'roslaunch garry_ros turtlebot.launch'])
time.sleep(5)
subprocess.call(['gnome-terminal', '-e', 'roslaunch garry_ros startup.launch'])
