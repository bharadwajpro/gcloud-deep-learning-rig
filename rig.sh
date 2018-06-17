#!/bin/sh
gcloud compute instances create rig-1 \
    --custom-cpu 6 --custom-memory 4 --zone us-central1-c \
    --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
    --metadata-from-file startup-script=startup.sh \
    --preemptible \
&& gcloud compute scp --recurse ./ root@rig-1:/root/app \
&& gcloud compute ssh root@rig-1 -- \
'docker run -it -v ~/app:/app ufoym/deepo:all-py36-jupyter-cpu python3 /app/$1' \
&& gcloud -q compute instances delete rig-1
