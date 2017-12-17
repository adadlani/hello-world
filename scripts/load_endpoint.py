#!/bin/env python

# Script to keep requesting an end point for load testing

import requests
import time

while(True):
    r = requests.get ('http://django-tutorial-dev1.us-east-1.elasticbeanstalk.com/')
    r.content
