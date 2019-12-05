#/!/bin/bash
OSDS="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdj /dev/sdk /dev/sdl /dev/sdm"
read -p "'Warning, this will destroy all data, make user targetlist is correct!"

for i in $OSDS; do
 parted -s $i mklabel gpt mkpart primary xfs 0% 100% 
 mkfs.xfs $i -f
 blkid -o value -s TYPE $i
done
