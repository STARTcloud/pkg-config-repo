#!/usr/bin/ksh

# Check if we've finished
. /lib/svc/share/smf_include.sh
if [ "$(/usr/bin/svcprop -p config/assembled $SMF_FMRI)" == "true" ] ; then
  exit $SMF_EXIT_OK
fi

svccfg -s $SMF_FMRI setprop config/assembled = true
svccfg -s $SMF_FMRI refresh

echo "Fixing home directories"

# remove path from default user profile
sed -i '/PATH/d' /etc/skel/.profile

# remove /home from automounter control
if grep -v "^#" /etc/auto_master | grep -q auto_home
then
  svcadm disable autofs
  sed -i '/^\/home/ s/^/#/' /etc/auto_master
  svcadm enable autofs
fi

#make /home a zfs filesystem
#  the global zone ignores the mountpoint property because the zoned property is
#  set in filesystems created in zones

# guest zones MUST have this as a sub-filesystem under ROOT,
# the global zone SHOULD have it as a sibling of ROOT
if smf_is_globalzone
then
        rootpath=$(mount -p | sed -n '/ \/ / s/\([^[:space:]\/]*\)\/[^[:space:]]* - \/ .*/\1/p')
else
        rootpath=$(mount -p | sed -n '/ \/ / s/\([^[:space:]]*\)\/[^[:space:]]* - \/ .*/\1/p')
fi

if [ $(zfs list -o mountpoint | grep -c /home) -eq 0 ]
then
    zfs create -o mountpoint=/temphome -o compression=on -o atime=off ${rootpath}/home
    mv /home/* /temphome >/dev/null 2>&1
    rmdir /home
    zfs set mountpoint=/home ${rootpath}/home
fi

#useradd should create ZFS filesystems for each user
sed -i 's/MANAGE_ZFS=NO/MANAGE_ZFS=YES/' /etc/default/useradd
