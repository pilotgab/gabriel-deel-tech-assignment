import os
import logging
from flask import Flask, request, render_template
from flask_sqlalchemy import SQLAlchemy
from werkzeug.middleware.proxy_fix import ProxyFix

# Set up logging
logging.basicConfig(filename='app.log', level=logging.ERROR)

app = Flask(__name__)
db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'instance', 'deel-test.db')
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + db_path  # SQLite database file
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=2)  # To get the correct IP behind a proxy (like Nginx)

db = SQLAlchemy(app)

class IP(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    reversed_ip = db.Column(db.String(15), nullable=False)


def create_database():
    with app.app_context():
        db.create_all()

@app.route('/')
def display_ip():
    try:
        ip_address = request.remote_addr
        reversed_ip = '.'.join(ip_address.split('.')[::-1])
        existing_ip = IP.query.filter_by(reversed_ip=reversed_ip).first()
        if not existing_ip:
            new_ip_entry = IP(reversed_ip=reversed_ip)
            db.session.add(new_ip_entry)
            db.session.commit()
        return render_template('index.html', ip=ip_address, reversed_ip=reversed_ip)
    except Exception as error:
        app.logger.error(f"Error occurred: {error}")
        return render_template('error.html'), 500

@app.route('/all')
def display_all():
    try:
        all_ips = IP.query.all()
        reversed_ips = [ip.reversed_ip for ip in all_ips]
        return render_template('all.html', reversed_ips=reversed_ips)
    except Exception as error:
        app.logger.error(f"Error occurred: {error}")
        return render_template('error.html'), 500

@app.route('/health')
def health_check():
    try:
        result = db.session.query(IP).first()
        if result:
            return render_template('health.html', message='Database connection successful', css_class='success'), 200
        else:
            raise Exception("Database query failed")
    except Exception as error:
        app.logger.error(f"Database connection failed: {error}")
        return render_template('health.html', message='Database connection failed', css_class='failure'), 500

if __name__ == '__main__':
    if not os.path.exists('instance'):
        os.makedirs('instance')
    create_database()
    app.run(host='0.0.0.0', port=8080)
