# GARRY Project 🚶‍♂️🧠🤖

**GA**it **R**ehabilitation **R**obotic s**Y**stem (GARRY) for patient ambulatory redevelopment

GARRY is a novel robotic system that provides interactive feedback during locomotor training. It promotes engagement by
gamifying the rehabilitation process, offering a fun means for the user to meet their rehabilitation goals defined and set by physical therapists and clinicians.


![GARRY in use](Screenshots/GARRY_in_use.jpg)


For details on this project and more context, please read our [HRI 2024 paper](https://cseweb.ucsd.edu/~lriek/papers/bestmann-HRI24.pdf). 

We ask that you cite our paper if you use this repository - thanks! 

<code>Benjamin O. Bestmann, Alex Chow, Alyssa Kubota, and Laurel D. Riek. 2024. GARRY: The Gait Rehabilitation Robotic System. In Proceedings of the 2024 ACM/IEEE International Conference on Human-Robot Interaction (HRI ’24), March 11–14, 2024, Boulder, CO, USA. ACM, New York, NY, USA, 5 pages. https://doi.org/10.1145/3610977.3637475
</code>

**Table of Contents:**

- [GARRY Project 🚶‍♂️🧠🤖](#garry-project-️)
  - [Introduction:](#introduction)
    - [Application Diagram](#application-diagram)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
      - [Hardware](#hardware)
      - [Software](#software)
    - [Code and Tools Installation](#code-and-tools-installation)
      - [Python Flask Server](#python-flask-server)
      - [MATLAB](#matlab)
      - [Flutter](#flutter)
      - [VS Code/extensions](#vs-codeextensions)
      - [ROS/Turtlebot/Ubuntu](#rosturtlebotubuntu)
  - [Getting Started](#getting-started)
    - [Python Flask Server](#python-flask-server-1)
    - [ROS/Turtlebot](#rosturtlebot)
    - [Flutter](#flutter-1)
    - [MATLAB](#matlab-1)
  - [Usage](#usage)
      - [GARRY-Flutter](#garry-flutter)
        - [Application Structure Overview](#application-structure-overview)
        - [Main Page](#main-page)
        - [Sessions Page](#sessions-page)
        - [Feedback Selection Page](#feedback-selection-page)
        - [Sample Feedback Session](#sample-feedback-session)
        - [Summary Page](#summary-page)
      - [MATLAB](#matlab-2)
      - [ROS](#ros)
    - [Future Additions](#future-additions)

## Introduction:
Welcome to the GARRY project, developed by the UCSD Healthcare Robotics lab. 
Our project aims to improve motor rehabilitation outcomes for patients with 
post-stroke hemiparesis by providing a novel robot-based gait training system.

This project is a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For general help, we suggest looking at the 
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Application Diagram ###
![Application Diagram](Screenshots/Architecture_diagram.png)

The data collected from participants by UC Davis researchers consists of numeric measurements of angle, 
frequency, and power generated by the body using concentric muscle activity (iA2). 
This is used to characterize the full gait cycle of a leg from heel strike 
(to start the step) to heel strike (to end it).

To envision the motion capture process and early feedback design here is an early visualization (click the screenshot below to watch the demo video):

[![Prototype Data Collection](https://img.youtube.com/vi/5qx3AhJqQp0/0.jpg)](https://www.youtube.com/watch?v=5qx3AhJqQp0)

In the video, the participant is in the positive feedback mode. For every step they take, the plus will light up if they reach their performance goal. If not, it will not light up.

Our app takes a similar approach. As the participant proceeds in the rehabilitation session, their data is downloaded and streamed into our app where they can view their session progress in real-time. They are also given different kinds of animated feedback on the quality of their step in relation to the predetermined goal metrics.

This data is collected by UC Davis researchers and sent to us for use in the system. They work with people recovering from stroke, which serves as the basis of the work. Our
application uses this data to provide personalized gait training and real-time 
feedback to people during the rehabilitation process. 

We developed the application using Android Studio ver 1.0.0+1 and Visual Studio ver 17.5 on 
Windows 10/11, and used Google Chrome ver 110.0.5481.178 and the Google Nexus 7 
display to emulate the program.


To set up the GARRY project on your Windows 10 laptop, please follow the steps below:
## Installation
### Prerequisites
#### Hardware
- A Windows 10 or 11 computer/laptop
- Turtlebot 2
- An Ubuntu version 18.04 laptop/computer connected to the Turtlebot 2, running ROS Melodic

#### Software
This system can be set up with multiple devices as long as all are on the same network.

On a Windows laptop/computer:
- MATLAB R2023a
- Python >=3.8.10
    - Flask
    - flask-cors
- Visual Studio Code (VS Code)
    - Extensions:
        - Flutter >= 3.74.0
        - Dart >= 3.74.0
- Flutter SDK >= 3.7.12
- Dart SDK >= 2.19.6 (comes with Flutter SDK)

On the Ubuntu laptop/computer:
- Python 2.7
- rosbridge_suite

<!-- * Install Android Studio V 1.0.0+1 and Visual Studio V 17.5 on your device.
* Clone the GARRY-Flutter repository to your local device.
* Open the GARRY project in Android Studio and build the application from the GARRY-Flutter folder.
* In the Flutter Device Selection menu in the top, center-left, choose your simulation device (Web browsers preferred as Virtual emulators tend to lack storage space).
* Get needed dependencies
* Ensure you are up to date with the main branch by calling a Git pull request -->

### Code and Tools Installation

#### Python Flask Server
The folder "GARRY-Server" should be placed on the Windows computer/laptop.
1. Install any Python version greater than or equal to 3.8.10.
2. Open a terminal, navigate to our GARRY-Server directory, and run `pip install -r requirements.txt` to install Flask and flask-cors dependencies.


#### MATLAB
For our MATLAB server, we utilized [jebej's MatlabWebSocket library](https://github.com/jebej/MatlabWebSocket). The folder "GARRY-MatlabWebsocket" should be placed on the Windows computer/laptop. Follow the below steps to set up.

1. There is "jar" subfolder inside the "GARRY-MatlabWebsocket" folder. Locate "matlab-websocket-1.6.jar" inside the "jar" folder and save the pathway to that jar file.
2. In the MATLAB command window, run `edit(fullfile(prefdir,'javaclasspath.txt'))`. If it tells you that the file does not exist and asks you if you want to create it, click "Yes".
3. This should open up the code editor for `javaclasspath.txt`. In the text file, type in the path to the jar file you located in step 1 (pure path, without quotes or anything). For example, if your jar file path is `C:\MatlabWebSocket\jar\matlab-websocket-1.6.jar`, then write that in the text file.
4. Save the file and restart MATLAB.
5. In the command window, type in `javaclasspath` and verify that the path to your jar file is listed.
6. At the top of MATLAB, go to Home -> Environment -> Set Path.
7. Click on "Add Folder" and add the `src` subfolder under the "GARRY-MatlabWebsocket" folder. Then click "Save". If it asks you if you want to save it to another location, hit "Yes". Lastly, hit "Close".

#### Flutter
The folder "GARRY-Flutter" should be placed on the Windows computer/laptop.
1. Download the Flutter SDK any version >= 3.7.12 from [here](https://urldefense.com/v3/__https://docs.flutter.dev/release/archive?tab=windows__;!!Mih3wA!FPQOotNdzvKmibdlCGmC0sRnAx04wmr_9Q5h-U32R1s7nbmaKpWulAA1Tk9utBAhqtewc5KVmnAE2W3g$ ) (under the Stable Channel scroll list). You can simply click on the version number itself in the first column. It will likely be a zip file.
2. Once downloaded, move it to a folder where you can find it easily.
3. Extract the zip into a folder, and ensure that it has a subfolder inside named `flutter`. Note where this subfolder is located; you will need to know this path when setting up VS Code below.

#### VS Code/extensions
The VS Code editor we discuss here will refer to installation on the Windows laptop/computer. You can download VS Code [here](https://code.visualstudio.com/download).
1. Install the Flutter and Dart extensions in VS Code.
2. Open up the "GARRY-Flutter" folder.
3. If prompted, hit "Locate SDK" and locate the `bin` subfolder under Flutter SDK/folder you downloaded and extracted.
4. If prompted, "Run `pub get`".

#### ROS/Turtlebot/Ubuntu
The following instructions are for the Turtlebot/robot that uses ROS, or a laptop/computer connected to one.
1. Move our `GARRY-ROS` into the `src` subfolder in your catkin workspace (most commonly, this is known as `catkin_ws`).
2. Run `cd ..` back to your root `catkin_ws` directory and run `catkin_make`.
3. Next, run `source ~/catkin_ws/devel/setup.bash`.
4. Edit your bashrc file to set the following environment variables permanently by ensuring the following lines are all present/uncommented. You can do this by running `sudo vim ~/.bashrc` for example. Note: It might be a good idea to back up the original values before you modify each of the following:
    1. `export ROS_HOSTNAME=<your IP Address>`
       * Replace `<your IP address>` with the IP address of the Turtlebot/robot laptop. `ipconfig` can help. Use `ifconfig` to get new IP Address upon rebooting computer.
    2. `export ROS_MASTER_URI=http://${ROS_HOSTNAME}:11311`
       * Using the previously declared variable `ROS_HOSTNAME` will reduce the number of changes made.
    3. `source ~/catkin_ws/devel/setup.bash`
       * This will make sure all ROS packages, including `garry_ros`, can be found by the system.
5. Now when you create new tabs/windows, the environment variables should stay consistent (no need to re-do steps 2-4).
6. Navigate to the `scripts` folder then run `chmod +x *.py` to make all of the Python files executable with the `x` permission.
7. Finally, to install Rosbridge, run `sudo apt-get install ros-<rosdistro>-rosbridge-server`.
   1. Next, run `source ~/catkin_ws/devel/setup.bash`.
   2. To launch the websocket server, run `roslaunch rosbridge_server rosbridge_websocket.launch`.

You can now get started looking through the code!

## Getting Started
**IMPORTANT:** Before getting started, please make sure that all devices are on the same network. We will be using `localhost`.

### Python Flask Server
Our Flask server uses the port 5000.
1. Open a terminal and navigate to the GARRY-Server folder.
2. Run `python -m flask run -p 5000` to begin the flask server.

### ROS/Turtlebot
1. Turn on your Turtlebot.
2. On the laptop connected to the Turtlebot, open a terminal.
3. Run `source ~/<your catkin workspace name>/devel/setup.bash`, replacing `<your catkin workspace name>` with the appropriate title (it will most likely be `catkin_ws`).
4. Run `ifconfig` and take note of the IP address of the network the device is on.
5. In another terminal, navigate to the `garry_ros` package folder by running `roscd garry_ros`. If it says not found, follow step 3 again and come back.
6. Run `startup.py` to both bring up the Turtlebot and to get it set up with the GARRY system.
7. Note: if step 6 doesn't work, you may have an system that does not run our Python script correctly. The idea of this was to reduce the amount of manual setup work--nothing huge. You just have to do the following manually:
   - Run `roscore`.
   - In another terminal, run `roslaunch garry_ros turtlebot.launch`
   - In another terminal, run `roslaunch garry_ros startup.launch`
   - If you're still having trouble, please follow the launch commands in the launch files respectively and manually run those commands.
8. Spin up the rosbridge server by running `roslaunch rosbridge_server rosbridge_websockets.launch` so MATLAB can communicate with the robot.

### MATLAB
1. In the command window, run `server = GarryMatlabServer(4000, <robot IP address>)`, replacing `<robot IP address>` with the robot's IP address (as a string).
2. If you wish to stop the server at any point, type in `server.stop`. More commands can be found in jebej's GitHub repo as linked above.
  
### Flutter
1. In VS Code, open the folder "GARRY-Flutter"
2. Go to the folder "lib" -> "globals" -> "global_states.dart" and ensure that `"rosWebSocketAddr"` maps to the IP address you obtained from the previous ROS step 4.
3. On the bottom right of VS Code there will be text saying "Chrome(web-javascript)" or "Edge(web-javascript)". You can choose which device or platform you want to run it on.
4. Open `main.dart` if you haven't already. Then, to run the app, do one of the following:
  * On the top right of VS Code, you should see a "play" button, with or without a bug: You can click on the dropdown menu and hit "Run without debugging."
  * Another way is to go to `main.dart` in VS Code, find the `main` method, and above it should be a "Run" button alongside "Debug" and others. If you don't have this, it's likely that either:
    1. You don't have the Flutter extension installed correctly. Be sure to restart VS Code.
    2. You're not in a folder where you can access the root folder of the app `GARRY-Flutter`. You can do so by going to File -> Open Folder, and choose either GARRY-Flutter or any of its parent directories.
  * Alternatively, instead of using VS Code in step 4, you could also open up a terminal, navigate to `GARRY-Flutter/lib`, and enter `flutter run main.dart`.



## Usage 
The following breaks down the important elements necessary to use each aspect of our system.


#### GARRY-Flutter

Currently, the data we have been using for simulation has come from a shared MS drive with UC Davis
(ask for permission for access), so you must currently **download** the data you would like to work with
and put it in your **assets** folder.


##### Application Structure Overview #####

The `anim` directory contains any animation related files:
* `ease_out_back_scaled.dart`: Defines a cubic animation curve for Scoreboard animation.

The `api` directory contains any API related files:
* `api.dart`: All API calls to the GARRY-Server in order to retrieve and update sessions and participant data.
In the future, we plan to separate this into two files: `sessions_api.dart` and `participants_api.dart`.

The `backend` directory contains any backend classes that represent data objects:
* `score_entry.dart`: A PODO (plain old Dart object) for each score entry on the scoreboard, containing the date (string) and the score (int).

The `constants` directory contains any constants used throughout the app:
* `confetti_colors.dart`: The set colors of the confetti associated with regular and binary confetti controllers, differing by color selection.
* `strings.dart`: Any string constants used by the app inspired by Android app structure. Currently not well-integrated.

The `globals` directory contains dynamic global states:
* `global_states`: Defines any dynamic global states, such as the network configurations and global app data (planning to switch to use provider pattern).

The `pages` directory contains all of the pages within the app:
* The `base_feedback_page` directory contains files related to the base feedback page which the various feedback pages will inherit from. Contains the progressBar, coin display, pointDisplay, percentageDisplay, endSessionButton, textFeedback and pointsFeedback widgets that appear on the feedback pages.
  * `base_feedback_page.dart`: An abstracted base version of every feedback page which can be extended to cater to each specific feedback type.
  * `feedback_page_widgets.dart`: Contains the different widgets necessary to build the feedback page.
  * `file_selection_page.dart`: Contains the file selection page that allows the user to choose which mock data source file they want to work with.
* The `feedback_pages` directory contains all of the positive, negative, binary, and explicit feedback pages. More details will be described below. 
* The `main_pages` directory contains the main pages aside from the landing page and the feedback pages:
  * `feedback_selection_page.dart`: The page that allows users to select the type of feedback they want this session to run with.
  * `sessions_page`: The page for users to choose to view past sessions or to start a new session.
* The `summary_pages` directory contains the pages that show a summary of session information.
  * `past_session_page.dart`: The page where users can view the past sessions of a participant.
  * `summary_page.dart`: The leaderboard page that shows the rank, date, and score of each session a participant has partaken in.

The `providers` directory contains any files related to the provider pattern:
* `user_model.dart`: A UserModel provider that extends a ChangeNotifier, contains the setPID and setName functions, and allows the properties of a user to be carried between pages and referenced globally within the app.

The `ui` directory contains any files related to UI. Currently only contains the file for responsively scaling the app on different screens:
* `dimensions.dart`: Contains enums (fixed set of named values) for the different feedback page components, set values for the dimensions of each of those pages and a computeSize variable to calculate the remaining dimensions needed.

The `websockets` directory contains any files that makes connections with and communicates with other hosts via websockets:
* `roscomm.dart`: A wrapper class for any communication related classes with ROS.

The `widgets` directory contains front end widgets:
* `navigation.dart`: A Cupertino Navigation Bar and the nextPageButton Widget along with their styles.
* `progress_chart.dart`: The Progress Chart widget that creates the line chart during each session. Contains its height (double), dataPoints (FLSpot), colors (Color), and threshold Line (FLSpot).
* `score_card.dart`: The ScoreCard class that contains its key, rank, date, score, newIndex, reportHeight and animations.
* `scoreboard.dart`: The self-containing, animated, scrollable widget that displays session scores in descending order.
* `selection_menu.dart`: The SelectionMenu widget which contains its text, slectionIndex and style, and the SelectionMenuOption class which contains its index, fontSize, text and other widgets.
* `text_labels.dart`: Any text labels or prompt widgets go here.

The rest of the feedback pages like `positive_feedback.dart` will be described in more detail below.

##### Main Page #####
<p align="center">
  <img src="Screenshots/Main_Page.jpg" alt="Main Page" />
</p>

The app begins at the main landing page, because we are using flutter, every 
page is itself a widget and can be constructed with a lot of customizable 
aspects. Ours consists of a title at the top and a textfield that allows the 
patient to enter their ID and progress into the app by clicking the **“next”** 
button on the bottom right. The textfield saves the input ID and forwards it to 
the next page.

If the id provided is not available in the database, the user is prompted to create
and entry for that id. With this popup appearing:

<p align="center">
  <img src="Screenshots/New_User.png" alt="Create new user" />
</p>

The class GarryApp is the main app for this page, but within it, we return a 
CupertinoApp and set its home variable to a custom stateful widget called `Login`. It contains a build method that forms the basis of the page.
When the page launches, the page is built with flexible dimensions, 
a navigation bar and a stack of widgets with sized boxes and a Text Field. This 
field has a controller which clears the field when the 'X' is pressed. When the 
**"next"** button is clicked the navigator pushes the participant ID to the next 
page.

##### Sessions Page #####
<p align="center">
  <img src="Screenshots/Session_Page.jpg" alt="Session Page" />
</p>

This leads the user to the Sessions page, which gives the 
user the option to start a new session or view previous sessions. The **“Start New Session”** 
button sends the user to a new page where they can pick the type of 
session (feedback) they want to commence with. 

This page receives data from the TextController in the main page and uses it
to build itself. The **“Start New Session”** button is a custom widget derived from
a CupertinoButton that has a navigator attached that pushes the user to the next
page. 

<p align="center">
  <img src="Screenshots/Past_Sessions_Base.png" alt="Past Sessions Base Page" />
</p>

The **“View previous sessions”** button sends users to a page that 
includes the information stored from each of their previous sessions, separated
by feedback type presented in card form. The base page only contains the bar that
allows you to specify feedback type.

<p align="center">
  <img src="Screenshots/Past_Sessions_Pos.png" alt="Positive Past Sessions" />
</p>

By clicking on any of the feedback types in the bar, a list of cards is built drawing
directly from the database with each card having some important details from its 
corresponding session.

<p align="center">
  <img src="Screenshots/Past_Session_Details.png" alt="Example Session Details" />
</p>

Clicking on any of these cards will open up a new page with all the information from the session.


##### Feedback Selection Page #####
<p align="center">
  <img src="Screenshots/Selection_Page.jpg" alt="Selection Page" />
</p>

On the Feedback Selection page, the user gets a choice of which type of session they want
to participate in with each different session listed in a custom widget designed
to log the user’s choice so that when the “next” button at the bottom right is
clicked, the user is sent to the page of the relevant session. In the future, it
might make sense to store the session type at this point so it can be sent to
the session database.

Depending on the choice of session, the user is sent to the relevant starting 
page where the session can begin and they can see multiple 
representations of their progress: 


##### Sample Feedback Session #####
<p align="center">
  <img src="Screenshots/Pos_Feedback.jpg" alt="Example Positive Session" />
</p>

The custom thermometer widget that converts the iA2 values from the dataset into percentages are displayed as the height of the liquid in the thermometer. Following is a space where text feedback is displayed based on the value of the currently converted 
iA2, and the continuous line chart at the bottom of the page which displays each
percentage on the chart with a horizontal indicator at the goal value 
(A perfect 100% step) for the entire session. There is also point counter at the
top right of the screen that displays scores based on the feedback parameters.


##### Summary Page #####
<p align="center">
  <img src="Screenshots/Score_board_updated.png" alt="Summary Page" />
</p>

Finally, after a session has been completed, the user can choose to end the 
session and be directed to a summary page which displays the accrued points from
that session in comparison with the other scores from that pid and ranks them on 
a leaderboard setup.



#### MATLAB



As the raw data is currently being collected by UC Davis via MATLAB, we used websockets to directly send that data locally from the MATLAB IDE to the application.
 
<!-- The current version of the app uses a websocket that streams the data from collection into the app. In the current setup, when a dataset is chosen in app, it sends a unique signal to the websocket and in turn it builds the session using the data from the corresponding dataset. This system will be further configured to live data. -->

GARRY utilizes MATLAB to process raw sensor data in real-time and simulate sessions for testing. The MATLAB code sends real-time, correctly formatted data from users to both our tablet application and the robot via websockets.

Our implementation streams preexisting session data provided by our clinical collaborators into the app and the robot. This data is easily replaceable with real-time data received from sensors.
To understand how we built a websocket server inside MATLAB to send the data see [the MatlabWebsocket documentation here.](https://github.com/UCSD-RHC-Lab/M3X-MatlabWebsocket) (Again, this is based on jebej's implementation as mentioned above).

Currently, once the researcher starts a session through the app, it sends a message to the MATLAB program to signal that the session is starting. 

Matlab then begins streaming the user's step data and threshold to the app, which updates and animates the screen based on the user’s performance.

The Matlab Websocket also sends data to the ROS Nodes we integrated into our system.

#### ROS

Our ROS section of the code was implemented to have greater control of the robot's actions in relation to a user's performance during a session. To this end, our ROS system receives data from our Matlab websocket through specific topics, translates that data into the right format, and moves the robot accordingly.

The ROS nodes are facilitated through ROS topics.

The `/data` topic receives the user's step data and goal value for the session from Matlab.

The `/feedback_type` topic receives the chosen feedback mode of the session from the Flutter app.

The `/good_step` topic receives a boolean value representing whether a good step has been achieved every 5 seconds.


 Our ROS system is characterized by 2 nodes:
* `The Data Processing Node (DPN)`: Subscribes to `/feedback_type` and `/data` topics, determines if
the user has taken a “good step” from the A2 and goal values, and sends the result to the `/good_step` topic.

* `The Gesture Generation Node (GGN)`: Subscribes to the `/feedback_type` and `/good_step` topics to direct robot movement. If the robot receives a “true” message from `/good_step` and that period of time has passed since the start of the last gesture, it will perform a new gesture.


This system allows us to take the A2 and goals data generated from the Matlab section and ensure whatever robot compoenent of our system can utilize the data and respond appropriately.


### Future Additions ###

- We aim to streamline the application and include some more functionality for 
doctors or whoever would run each session, such as: 
    - The ability to change the threshold value mid-session 
    - The ability to change the type of the linechart from discrete 
points to continuous
    - The ability to monitor changes/trends between multiple sessions.
