#!/bin/bash
INSTANCE_IP=$(terraform output private_ip)
echo "$INSTANCE_IP" > my_ec2_IP.txt
