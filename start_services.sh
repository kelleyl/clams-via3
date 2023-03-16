#!/bin/sh
BUILDPROJ=$1

echo "UPDATED VERSION2" # todo refactor into two separate scripts
mkdir -p /data/via_project_server/latest /data/via_project_server/rev /data/via_project_server/revdb /data/via_project_server/log
$VPS_HOME/vps/scripts/create_bucket_folders.sh /data/via_project_server/latest # (run only first time) creates folders 00, 01, .. f2, ff
$VPS_HOME/vps/scripts/create_bucket_folders.sh /data/via_project_server/rev    # (run only first time) creates folders 00, 01, .. f2, ff

$VPS_HOME/vps/cmake_build/via_project_server $HOSTNAME 9669 8 /data/via_project_server/latest /data/via_project_server/rev /data/via_project_server/revdb /data/via_project_server/log &
sleep 10

# generate json project configuration
if [ "$BUILDPROJ" = "build-project" ]
then
    python initialize_via_project.py &
fi
sleep 5

if  [ "$BUILDPROJ" = "build-project" ]
then
  PROJ_ID=$(curl -s --data @project_file.json 'http://${HOSTNAME}:9669' | jq ".pid")
  echo $PROJ_ID >> data/proj_id.txt
  echo $PROJ_ID
fi 

gunicorn app:app -w 4 --threads 4 -b $HOSTNAME:9779

