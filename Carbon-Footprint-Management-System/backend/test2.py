import mysql.connector
from flask import Flask, render_template, request, redirect, url_for, flash



app = Flask(__name__)
app.secret_key = 'your_secret_key'


# MySQL Configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_DATABASE'] = 'icfms'  # Your database name
app.config['MYSQL_USER'] = 'root'  # Your MySQL username
app.config['MYSQL_PASSWORD'] = 'nunez'  # Your MySQL password

# Create a connection
def get_db_connection():
    connection = mysql.connector.connect(
        host=app.config['MYSQL_HOST'],
        database=app.config['MYSQL_DATABASE'],
        user=app.config['MYSQL_USER'],
        password=app.config['MYSQL_PASSWORD']
    )
    return connection

# Route for the home page (show the form)
@app.route('/')
def index():
    return render_template('index.html') 
# Route for the auditor signup page (auditor_signup.html)
# @app.route('/signup')
# def signup():
#     return render_template('signup.html')
# @app.route('/auditor_signup')
# def auditor_signup():
#     return render_template('auditor_signup.html')

# # Route for the transportation page (trans.html)
# @app.route('/trans')
# def trans():
#     return render_template('trans.html')

# # Route for the carbon page (carbon.html)
# @app.route('/carbon')
# def carbon():
#     return render_template('carbon.html')

# # Route for the process page (process.html)
# @app.route('/process')
# def process():
#     return render_template('process.html')

# # Route for the emission sources page (emission_s.html)
# @app.route('/emission_s')
# def emission_s():
#     return render_template('emission_s.html')
# # Route for the admin login page (admin_login.html)
# @app.route('/admin_login')
# def admin_login():
#     return render_template('admin_login.html')

# # Route for the user login page (login.html)
# @app.route('/login')
# def login():
#     return render_template('login.html')




# Route for handling form submission and updating the database
# @app.route('/submit', methods=['POST'])
# def submit():
#     # Get data from the form
#     industry_name = request.form['industry_name']
#     location = request.form['location']
#     industry_type = request.form['industry_type']
    
#     # Connect to the database
#     connection = get_db_connection()
#     cursor = connection.cursor()

#     # SQL query to insert the data into the Industries table
#     insert_query = """
#     INSERT INTO Industries (industry_name, location, industry_type)
#     VALUES (%s, %s, %s)
#     """
#     cursor.execute(insert_query, (industry_name, location, industry_type))
#     connection.commit()  # Commit the transaction

#     cursor.close()
#     connection.close()

#     return redirect(url_for('home'))  # Redirect to home page after submission



# code for the signup page 

# @app.route('/register', methods=['GET', 'POST'])
# def register():
#     if request.method == 'POST':
#         # Get data from form
#         username = request.form['username']
#         email = request.form['email']
#         password = request.form['password']
        
#         # Connect to the database
#         connection = get_db_connection()
#         cursor = connection.cursor()

#         # SQL query to insert the new user into the database
#         insert_query = """
#         INSERT INTO USER (username, email, password, role_id)
#         VALUES (%s, %s, %s, %s)
#         """
#         try:
#             cursor.execute(insert_query, (username, email, password, 2))  # role_id 2 for standard user
#             connection.commit()
#             flash("Signup successful!", "success")
#             return render_template('index.html')  # Redirect to login page after signup
#         except mysql.connector.Error as err:
#             flash(f"Error: {err}", "danger")
#             return render_template('index.html')
#         finally:
#             cursor.close()
#             connection.close()
#     return render_template('index.html')




if __name__ == '__main__':
    app.run(debug=True)