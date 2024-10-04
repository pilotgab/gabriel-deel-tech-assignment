import os
import pytest
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from app import app, db, IP

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client
        with app.app_context():
            db.drop_all()

def test_display_ip(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'Your IP address is' in response.data

def test_display_all(client):
    # Add a test IP to the database
    with app.app_context():
        test_ip = IP(reversed_ip='1.1.1.1')
        db.session.add(test_ip)
        db.session.commit()

    response = client.get('/all')
    assert response.status_code == 200
    assert b'1.1.1.1' in response.data

def test_health_check(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert b'Database connection successful' in response.data

def test_error_handling(client, mocker):
    # Mock the IP.query.filter_by to raise an exception
    mocker.patch('app.IP.query.filter_by', side_effect=Exception('Test exception'))

    response = client.get('/')
    assert response.status_code == 500
    assert b'Error occurred' in response.data