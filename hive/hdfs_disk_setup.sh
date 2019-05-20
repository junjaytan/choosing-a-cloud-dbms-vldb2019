#/bin/bash


parallel-ssh -h slaves.txt -o sshout/ -e ssherr/ -v -x "-o StrictHostKeyChecking=no -i YOUR-SSH-KEY.pem" "sudo mkdir /hadoop"
parallel-ssh -h slaves.txt -o sshout/ -e ssherr/ -v -x "-o StrictHostKeyChecking=no -i YOUR-SSH-KEY.pem" "sudo mdadm --create --verbose /dev/md0 --level=stripe --raid-devices=8 /dev/xvd[b-i]"

parallel-ssh -h slaves.txt -o sshout/ -e ssherr/ -v -x "-o StrictHostKeyChecking=no -i YOUR-SSH-KEY.pem" "sudo mkfs -t ext4 /dev/md0"
parallel-ssh -h slaves.txt -o sshout/ -e ssherr/ -v -x "-o StrictHostKeyChecking=no -i YOUR-SSH-KEY.pem" "sudo mount /dev/md0 /hadoop"

parallel-ssh -h slaves.txt -o sshout/ -e ssherr/ -v -x "-o StrictHostKeyChecking=no -i YOUR-SSH-KEY.pem" "sudo chown -R ubuntu:ubuntu /hadoop"
parallel-ssh -h slaves.txt -o sshout/ -e ssherr/ -v -x "-o StrictHostKeyChecking=no -i YOUR-SSH-KEY.pem" "sudo chmod -R 0777 /hadoop"
