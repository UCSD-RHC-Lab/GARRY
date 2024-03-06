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


@app.route("/users/<int:pid>")
def getParticipantData(pid):
    '''
    Gets a participant's data by PID.
    '''
    # make a query to get the row of the user with that name
    res = db.get_user('participants', pid)
    return json.jsonify(res)


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
    res = db.add_record('participants', request.form)
    addedName = request.form.get('name')
    pid = db.cs.lastrowid # grab the last row pid (the one that was just added)
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
    dataset = []
    rawData = request.get_data(as_text=True)
    iterator = request.form.items()
    session_data = {}
    for (key, val) in iterator:
        if key == 'participant_id' or key == 'start_time' or key == 'duration' or key == 'score' or key == 'threshold':
            session_data[key] = val
        else:
            session_data[key] = val
            
    participant_id = request.form.get('participant_id')
    sid = db.cs.lastrowid # grab the last row pid (the one that was just added)
    addedType = request.form.get('feedback_type') # Looks for the feedback type
    res = db.add_record('sessions', session_data)

    res = {'data': {'session_id': res}}
    return json.jsonify(res)


# For the Session Database
@app.route("/sessions/<int:pid>/<string:feedback_type>")
def getParticipantSessions(pid, feedback_type):
    '''
    Get all session data by pid of a specific feedback type
    '''
    res = db.get_sessions(pid, feedback_type)
    return json.jsonify(res)