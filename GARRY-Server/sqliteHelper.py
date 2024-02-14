import sqlite3
from os.path import exists

from objectHelper import *
from constants import *


class sqliteHelper:
    
    id_col = 'participant_id'


    def __init__(self, db_path) -> None:
        '''
        Constructor. Minimal instance variable assignments. Kicks off the setup
        process.
        '''
        self.db_path = db_path
        self.conn = None
        self.setup()

    def setup(self):
        '''
        Assigns any instance variables dynamically. Also checks for database and
        tables existences.
        '''
        self._check_db()
        self.conn = sqlite3.connect(self.db_path, check_same_thread=False)
        self.cs = self.conn.cursor()

    def _check_db(self):
        '''
        A helper method to check if the database (db) file exists. If not, create
        a .db file.
        '''
        db_exists = exists(self.db_path)
        if not db_exists:
            self.create_db()

    def create_db(self):
        '''
        A helper method to create a database file.
        '''
        file = open(self.db_path, 'wb')
        file.close()

    def create_tables(self):
        '''
        A helper method to create the correct tables.
        '''
        self.cs.execute(
            f"CREATE TABLE IF NOT EXISTS Participants({id_col} INTEGER PRIMARY KEY,\
            name TEXT NOT NULL);")
        self.cs.execute(
            f"CREATE TABLE IF NOT EXISTS Sessions(session_id INTEGER PRIMARY KEY,\
            {id_col} INTEGER,\
            year INTEGER,\
            month INTEGER,\
            day INTEGER,\
            start_time INTEGER NOT NULL,\
            duration INTEGER NOT NULL,\
            score INTEGER,\
            feedback_type TEXT NOT NULL,\
            threshold INTEGER NOT NULL,\
            FOREIGN KEY({id_col}) REFERENCES Participants({id_col}));")
        self.conn.commit()

    def retrieve_all(self, table):
        '''
        Get all rows from a table
        '''
        res = self.cs.execute("SELECT * FROM " + table).fetchall()
        return {'data': res}

    def get_user(self, table, pid):
        '''
        Get a row with a specific user pid.
        '''
        res = self.cs.execute("SELECT * FROM " + table +
                              " WHERE participant_id=" + str(pid) + ";").fetchall()
        return {'data': res}
    
    def get_session(self, table, session_id):
        '''
        Get a row with a specific session id.
        '''
        res = self.cs.execute("SELECT * FROM " + table +
                              " WHERE session_id=" + str(session_id) + ";").fetchall()
        return {'data': res}

    def get_all_users(self):
        '''
        Get all users from the participants table.
        '''
        res = self.cs.execute("SELECT * FROM participants").fetchall()
        return {'data': res}
    
    def get_all_sessions(self):
        '''
        Get the  sessions from the sessions table.
        '''
        res = self.cs.execute("SELECT * FROM sessions").fetchall()
        return {'data': res}
    
    def get_sessions(self, pid, feedback_type,):
        '''
        Get the sessions from the sessions table with specific pid.
        '''
        # where_args = args.get('where')

        # build sort parameters

        sort_params = ""
        """
        if sort_args:
            sort_params = "ORDER BY "
            columns, orders = sort_args
            for column, order in zip(columns, orders):
                sort_params += column + " " + order + ","
            sort_params = sort_params[:-1]
        """
        # execute query
        query = f"SELECT * FROM sessions WHERE participant_id = {pid} AND feedback_type = '{feedback_type}';"
        print('query is', query)
        res = self.cs.execute(query).fetchall()
        return {'data': res}

    def add_record(self, table, data):
        '''
        Add a new row to a table.
        '''
        res = []
        # do some validity checks
        if table == 'participants':
            check = object_has(data, ['name'])
            if not check:
                print("invalid fields")
                return
            else:
                res = self.cs.execute("INSERT INTO " + table + "(name)" +
                              " VALUES('" + data['name'] + "');").fetchall()
        else:
            check = object_has(data, ['feedback_type', 'participant_id'])
            # print('Individual checks: ')
            # print(object_has(data, 'feedback_type'))
            # print(object_has(data, 'participant_id'))
            # print(object_has(data, 'feedback_type'))
            # print(data)
            if not check:
                print('invalid fields, need feedback type, participant_id, and start_time')
                return
            else:
                res = self.cs.execute("INSERT INTO " + table + "(feedback_type, participant_id, start_time, day, month, year, score, duration, threshold)" +
                      " VALUES('" + data['feedback_type'] + "', '" + data['participant_id'] + "', '" + data['start_time'] 
                      + "', '" + data['day'] + "', '" + data['month'] + "', '" + data['year'] + "', '" + data['score'] + "', '"
                      + data['duration'] + "', '" + data['threshold'] + "');").fetchall()
            
            
        # elif table == 'Sessions':

        self.conn.commit()
        print('lastrowid', self.cs.lastrowid)
        return self.cs.lastrowid