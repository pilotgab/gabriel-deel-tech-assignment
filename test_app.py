import pytest
from app import app, db, IP

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_display_ip(client):
    response = client.get('/')
    assert response.status_code == 200

def test_display_all(client):
    response = client.get('/all')
    assert response.status_code == 200

def test_health_check(client):
    response = client.get('/health')
    assert response.status_code == 200
