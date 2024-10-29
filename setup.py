from setuptools import setup, find_packages

# Read the dependencies from requirements.txt
def read_requirements(file):
    with open(file) as f:
        return f.read().splitlines()

setup(
    name='app',
    version='0.1',
    packages=find_packages(),  # Automatically discover packages
    install_requires=read_requirements('requirements.txt'),  # Read from requirements.txt
    include_package_data=True,  # Include other files specified in MANIFEST.in
    entry_points={
        'console_scripts': [
            'run-app=app:app'
        ],
    },
)
