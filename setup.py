import os
from setuptools import setup, find_packages


def read_requirements(file):
    """Read the requirements from a given file."""
    with open(os.path.join(os.path.dirname(__file__), file)) as f:
        return f.read().splitlines()


setup(
    name='app',
    version='0.1',
    packages=find_packages(),
    install_requires=read_requirements('requirements.txt'),
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'run-app=app:app',
        ],
    },
)
