#!/bin/bash
set -e

SCRIPT=$(python -c "import os; print(os.path.realpath('$0'))")
SCRIPT_DIR=`dirname "$SCRIPT"`
RPM_RELEASE=1

VENV_DIR=$(mktemp -d)

trap "rm -rf $VENV_DIR" EXIT SIGINT SIGTERM

# Create a relocatable virtualenv for ansible
cd "$VENV_DIR"
virtualenv ansible
. ansible/bin/activate
pip install -r "$SCRIPT_DIR"/requirements.txt
deactivate
virtualenv --relocatable ansible

cd ansible/lib/python2.6/site-packages/ansible
patch -p0 < "$SCRIPT_DIR"/ansible-site-packages.patch

# Setup the directory structure for the RPM
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR"/opt

cp -ap "$VENV_DIR"/ansible "$TMPDIR"/opt/
cd "$TMPDIR"

find . -name "*.pyc" -delete

mkdir -p usr/local/bin
cd usr/local/bin

for f in {ansible,ansible-playbook,ansible-doc}; do
    ln -s ../../../opt/ansible/bin/$f .
done

# Use FPM to build an RPM
cd /vagrant
fpm -s dir -t rpm -n ansible -v 1.4.0 --iteration $RPM_RELEASE -C "$TMPDIR" \
    -p ansible-FULLVERSION.ARCH.rpm \
    -d "postgresql-devel" \
    -d "python-devel" \
    usr/local/bin opt
