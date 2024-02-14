from flask import Flask
from flask_cors import CORS
from sqliteHelper import sqliteHelper
from flask import request
from flask import json

app = Flask(__name__)
CORS(app)  # Initialize CORS extension
db_path = "data.db"
db = sqliteHelper(db_path)

# Call the create_tables method to create the necessary tables
db.create_tables()


@app.route("/")
def index():
    '''
    Retrieves all participants as default behavior.
    '''
    obj = db.retrieve_all("participants")
    return obj

# Mirroring this for the sessions DB
# @app.route("/s")
# def sessionIndex():
#     '''
#     Retrieves all participants as default behavior.
#     '''
#     obj = my_db.retrieve_all("sessions")
#     return obj

@app.route("/users/<int:pid>")
def getParticipantData(pid):
    '''
    Gets a participant's data by PID.
    '''
    # make a query to get the row of the user with that name
    res = db.get_user('participants', pid)
    return json.jsonify(res)

# Mirroring this for the sessions DB
# @app.route("/sessions/<int:pid>")
# def getSessionData(session_id):
#     '''
#     Gets a participant's session data by session ID.
#     '''
#     # make a query to get the row of the user with that name
#     res = my_db.get_user('sessions', session_id)
#     return str(res)

@app.route("/users")
def getAllParticipants():
    '''
    Gets all participants.
    '''
    res = db.get_all_users()
    return json.jsonify(res)

@app.route("/addusers", methods=['POST'])
def createUser(): # creates a new row 
    '''
    Create a new user.
    '''
    print(request.get_data(as_text=True))
    res = db.add_record('participants', request.form)
    addedName = request.form.get('name')
    # print('This is the added name: ', addedName)# prints whatever value was input
    pid = db.cs.lastrowid # grab the last row pid (the one that was just added)
    print('And this is its pid: ', db.cs.lastrowid)
    response = db.get_user('participants', pid)
    return response

# For the Session Database

@app.route("/sessions")
def getAllSessions():
    '''
    Gets all sessions from sessions table.
    '''
    res = db.get_all_sessions()
    return json.jsonify(res)


# For the Session Database
@app.route("/addsession", methods=['POST'])
def createSession(): # creates a new row 
    '''
    Create a new session.
    '''
    print('getting value...')
    dataset = []
    rawData = request.get_data(as_text=True)
    print('Below this')
    iterator = request.form.items()
    session_data = {}
    for (key, val) in iterator:
        if key == 'participant_id' or key == 'start_time' or key == 'duration' or key == 'score' or key == 'threshold':
            session_data[key] = val
        else:
            session_data[key] = val
    # print(request.get_data(as_text=True))
    # Ensure the form field 'participant_id' is in the POST request
    participant_id = request.form.get('participant_id')
    sid = db.cs.lastrowid # grab the last row pid (the one that was just added)
    addedType = request.form.get('feedback_type') # Looks for the feedback type
    # session_data = {
    #     'participant_id': participant_id,
    #     'feedback_type': addedType,
    #     'start_time': sid
    # }
    print('This is being passed on:')
    print(session_data)
    res = db.add_record('sessions', session_data)
    
    # print(addedType)# prints whatever value was input
    
    # print('And this is what was added: ', session_data)
    # response = db.get_session('sessions', sid)
    res = {'data': {'session_id': res}}
    print('res', res)
    return json.jsonify(res)


# @app.route("/user/<name>", methods=['POST'])
# def myGetParticipantData(name):
#     '''
#     Get participant data by name
#     '''
#     # make a query to get the row of the user with that name
#     res = sql.cs.execute("SELECT * FROM participants WHERE name= '"+ str(name)+"' ;").fetchall()
#     # res = sql.get_user('participants', pid)
#     return {'pid': res[0][0], 'name': res[0][1]}

# For the Session Database
@app.route("/sessions/<int:pid>/<string:feedback_type>")
def getParticipantSessions(pid, feedback_type):
    '''
    Get all session data by pid of a specific feedback type
    '''
    res = db.get_sessions(pid, feedback_type)
    return json.jsonify(res)



### Test code to connect to local host 5000

# we need to create a new user when a user enter in an ID (name + numbers)
# researchers should create an account for the patient, the patient uses their assigned PID to log in
# # When they enter PID into the home page, the code should access that position in the database
# # Once a session is done, the core information (from db schema) should be sent to that position

