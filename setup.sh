#!/bin/bash
# Sample script to build a Django development box
# Arguments: $1 => HOST_IP
#            $2 => HOST_PORT

# Install Anaconda Anaconda3-4.4.0-Linux-x86_64.sh

# Setup environment to pick up latest Python/PIP

# PIP install django, mod_wsgi-httpd, mod_wsgi

# Create sample Django project and perform initial setup

python manage.py migrate

# Run Django project
HOST_IP=$1
HOST_PORT=$2
PYTHON_WSGI_MODULE=mysite.wsgi
mod_wsgi-express start-server --application-type module $PYTHON_WSGI_MODULE --host $HOST_IP --port $HOST_PORT
# python manage.py runserver $HOST_IP:$HOST_PORT

# Monitor logs
tail -f /tmp/mod_wsgi-$HOST_IP\:$HOST_PORT\:500/error_log 
