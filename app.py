import os
import logging
from flask import Flask, request, render_template
from flask_sqlalchemy import SQLAlchemy
from werkzeug.middleware.proxy_fix import ProxyFix

# Configure logging
logging.basicConfig(filename='app.log', level=logging.ERROR)

# Initialize Flask app
app = Flask(__name__)
app.debug = True  # Enable debug mode

# Configure database
db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'instance', 'deel-test.db')
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + db_path  
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Apply ProxyFix middleware
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=2)  # To get the correct IP behind a proxy.

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# Define IP model
class IP(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reversed_ip = db.Column(db.String(15), nullable=False)

# Function to create the database
def create_database():
    with app.app_context():
        db.create_all()

# Route to display the client's IP address
@app.route('/')
def display_ip():
    try:
        # Get the client's IP address
        ip_address = request.remote_addr
        # Reverse the IP address
        reversed_ip = '.'.join(ip_address.split('.')[::-1])
        # Check if the reversed IP already exists in the database
        existing_ip = IP.query.filter_by(reversed_ip=reversed_ip).first()
        if not existing_ip:
            # If not, create a new entry and add it to the database
            new_ip_entry = IP(reversed_ip=reversed_ip)
            db.session.add(new_ip_entry)
            db.session.commit()
        # Render the index.html template with the IP address and its reversed version
        return render_template('index.html', ip=ip_address, reversed_ip=reversed_ip)
    except Exception as error:
        # Log any errors and render the error.html template
        app.logger.error(f"Error occurred: {error}")
        return render_template('error.html'), 500

# Route to display all stored IP addresses
@app.route('/all')
def display_all():
    try:
        # Query all IP entries from the database
        all_ips = IP.query.all()
        # Extract the reversed IP addresses
        reversed_ips = [ip.reversed_ip for ip in all_ips]
        # Render the all.html template with the reversed IP addresses
        return render_template('all.html', reversed_ips=reversed_ips)
    except Exception as error:
        # Log any errors and render the error.html template
        app.logger.error(f"Error occurred: {error}")
        return render_template('error.html'), 500

# Route to perform a health check on the database connection
@app.route('/health')
def health_check():
    try:
        # Query the first IP entry from the database to check the connection
        result = db.session.query(IP).first()
        if result:
            # If successful, render the health.html template with a success message
            return render_template('health.html', message='Database connection successful', css_class='success'), 200
        else:
            # If no result, raise an exception
            raise Exception("Database query failed")
    except Exception as error:
        # Log any errors and render the health.html template with a failure message
        app.logger.error(f"Database connection failed: {error}")
        return render_template('health.html', message='Database connection failed', css_class='failure'), 500

# Main entry point
if __name__ == '__main__':
    # Check if the 'instance' directory exists, create it if not
    if not os.path.exists('instance'):
        os.makedirs('instance')
    # Create the database tables
    create_database()
    # Run the Flask app on 0.0.0.0:8080
    app.run(host='0.0.0.0', port=8080)
