#!/bin/bash

sudo yum update -y
sudo yum install python3.11 python3.11-pip -y
python3.11 -m pip install --upgrade pip
python3.11 -m pip install fastapi uvicorn

cat <<EOT > /home/ec2-user/main.py
$(cat main.py)
EOT

# uvicorn main:app --reload --host=0.0.0.0
# python3.11 /home/ec2-user/main.py
