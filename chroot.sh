#!/bin/bash

scriptdir() {                                                          ┊       │
    local SCRIPTPATH=$(realpath "$0")
    SCRIPTDIR=$(dirname "$SCRIPTPATH")
    echo "$SCRIPTDIR"
}

getMediaDevice() {
  pp=$( mount -l | grep media | awk '{ print $1 }' )
  echo "$pp"
}

getMediaMount() {
  pp=$( mount -l | grep media | awk '{ print $3 }' )
  echo "$pp"
}

if [ "$1" == "" ]; then
    src=$( getMediaDevice )
    media=$( getMediaMount )
else
    src="$1"
fi

target="/mnt/otherlinux"
curdir=$( scriptdir )
tools="${curdir}/rescue"
clear

if [ "$src" == "" ]; then
    src="/dev/sdb2"
fi

echo "[[ $media ]]"
echo "[[ $curdir ]]"
echo "[[ $tools ]]"
echo "[$src]"
echo "[$target]"


if [ ! -e "$target" ]; then
  echo creating $target
  mkdir -p "$target/rescue"
fi

cmd=" sudo  umount  $src "
echo $cmd
eval $cmd

cmd=" sudo  mount  $src  ${target} "
echo $cmd
eval $cmd


for dev in /dev /dev/pts /proc /sys /run; do
  cmd="sudo mount --bind $dev  ${target}${dev} "
  echo $cmd
  eval $cmd
done

cmd="sudo mount --bind $tools  ${target}/mnt/rescue "
echo $cmd
eval $cmd

echo
echo /mnt/rescue
echo
echo -n "Host system : "; uname -nr
echo

cmd=" sudo  chroot  ${target} "
echo $cmd
echo
eval $cmd
echo

cmd=" sudo  umount -Rf   ${target} "
echo $cmd
eval $cmd
echo

if [ "$media" == "malo" ]; then 
    cmd=" sudo mount ${src} ${media} "
    echo $cmd
    eval $cmd
fi


