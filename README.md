This repository contains a docker deployable version of the VIA (v3) tool.
The media data should be mounted using the same configuration as standard CLAMS applications. 

Running the Via Project Server

[//]: # (- clone this repository)

[//]: # (- ```git clone kelleyl/clams-via3```)

- The first time you run the server, first create a directory for the via project data to be stored. 
- ```mkdir -p via_data/via_project_server/latest via_data/via_project_server/rev via_data/via_project_server/revdb via_data/via_project_server/log```

- Create the necessary folders for storing project data. The project files are stored on the host machine.
- ```./create_bucket_folders.sh via_data/via_project_server/latest && ./create_bucket_folders.sh via_data/via_project_server/rev && ./create_bucket_folders.sh via_data/via_project_server/log```

Initialize a VIA Project from the media directory. 
note: currently only the video files are added to the project.
- ```./initialize_via_project path/to/media/data```

- Build the project server.
- ```docker build . -t vps```

- Next mount the via_data directory and the media directory when running the docker container. 
- ```docker run -d -p 9669:9669 -p 9779:9779  -v via_data:data -v path/to/media/data:static vps```

If it is the first time running the tool with the dataset, include the argument build-project. 
- ```docker run -d -p 9669:9669 -p 9779:9779  -v via_data:data -v path/to/media/data:static vps build-project```

The files in the media directory are mounted to a directory inside the container named `static`. The files from this directory will be served on port 9779.
