import pytest  
import os  
from app import app, db, IP  

# Create a test client and configure the test environment  
@pytest.fixture  
def client():  
    # Set the environment variable for testing  
    app.config['TESTING'] = True  
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'  # Use in-memory database for tests  
    with app.app_context():  
        db.create_all()  # Create database tables  
        yield app.test_client()  # Yield the test client  
    with app.app_context():  
        db.session.remove()  
        db.drop_all()  

@pytest.fixture(autouse=True)  
def remove_ip_entries(client):  
    # Clean up (remove entries) before each test  
    yield  
    with app.app_context():  
        db.session.remove()  
        db.drop_all()  

def test_display_ip(client):  
    # Simulate a request to the display_ip route  
    response = client.get('/')  
    assert response.status_code == 200  
    assert b'IP' in response.data  # Adjust as necessary based on your templates  

def test_display_all(client):  
    # Ensure display_all route works, initially should return an empty list  
    response = client.get('/all')  
    assert response.status_code == 200  

    # Adding a sample IP entry  
    with app.app_context():  
        reversed_ip = '1.0.0.127'  # Sample reversed IP  
        ip_entry = IP(reversed_ip=reversed_ip)  
        db.session.add(ip_entry)  
        db.session.commit()  

    # Test again  
    response = client.get('/all')  
    assert response.status_code == 200  
    assert reversed_ip.encode() in response.data  # Check if reversed IP is in the response  

def test_health_check(client):  
    # Test the health check route  
    response = client.get('/health')  
    assert response.status_code == 200  
    assert b'Database connection successful' in response.data  

def test_create_database(client):  
    # Test database creation  
    with app.app_context():  
        ip_entry = IP(reversed_ip='127.0.0.1')  
        db.session.add(ip_entry)  
        db.session.commit()  
    
        assert IP.query.count() == 1  # There should be one record now  

        # Test that the entry has been stored correctly  
        retrieved_entry = IP.query.first()  
        assert retrieved_entry.reversed_ip == '127.0.0.1'