from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
import os
# import database.db_connector as db

# Configuration

app = Flask(__name__, template_folder='htmls')

# db_connection = db.connect_to_database()

app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_palsa'
app.config['MYSQL_PASSWORD'] = '5384' #last 4 of onid
app.config['MYSQL_DB'] = 'cs340_palsa'
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/pcps.html')
def page1():
    return render_template('locations.html')

@app.route('/patients.html')
def page2():
    return render_template('patients.html')

@app.route('/pcps.html')
def page3():
    return render_template('pcps.html')

@app.route('/visits.html')
def page4():
    return render_template('visits.html')

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 9112))
    app.run(port=port, debug=True)
