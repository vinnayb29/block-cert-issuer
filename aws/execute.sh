#!/bin/bash

# Refer read me file for more details on how to setup in AWS

sudo rm -rf /home/ec2-user/sample_data

#Copy sample_data to EC2
aws s3 cp s3://<bucketname>/test .  --recursive

#generate the certificate
sudo docker run -it -v /home/ec2-user/sample_data:/etc/data  <ECR hostname>/laur/block-cert-issuer:1.0 /bin/bash

#push changed files to s3
aws s3 sync sample_data s3://<bucketname>/test/sample_data