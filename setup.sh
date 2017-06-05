#!/bin/bash
# Sample script to build a Django development box
# Arguments: $1 => HOST_IP
#            $2 => HOST_PORT

# Fail on first error
set -e

# Extract arguments
HOST_IP=$1
HOST_PORT=$2

# Download & Install Anaconda Anaconda3-4.4.0-Linux-x86_64.sh
wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
bash Anaconda3-4.4.0-Linux-x86_64.sh -b -p $HOME/anaconda3

# Setup environment to pick up latest Python/PIP
export PATH=$HOME/anaconda3/bin:$PATH

# PIP install dependencies
pip install django
pip install mod_wsgi-httpd
pip install mod_wsgi

# Confirm Django installation
python -m django --version
 
# Create sample Django project and perform initial setup
django-admin startproject mysite
cd mysite
python manage.py migrate

# Run Django using built-in webserver (non-production)
# python manage.py runserver $HOST_IP:$HOST_PORT

# Run Django using Apache webserver (production)
PYTHON_WSGI_MODULE=mysite.wsgi
mod_wsgi-express start-server --application-type module $PYTHON_WSGI_MODULE --host $HOST_IP --port $HOST_PORT


# Monitor logs
tail -f /tmp/mod_wsgi-$HOST_IP\:$HOST_PORT\:500/error_log 
