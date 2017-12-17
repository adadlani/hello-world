#!/bin/env python

# Script to generate JSON data (Ananconda Python 3.x)
# This implementation calls an endpoint that returns a joke in JSON and writes
# it to a user specified logger

# System imports
import json
import requests
import syslog

# Default output filename
output_filename = './jokes.json'

# Get a joke
API = 'http://api.icndb.com/jokes/random'
response = requests.get(API)

# Write to logger
syslog.syslog(syslog.LOG_INFO | syslog.LOG_LOCAL5, response.text)