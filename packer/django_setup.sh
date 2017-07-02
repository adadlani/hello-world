#!/bin/bash -e

# This script is run on the EC2 Instance on first boot-up as user ec2-user
# Note ec2-user is on the sudo-ers list

# Time to build AMI:  ~12 Minutes
# Once AMI is launched, it takes about 15 seconds to serve up the default Django page

# Note: Packer has uploaded all files in $UPLOADS_DIR before this executes

echo "Hello world!" > $HOME/packer.log
echo $USER >> ./packer.log

# Install system level updates using YUM
sudo yum update -y
sudo yum install git gcc wget httpd-devel -y

# Base locations and other constants
UPLOADS_DIR=$HOME
PYTHON_INSTALL_DIR=$HOME/anaconda3
PIP_REQUIREMENTS=$UPLOADS_DIR/requirements.txt
DJANGO_PROJECT_NAME=mysite
DJANGO_PROJECT_HOST_PORT=8080

# Install dummy hello world page
sudo touch /var/www/html/index.html
sudo sh -c 'echo "<html><h1>Hello world</h1></html>" > /var/www/html/index.html'

# Allow ports 80 & 443
sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport $DJANGO_PROJECT_HOST_PORT -j ACCEPT
sudo sh -c 'iptables-save | tee /etc/sysconfig/iptables'

# Start the service to auto-start at bootup
sudo chkconfig httpd on

# Best to have Anaconda uploaded to the AMI so we dont have to download it each
# time which can slow things down!
chmod a+x $UPLOADS_DIR/Anaconda3-4.4.0-Linux-x86_64.sh
bash $UPLOADS_DIR/Anaconda3-4.4.0-Linux-x86_64.sh -b -p $PYTHON_INSTALL_DIR

# Setup environment to pick up latest Python/PIP
export PATH=$PYTHON_INSTALL_DIR/bin:$PATH
echo "export PATH=$HOME/anaconda3/bin:$PATH" >> $HOME/.bashrc

# Install Python dependencies
pip install -r $PIP_REQUIREMENTS

# Create sample Django project and perform initial setup
django-admin startproject $DJANGO_PROJECT_NAME
cd $DJANGO_PROJECT_NAME
python manage.py migrate

# To serve up static content, modify project/project/settings.py:
echo "STATIC_ROOT = os.path.join(BASE_DIR, 'static')" >> $DJANGO_PROJECT_NAME/settings.py
# Always run this command if any project/app static files are updated
# Note: This will create a subfolder static under the project (current working directory)
# Options --clear and --no-input clears the current static folder without prompts
python manage.py collectstatic --clear --no-input


# ALLOWED_HOSTS = ['1.2.3.4', 'localhost', 'name.compute-1.amazonaws.com']
sed -i '/^ALLOWED_HOSTS/ c\import requests;r = requests.get('\'http://169.254.169.254/latest/meta-data/public-hostname\''); ALLOWED_HOSTS = [r.text]' $DJANGO_PROJECT_NAME/settings.py

# Install init.d service script
# Destination on target:  /etc/init.d/django
sudo cp $UPLOADS_DIR/django_init_script /etc/init.d/django
sudo chmod a+x /etc/init.d/django
sudo chkconfig --add django
sudo chkconfig django on

echo "Done!" >> $HOME/packer.log