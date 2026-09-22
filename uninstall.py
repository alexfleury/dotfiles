#!/usr/bin/env python

from __future__ import print_function

import sys
import yaml
import os

if len(sys.argv) != 2:
    sys.exit("Usage: {} <config.yaml>".format(sys.argv[0]))

CONFIG = sys.argv[1]

with open(CONFIG, "r") as stream:
    conf = yaml.safe_load(stream)

for section in conf:
    if "link" in section:
        for target in section["link"]:
            realpath = os.path.expanduser(target)
            if os.path.islink(realpath):
                print("Removing ", realpath)
                os.unlink(realpath)
                