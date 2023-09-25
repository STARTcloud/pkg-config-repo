#!/usr/bin/ksh

# Check if we've finished
. /lib/svc/share/smf_include.sh
if [ "$(/usr/bin/svcprop -p config/assembled $SMF_FMRI)" == "true" ] ; then
  exit $SMF_EXIT_OK
fi
svccfg -s $SMF_FMRI setprop config/assembled = true
svccfg -s $SMF_FMRI refresh

echo "configureing system, please wait"

#add the title-bar name
if [ $(grep -c $'echo "\033]0;$(hostname)\007"' /etc/profile) -lt 1 ]
then
  echo 'echo "\033]0;$(hostname)\007" ' >> /etc/profile
fi

svcadm enable vtdaemon '*console-login:vt*'

sync
#create new BE
beadm create omnios-final
beadm mount omnios-final /mnt

#update system
pkg -R /mnt update -f

  #install software
if [ -f "/install" ]
then
  </install xargs pkg -R /mnt install
  rm /install
fi

beadm unmount omnios-final
beadm activate omnios-final

sync
echo "rebooting after config..."
init 6