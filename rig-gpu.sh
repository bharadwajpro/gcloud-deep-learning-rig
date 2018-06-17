#!/bin/sh
gcloud compute instances create rig-1 \
    --custom-cpu 4 --custom-memory 6 --zone us-central1-c \
    --accelerator type=nvidia-tesla-k80,count=1 \
    --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
    --metadata-from-file startup-script=startup-gpu.sh \
    --preemptible \
&& gcloud compute scp --recurse ./ root@rig-1:/root/app \
&& gcloud compute ssh root@rig-1 -- \
'docker run -it -v ~/app:/app ufoym/deepo:all-jupyter python3 /app/$1' \
&& gcloud -q compute instances delete rig-1
