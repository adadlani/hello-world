#!/bin/bash
# Sample script to build a Django development box (run as non-superuser)
# This version uses the native httpd (not mod_wsg-express interface)
# Base OS configurations:
# => CentOS 6.x using bridged network
# => yum update
# => yum install git gcc wget httpd-devel [tree] (-devel also installs httpd, httpd-tools, etc)
# => Configured firewall to open port HOST_PORT
# Arguments: $1 => HOST_PORT

# Fail on first error
set -e

# Fail if arguments not passed
if [[ $# -ne 1 ]] ; then
    echo 'Must pass argument(s): HOST_PORT'
    exit 1
fi

# Fail if running as a superuser (root)
if [[ $EUID -eq 0 ]]; then
   echo "This script must NOT be run as root" 
   exit 1
fi

# Extract arguments
HOST_PORT=$1

# Base locations and other constants
DOWNLOADS_DIR=./downloads
PYTHON_INSTALL_DIR=$HOME/anaconda3
PIP_REQUIREMENTS=./requirements.txt
DJANGO_PROJECT_NAME=mysite
HOST_IP=$(hostname -I | xargs)

# Helper functions
function cleanup {
  echo cleanup...
  if [ -d "$PYTHON_INSTALL_DIR" ]; then
    rm -rf $PYTHON_INSTALL_DIR
  fi
  if [ -d "$DOWNLOADS_DIR" ]; then
    rm -rf $DOWNLOADS_DIR
  fi
}

function dwn_install_anaconda {
  mkdir $DOWNLOADS_DIR
  wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O ./downloads/Anaconda3-4.4.0-Linux-x86_64.sh
  bash $DOWNLOADS_DIR/Anaconda3-4.4.0-Linux-x86_64.sh -b -p $PYTHON_INSTALL_DIR
}

function install_dep {
  pip install -r $PIP_REQUIREMENTS
}

###################
# Main script entry
###################

# Perform initial cleanup
#cleanup

# Download & Install Anaconda Anaconda3-4.4.0-Linux-x86_64.sh
#dwn_install_anaconda

# Setup environment to pick up latest Python/PIP
#export PATH=$PYTHON_INSTALL_DIR/bin:$PATH
#echo "export PATH=$HOME/anaconda3/bin:$PATH" >> $HOME/.bashrc
#exit

# Require reboot for mod_wsgi-httpd to install ???

# PIP install dependencies
#install_dep

# Confirm Django installation
DJANGO_VERSION=$(python -m django --version)
echo Django version: $DJANGO_VERSION
 
# Create sample Django project and perform initial setup
#rm -rf $DJANGO_PROJECT_NAME
#django-admin startproject $DJANGO_PROJECT_NAME
cd $DJANGO_PROJECT_NAME
python manage.py migrate

# Run Django using built-in webserver (non-production) blocking call
# You may need to add $HOST_IP to ALLOWED_HOSTS in project/project/settings.py
#python manage.py runserver $HOST_IP:$HOST_PORT

# Run Django using Apache webserver (production) blocking call
PYTHON_WSGI_MODULE=$DJANGO_PROJECT_NAME.wsgi

# To serve up static content, modify project/project/settings.py:
# STATIC_ROOT = os.path.join(BASE_DIR, 'static')
# Always run this command if any project/app static files are updated
# Note: This will create a subfolder static under the project (current working directory)
# Options --clear and --no-input clears the current static folder without prompts
#python manage.py collectstatic --clear --no-input

# Launch server (Apache)
#mod_wsgi-express start-server --application-type module $PYTHON_WSGI_MODULE --host $HOST_IP --port $HOST_PORT --url-alias /static static &

# Monitor logs
#tail -f /tmp/mod_wsgi-$HOST_IP\:$HOST_PORT\:500/error_log 
