#!/bin/sh
BUILDPROJ=$1

$VPS_HOME/vps/cmake_build/via_project_server 0.0.0.0 9669 8 /data/via_project_server/latest /data/via_project_server/rev /data/via_project_server/revdb /data/via_project_server/log &
sleep 10

# generate json project configuration
if [ "$BUILDPROJ" = "build-project" ]
then
    python initialize_via_project.py &
fi
sleep 5

if  [ "$BUILDPROJ" = "build-project" ]
then
  PROJ_ID=$(curl -s --data @project_file.json 'http://0.0.0.0:9669' | jq ".pid")
  echo $PROJ_ID >> /data/proj_id.txt
#  PROJ_ID=$(curl -s --data @project_file.json 'http://0.0.0.0:9669' | python -c "import sys, json; l = ' '.join(sys.stdin.readlines()); print(l); print (json.loads(l)['pid'])")
#  STRS=$(read -a arr <<< "$PROJ_ID")
#  echo ${STRS[-1]}

  # modify load project in via app
#  LOADSUB="<script>
#                       _via_load_submodules = function(){
#                           _via_share.pull(${PROJ_ID});
#                       }
#                   </script>"
#  echo $LOADSUB >> /via/via-3.0.11/via_video_annotator.html
fi

gunicorn app:app -w 4 --threads 4 -b 0.0.0.0:9779

