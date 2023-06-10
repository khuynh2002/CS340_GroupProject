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

# @app.route('/patients')
# def page2():
#     return render_template('patients.html')

@app.route('/patients', methods=['GET', 'POST'])
def patients():
    if request.method == 'POST':
        first_name = request.form.get('first_name') 
        last_name = request.form.get('last_name')
        date_of_birth = request.form.get('date_of_birth')
        sex = request.form.get('sex')
        gender = request.form.get('gender')
        PCPs_pcp_id = request.form.get('PCPs_pcp_id')
        
        query = "INSERT INTO Patients (first_name, last_name, date_of_birth, sex, gender, PCPs_pcp_id) VALUES (%s, %s, %s, %s, %s, %s);"
        db.execute_query(db_connection=db_connection, query=query, query_params=(first_name, last_name, date_of_birth, sex, gender, PCPs_pcp_id))
        return redirect('/patients')

    query = "SELECT * FROM Patients;"
    cursor = db.execute_query(db_connection=db_connection, query=query)
    results = cursor.fetchall()
    return render_template("patients.j2", patients=results)

@app.route('/delete_patient/<int:patient_id>', methods=['GET', 'POST'])
def delete_patient(patient_id): 
    query = "DELETE FROM Patients WHERE patient_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(patient_id,))
    return redirect('/patients')

@app.route('/patients/<int:patient_id>', methods=['GET', 'POST', 'DELETE'])
def patient(patient_id):
    if request.method == 'POST':
        first_name = request.form.get('first_name') 
        last_name = request.form.get('last_name')
        date_of_birth = request.form.get('date_of_birth')
        sex = request.form.get('sex')
        gender = request.form.get('gender')
        PCPs_pcp_id = request.form.get('PCPs_pcp_id')
        
        query = "UPDATE Patients SET first_name = %s, last_name = %s, date_of_birth = %s, sex = %s, gender = %s, PCPs_pcp_id = %s WHERE patient_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(first_name, last_name, date_of_birth, sex, gender, PCPs_pcp_id, patient_id))

    elif request.method == 'DELETE':
        query = "DELETE FROM Patients WHERE patient_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(patient_id,))
        
    query = "SELECT * FROM Patients WHERE patient_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(patient_id,))
    result = cursor.fetchone()
    return render_template("patient.j2", patient=result)  # Render a specific template for individual patient

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
    return render_template("pcps3.j2", pcps=results)

@app.route('/delete_pcp/<int:pcp_id>', methods=['GET', 'POST'])
def delete_pcp(pcp_id): 
    query = "DELETE FROM PCPs WHERE pcp_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(pcp_id,))
    return redirect('/pcps')


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

@app.route('/locations', methods=['GET', 'POST'])
def locations():
    if request.method == 'POST':
        location_name = request.form.get('location_name') 
        location_city = request.form.get('location_city')
        location_state = request.form.get('location_state')
        location_zip = request.form.get('location_zip')
        
        query = "INSERT INTO Locations (location_name, location_city, location_state, location_zip) VALUES (%s, %s, %s, %s);"
        db.execute_query(db_connection=db_connection, query=query, query_params=(location_name, location_city, location_state, location_zip))
        return redirect('/locations')
    #sample code
    query = "SELECT * FROM Locations;"
    cursor = db.execute_query(db_connection=db_connection, query=query)
    results = cursor.fetchall()
    return render_template("locations.j2", locations=results)

@app.route('/delete_location/<int:location_id>', methods=['GET', 'POST'])
def delete_location(location_id): 
    query = "DELETE FROM Locations WHERE location_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(location_id,))
    return redirect('/locations')

@app.route('/locations/<int:location_id>', methods=['GET', 'POST', 'DELETE'])
def location(location_id):
    if request.method == 'POST':
        location_name = request.form.get('location_name') 
        location_city = request.form.get('location_city')
        location_state = request.form.get('location_state')
        location_zip = request.form.get('location_zip')
        
        query = "UPDATE Locations SET location_name = %s, location_city = %s, location_state = %s, location_zip = %s WHERE location_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(location_name, location_city, location_state, location_zip, location_id))

    elif request.method == 'DELETE':
        query = "DELETE FROM Locations WHERE location_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(location_id,))
        
    query = "SELECT * FROM Locations WHERE location_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(location_id,))
    result = cursor.fetchone()
    return render_template("locations2.j2", location=result) 

# @app.route('/visits')
# def page4():
#     return render_template('visits.html')
@app.route('/visits', methods=['GET', 'POST'])
def visits():
    if request.method == 'POST':
        visit_date = request.form.get('visit_date') 
        visit_length = request.form.get('visit_length')
        diagnosis = request.form.get('diagnosis')
        med_prescribed = request.form.get('med_prescribed')
        Patients_patient_id = request.form.get('Patients_patient_id')
        Patients_PCPs_pcp_id = request.form.get('Patients_PCPs_pcp_id')
        Locations_location_id = request.form.get('Locations_location_id')
        
        query = "INSERT INTO Visits (visit_date, visit_length, diagnosis, med_prescribed, Patients_patient_id, Patients_PCPs_pcp_id, Locations_location_id) VALUES (%s, %s, %s, %s, %s, %s, %s);"
        db.execute_query(db_connection=db_connection, query=query, query_params=(visit_date, visit_length, diagnosis, med_prescribed, Patients_patient_id, Patients_PCPs_pcp_id, Locations_location_id))
        return redirect('/visits')
    
    query = "SELECT * FROM Visits;"
    cursor = db.execute_query(db_connection=db_connection, query=query)
    results = cursor.fetchall()
    return render_template("visits.j2", visits=results)

@app.route('/delete_visit/<int:visit_id>', methods=['GET', 'POST'])
def delete_visit(visit_id): 
    query = "DELETE FROM Visits WHERE visit_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(visit_id,))
    return redirect('/visits')

@app.route('/visits/<int:visit_id>', methods=['GET', 'POST', 'DELETE'])
def visit(visit_id):
    if request.method == 'POST':
        visit_date = request.form.get('visit_date') 
        visit_length = request.form.get('visit_length')
        diagnosis = request.form.get('diagnosis')
        med_prescribed = request.form.get('med_prescribed')
        Patients_patient_id = request.form.get('Patients_patient_id')
        Patients_PCPs_pcp_id = request.form.get('Patients_PCPs_pcp_id')
        Locations_location_id = request.form.get('Locations_location_id')
        
        query = "UPDATE Visits SET visit_date = %s, visit_length = %s, diagnosis = %s, med_prescribed = %s, Patients_patient_id = %s, Patients_PCPs_pcp_id = %s, Locations_location_id = %s WHERE visit_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(visit_date, visit_length, diagnosis, med_prescribed, Patients_patient_id, Patients_PCPs_pcp_id, Locations_location_id, visit_id))

    elif request.method == 'DELETE':
        query = "DELETE FROM Visits WHERE visit_id = %s;"
        db.execute_query(db_connection=db_connection, query=query, query_params=(visit_id,))
        
    query = "SELECT * FROM Visits WHERE visit_id = %s;"
    cursor = db.execute_query(db_connection=db_connection, query=query, query_params=(visit_id,))
    result = cursor.fetchone()
    return render_template("visit.j2", visit=result)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 9112))
    app.run(port=port, debug=True)
