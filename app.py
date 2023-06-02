from flask import Flask, render_template, json, redirect
# from flask_mysqldb import MySQL
from flask import request
import os
import database.db_connector as db

# Configuration

app = Flask(__name__, template_folder='htmls')

# app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
# app.config['MYSQL_USER'] = 'cs340_palsa'
# app.config['MYSQL_PASSWORD'] = '5384' #last 4 of onid
# app.config['MYSQL_DB'] = 'cs340_palsa'
# app.config['MYSQL_CURSORCLASS'] = "DictCursor"

# mysql = MySQL(app)
db_connection = db.connect_to_database()

@app.route('/')
def home():
    return render_template('main.j2')

@app.route('/locations')
def page1():
    return render_template('locations.html')

@app.route('/patients')
def page2():
    return render_template('patients.html')


@app.route('/pcps', methods=['GET', 'POST'])
def pcps():
    if request.method == 'POST':
        first_name = request.form.get('first_name') 
        last_name = request.form.get('last_name')
        pcp_specialty = request.form.get('pcp_specialty')
        
        query = "INSERT INTO PCPs (first_name, last_name, pcp_specialty) VALUES (%s, %s, %s);"
        db.execute_query(db_connection=db_connection, query=query, query_params=(first_name, last_name, pcp_specialty))
        return redirect('/pcps')


    #sample code
    query = "SELECT * FROM PCPs;"
    cursor = db.execute_query(db_connection=db_connection, query=query)
    results = cursor.fetchall()
    return render_template("pcps.j2", pcps=results)

@app.route('/pcps/<int:pcp_id>', methods=['GET', 'POST', 'DELETE'])
def pcp(pcp_id):
    if request.method == 'POST':
        first_name = request.form.get('first_name') 
        last_name = request.form.get('last_name')
        pcp_specialty = request.form.get('pcp_specialty')
        
        query = "UPDATE PCPs SET first_name = %s, last_name = %s, pcp_specialty = %s WHERE pcp_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(first_name, last_name, pcp_specialty, pcp_id))

    elif request.method == 'DELETE':
        query = "DELETE FROM PCPs WHERE pcp_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(pcp_id,))
        
    query = "SELECT * FROM PCPs WHERE pcp_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(pcp_id,))
    result = cursor.fetchone()
    return render_template("pcp.j2", pcp=result)  # Render a specific template for individual PCP

@app.route('/visits.html')
def page4():
    return render_template('visits.html')

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 9112))
    app.run(port=port, debug=True)
