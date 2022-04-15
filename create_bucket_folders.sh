#!/bin/sh
# downloaded from https://gitlab.com/vgg/vps/-/blob/master/scripts/create_bucket_folders.sh
# For VIA project server, create all the required folders

current=0
end=255

for i in $(seq 0 255);
do
  #echo $i
  x=$(printf "%.2x\n" $i)
  echo $1"/"$x
  mkdir $1"/"$x
done
