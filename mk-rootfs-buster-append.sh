#!/bin/bash -e

# Directory contains the target rootfs
TARGET_ROOTFS_DIR="binary"
APPEND_ROOTFS_DIR="appends"

if [ ! -e $TARGET_ROOTFS_DIR ]; then
	echo -e "\033[36m Run mk-rootfs-buster.sh first \033[0m"
	exit -1
fi

if [ ! -e $APPEND_ROOTFS_DIR ]; then
	echo -e "\033[36m Make $APPEND_ROOTFS_DIR directory first \033[0m"
	exit -1
fi

finish() {
	sudo umount $TARGET_ROOTFS_DIR/dev
	exit -1
}

sudo cp -rf $APPEND_ROOTFS_DIR/* $TARGET_ROOTFS_DIR/

sudo mount -o bind /dev $TARGET_ROOTFS_DIR/dev
trap finish ERR

cat << EOF | sudo chroot $TARGET_ROOTFS_DIR
while true; do
#######################################################
# Fill out additional commands
#######################################################



#######################################################
echo $VERSION_NUMBER-$VERSION > /etc/version
echo "Finished"
break
done

EOF

sudo umount $TARGET_ROOTFS_DIR/dev
