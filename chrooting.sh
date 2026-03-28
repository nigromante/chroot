#!/bin/bash


src="/dev/sdb2"
echo "[$src]"

target="/mnt/otherlinux"
echo "[$target]"


if [ ! -e "$target" ]; then
  echo creating $target
  mkdir -p $target
fi

cmd=" sudo  umount  $src "
echo $cmd
eval $cmd

cmd=" sudo  mount  $src  ${target} "
echo $cmd
eval $cmd

uname -nr

eval "sudo mount --bind /dev      $target/dev"
eval "sudo mount --bind /dev/pts  $target/dev/pts"
eval "sudo mount --bind /proc     $target/proc"
eval "sudo mount --bind /sys      $target/sys"
eval "sudo mount --bind /run      $target/run"

cmd=" sudo  chroot  ${target} "
echo $cmd
eval $cmd

cmd=" sudo  umount -Rf   ${target} "
echo $cmd
eval $cmd


