import json
import os

BASE_URL = "http://0.0.0.0:9779"

project = {}
media_files = {}
for _id, _file in enumerate(os.listdir("/media/video")):
    if _file.startswith("."):
        continue
    media_files[f"{_id}"] = {
        "fid": f"{_id}",
        "fname": _file,
        "type": 4,
        "loc": 2,
        "src": f"{BASE_URL}/media/video/{_file}"
    }

via_project = {
    "pid": "__VIA_PROJECT_ID__",  # these markers must be present
    "rev": "__VIA_PROJECT_REV_ID__",
    "rev_timestamp": "__VIA_PROJECT_REV_TIMESTAMP__",
    "vid_list": list(media_files.keys()),
    "pname": "generated project"
}
project["project"] = via_project
project["file"] = media_files
project["view"] = {f"{_id}": {"fid_list": [f"{_id}"]} for _id in media_files.keys()}
project["config"] = {
    "file": {
        "loc_prefix": {
            "1": "",
            "2": "",
            "3": "",
            "4": ""
        }
    },
    "ui": {
        "file_content_align": "center",
        "file_metadata_editor_visible": True,
        "spatial_metadata_editor_visible": True,
        "temporal_segment_metadata_editor_visible": True,
        "spatial_region_label_attribute_id": "",
        "gtimeline_visible_row_count": "4"
    }
}
if os.path.isfile(os.path.join("data", "annotation.json")):
    with open(os.path.join("data", "annotation.json")) as conf_file:
        project['attribute'] = json.load(conf_file)

else:
    project['attribute'] = {
    }

project['metadata'] = {}
with open("project_file.json", 'w') as out:
    out.write(json.dumps(project))  ##todo 3/26/22 kelleylynch fix me
    print (project["project"]["pid"])