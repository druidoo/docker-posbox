#!/bin/bash

echo "running patch script...."

v4l2file=/home/odoo/.local/lib/python3.5/site-packages/v4l2.py
v4l2patch=/home/odoo/.resources/iotpatch/.local/lib/python3.5/site-packages/v4l2.py.iotpatch
patch -f --verbose "${v4l2file}" < "${v4l2patch}"
