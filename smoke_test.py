import pytest
from app import app, db, IP

@pytest.fixture
def client():
    # Set up the Flask test client
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'  # In-memory DB for testing
    with app.test_client() as client:
        with app.app_context():
            # Create all tables in the in-memory database
            db.create_all()
        yield client


def test_home_page(client):
    # Test the '/' route to ensure it returns a successful response
    response = client.get('/')
    assert response.status_code == 200
    assert b"Welcome to Gabriel's Challenge!" in response.data
    assert b"Your IP is:" in response.data
    assert b"Your reversed IP is:" in response.data


def test_all_ips_page(client):
    # Test the '/all' route to ensure it returns a successful response
    response = client.get('/all')
    assert response.status_code == 200
    assert b"All Reversed IPs" in response.data
    assert b"Homepage" in response.data


def test_health_check(client):
    # Test the '/health' route to ensure it returns a successful response
    response = client.get('/health')
    assert response.status_code == 200
    assert b"Database connection successful" in response.data
