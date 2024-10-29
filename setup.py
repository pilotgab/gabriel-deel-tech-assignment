from setuptools import setup, find_packages

setup(
    name='app',
    version='0.1',
    packages=find_packages(),
    install_requires=[
        'pytest-html',
        'Flask-SQLAlchemy==3.1.1',
        'Werkzeug==2.2.3',
        'zipp>=3.19.1',
        'Jinja2',
        'prometheus_client',
        'itsdangerous',
        'kubernetes',
        'pytest',
        'pytest-mock',
        'flask==2.2.5',
        'MarkupSafe',
        'click',
        'build',
        'psycopg2-binary',
        'pytest-flask',
        'pytest-cov',
        'flake8',
        'gunicorn==20.1.0',
        'Flask-Testing',
        'prometheus-flask-exporter==0.23.1',
    ],
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'run-app=app:app'
        ],
    },
)
