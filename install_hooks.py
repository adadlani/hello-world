#!/bin/env python

# Script to install hooks

import glob
import os

# Get all files in ./hooks
cwd = os.getcwd()
hooks = glob.glob(cwd + '/hooks/*')

# Sym link to ./.git/hooks
for hook in hooks:
    print(hook)
    os.symlink(hook, cwd + '/.git/hooks/' + os.path.split(hook)[1])
