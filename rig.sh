#!/bin/sh
gcloud compute instances create rig-1 \
    --custom-cpu 6 --custom-memory 6 --zone us-central1-c \
    --image=cos-stable-67-10575-55-0 --image-project=cos-cloud \
    --metadata=startup-script="docker pull ufoym/deepo:all-py36-jupyter-cpu" \
    --preemptible \
&& gcloud compute scp --zone us-central1-c --recurse ./ rig-1:~/app \
&& gcloud compute ssh --zone us-central1-c rig-1 -- \
"docker run -it -v ~/app:/app ufoym/deepo:all-py36-jupyter-cpu python3 /app/$1" \
&& gcloud -q compute instances delete rig-1 --zone us-central1-c
