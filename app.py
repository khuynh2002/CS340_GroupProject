from flask import Flask, render_template

app = Flask(__name__, template_folder='htmls')

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
    app.run(debug=True)

