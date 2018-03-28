#!/bin/bash
HOSTS=supervisor
ceph-deploy purge $HOSTS
ceph-deploy purgedata $HOSTS
ceph-deploy uninstall $HOSTS
ceph-deploy forgetkeys
rm -rf ../ceph_data/*
