#!/bin/bash -ex

touch ~/hello.txt
yum install -y httpd
cd /var/www/html
echo '<html><body>Hello world</body></html>' > index.html
service httpd start