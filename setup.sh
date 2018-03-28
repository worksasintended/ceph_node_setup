#!/bin/bash
HOSTS="supervisor"
OSDS="/dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn"
CEPH_PATH="/root/ceph_setup/ceph-deploy-1.5.39"

echo "hosts: $HOSTS"
echo "osds: $OSDS"

read -p "Press enter to install software"

cd ../ceph_data


#install software
$CEPH_PATH/ceph-deploy new $HOSTS
echo "osd crush chooseleaf type = 0" >> ceph.conf
echo "osd_pool_default_size = 2" >> ceph.conf
echo "public_network = 10.0.0.0/24" >> ceph.conf
echo "cluster_network = 10.0.0.0/24" >> ceph.conf
#echo "public_network = 11.11.11.0/24" >> ceph.conf
#echo "cluster_network = 11.11.11.0/24" >> ceph.conf
echo "max_open_files = 131072" >> ceph.conf
$CEPH_PATH/ceph-deploy install --release luminous $HOSTS

read -p "Press enter to create mon"

# create monitor
$CEPH_PATH/ceph-deploy mon create-initial
read -p "Press enter to copy data"

#copy keys and configuration
$CEPH_PATH/ceph-deploy admin $HOSTS
read -p "Press enter to create mgr"

#create manager
$CEPH_PATH/ceph-deploy mgr create $HOSTS
read -p "Press enter tozap ad create osds"

#create osd
for i in $OSDS; do
 $CEPH_PATH/ceph-deploy disk zap $HOSTS:$i 
 $CEPH_PATH/ceph-deploy osd create $HOSTS:$i 
done
read -p "Press enter to create pool"

#create ceph pool
ceph osd pool create rbd 64
read -p "Press enter to add cepfs"
#create cephfs
ceph osd pool create cephfs_data 64
ceph osd pool create cephfs_metadata 64
ceph fs new ceph_data cephfs_metadata cephfs_data
$CEPH_PATH/ceph-deploy  mds  create supervisor

cd ../ceph_setup 
