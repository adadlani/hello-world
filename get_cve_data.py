# Script to import CVE data from NIST https://nvd.nist.gov/vuln/data-feeds#JSON_FEED
# https://static.nvd.nist.gov/feeds/json/cve/1.0/nvdcve-1.0-modified.json.gz

import gzip
import json
import pycurl
from io import BytesIO

NVD_CVE_ENDPOINT = 'https://static.nvd.nist.gov/feeds/json/cve/1.0/nvdcve-1.0-modified.json.gz'
DATA_FILE = './data.json.gz'

with open(DATA_FILE, 'wb') as fd:
	c = pycurl.Curl()
	c.setopt(c.URL, NVD_CVE_ENDPOINT)
	c.setopt(c.WRITEDATA, fd)
	c.perform()

if c.getinfo(c.RESPONSE_CODE) != 200:
	print('data request failed')
	exit(1)

# Close Curl
c.close()

# Test: Ensure we received a valid gzip file

# Extract gzip and load JSON to in-memory
with gzip.open(DATA_FILE, 'rt') as fd:
	data = json.load(fd)

# Read in-memory JSON structure keys
#	CVE_data_version
#	CVE_data_format
#	CVE_Items
#	CVE_data_timestamp
#	CVE_data_numberOfCVEs
#	CVE_data_type
print('CVE_data_version:', data['CVE_data_version'])
print('CVE_data_format:', data['CVE_data_format'])
print('CVE_data_timestamp:', data['CVE_data_timestamp'])
print('CVE_data_numberOfCVEs:', data['CVE_data_numberOfCVEs'])
print('CVE_data_type:', data['CVE_data_type'])

count = 0
for item in data['CVE_Items']:
	if 'cve' in item:
		if 'CVE_data_meta' in item['cve']:
			if 'ID' in item['cve']['CVE_data_meta']:
				#print(item['cve']['CVE_data_meta']['ID'])
				count = count + 1
