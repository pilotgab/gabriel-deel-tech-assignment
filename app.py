import os
import logging
from flask import Flask, request, render_template
from flask_sqlalchemy import SQLAlchemy
from werkzeug.middleware.proxy_fix import ProxyFix
from prometheus_flask_exporter import PrometheusMetrics


# Configure logging error
logging.basicConfig(filename='app.log', level=logging.INFO)


# Initialize Flask app
app = Flask(__name__)
app.config['DEBUG'] = True  # Enable debug mode


# Configure database
db_path = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    'instance',
    'deel-test.db'
)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + db_path
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False


# Apply ProxyFix middleware
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=2)


# Initialize SQLAlchemy
db = SQLAlchemy(app)


# Initialize Prometheus Metrics
metrics = PrometheusMetrics(app)


# Define IP model

class IP(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reversed_ip = db.Column(db.String(15), nullable=False)


# Function to create the database

def create_database():
    try:
        with app.app_context():
            db.create_all()
    except Exception as e:
        app.logger.error(f"Failed to create database: {e}")


# Route to display the client's IP address

@app.route('/')
def display_ip():
    try:
        # Check for X-Forwarded-For header
        if request.headers.get('X-Forwarded-For'):
            # Get the first IP in the list
            ip_address = request.headers.get('X-Forwarded-For') \
             .split(',')[0].strip()
        else:
            ip_address = request.remote_addr or "127.0.0.1"

        reversed_ip = '.'.join(ip_address.split('.')[::-1])
        existing_ip = IP.query.filter_by(reversed_ip=reversed_ip).first()
        if not existing_ip:
            new_ip_entry = IP(reversed_ip=reversed_ip)
            db.session.add(new_ip_entry)
            db.session.commit()
            app.logger.info(f"New IP entry created: {reversed_ip}")

        return render_template(
            'index.html',
            ip=ip_address,
            reversed_ip=reversed_ip
        )
    except Exception as error:
        app.logger.error(f"Error occurred in display_ip: {error}")
        return render_template('error.html'), 500


# Route to display all stored IP addresses

@app.route('/all')
def display_all():
    try:
        all_ips = IP.query.all()
        reversed_ips = [ip.reversed_ip for ip in all_ips]
        return render_template('all.html', reversed_ips=reversed_ips)
    except Exception as error:
        app.logger.error(f"Error occurred in display_all: {error}")
        return render_template('error.html'), 500


# Route to perform a health check on the database connection

@app.route('/health')
def health_check():
    try:
        result = db.session.query(IP).first()
        if result is not None:
            return render_template(
                'health.html',
                message='Database connection successful',
                css_class='success'
            ), 200
        else:
            return render_template(
                'health.html',
                message='Database connection successful, '
                        'but no data available',
                css_class='warning'
            ), 200
    except Exception as error:
        app.logger.error(
            f"Database connection failed in health_check: {error}"
        )
        return render_template(
            'health.html',
            message='Database connection failed',
            css_class='failure'
        ), 500


# Main entry point
if __name__ == '__main__':
    if not os.path.exists('instance'):
        os.makedirs('instance')
    create_database()
    app.run(host='0.0.0.0', port=8080)
