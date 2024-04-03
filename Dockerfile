# This Dockerfile is used to build an application image for a Flask web application with PostgreSQL client 
# and Flask development server.

# Using an official Python 3.9 runtime as a parent image for building the application
FROM python:3.9-slim-buster as build

# Set environment variables to optimize Python runtime
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container where the application will reside
WORKDIR /app

# Add a user that will run the application for security purposes
RUN addgroup --system app && adduser --system --group app

# Install system dependencies required for building the application
RUN apt-get update \
    && apt-get install build-essential libpq-dev -y \
    && apt-get clean

# Switch to the non-root app user for running the application
USER app

# Install application dependencies by copying the requirements file and installing them
COPY --chown=app:app requirements.txt ./
RUN pip install --user --no-cache-dir -r requirements.txt

# Copy local code to the container image for building the application
COPY --chown=app:app . .

# Use multi-stage build to create a lean production image
FROM python:3.9-slim-buster as final

# Set environment variables to optimize Python runtime in the final image
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and switch to a new user 'app' for security reasons
RUN addgroup --system app && adduser --system --group app

# Install PostgreSQL client to interact with a PostgreSQL database
RUN apt-get update \
    && apt-get install libpq5 -y \
    && apt-get clean

# Copy Python dependencies from the builder image to the final image
COPY --from=build --chown=app:app /home/app/.local /home/app/.local
ENV PATH=/home/app/.local/bin:$PATH

# Copy the application code from the builder image to the final image
WORKDIR /app
COPY --from=build --chown=app:app /app /app

# Create a directory for storing application logs and set permissions
RUN mkdir -p /var/log/app && chown app:app /var/log/app
VOLUME /var/log/app

# Create a directory for storing the SQLite database used by the application
RUN mkdir -p /app/instance && chown app:app /app/instance
VOLUME /app/instance

# Expose port 8080 to allow external access to the application
EXPOSE 8080

# Switch to the non-root 'app' user before running the application using Flask development server
USER app

# Command to start the Flask development server and run the Flask application
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080", "--with-threads", "--no-reload"]
