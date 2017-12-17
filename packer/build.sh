#!/bin/bash

# Script to build custom AMI

time packer build -debug -var 'aws_region=us-east-1' django_packer.json
