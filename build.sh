#!/bin/bash
set -e

SCRIPT=$(python -c "import os; print(os.path.realpath('$0'))")
SCRIPT_DIR=`dirname "$SCRIPT"`

virtualenv ansible
. ansible/bin/activate
pip install -r "$SCRIPT_DIR"/requirements.txt
deactivate
virtualenv --relocatable ansible

cd ansible/lib/python2.6/site-packages/ansible
patch -p0 < "$SCRIPT_DIR"/ansible-site-packages.patch
