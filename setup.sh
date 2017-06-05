#!/bin/bash
# Sample script to build a Django development box
# Base OS configurations:
# => CentOS 6.x
# => yum update
# => yum install gcc
# => Configure firewalls for port ???
# Arguments: $1 => HOST_IP
#            $2 => HOST_PORT

# Fail on first error
set -e

# Extract arguments
HOST_IP=$1
HOST_PORT=$2

# Fail if arguments not passed
if [[ $# -ne 2 ]] ; then
    echo 'Must pass two arguments:  HOST_IP and HOST_PORT'
    exit 0
fi

# Base locations
DOWNLOADS_DIR=./downloads
PYTHON_INSTALL_DIR=$HOME/anaconda3

function cleanup {
  echo cleanup...
  if [ -d "$PYTHON_INSTALL_DIR" ]; then
    rm -rf $PYTHON_INSTALL_DIR
  fi
  if [ -d "$DOWNLOADS_DIR" ]; then
    rm -rf $DOWNLOADS_DIR
  fi
}

# Main script

# Perform initial cleanup
cleanup

# Download & Install Anaconda Anaconda3-4.4.0-Linux-x86_64.sh
mkdir $DOWNLOADS_DIR
wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O ./downloads/Anaconda3-4.4.0-Linux-x86_64.sh
bash $DOWNLOADS_DIR/Anaconda3-4.4.0-Linux-x86_64.sh -b -p $PYTHON_INSTALL_DIR

# Setup environment to pick up latest Python/PIP
export PATH=PYTHON_INSTALL_DIR/bin:$PATH

# PIP install dependencies
pip install -r requirements.txt
exit

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

# Stop timer
