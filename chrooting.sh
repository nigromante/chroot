#!/bin/bash

scriptdir() {                                                          ┊       │
    local SCRIPTPATH=$(realpath "$0")
    SCRIPTDIR=$(dirname "$SCRIPTPATH")
    echo "$SCRIPTDIR"
}

src="/dev/sdb2"
target="/mnt/otherlinux"
curdir=$( scriptdir )
tools="${curdir}/rescue"
clear


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

cmd=" sudo  umount -Rf   ${target} "
echo $cmd
eval $cmd


