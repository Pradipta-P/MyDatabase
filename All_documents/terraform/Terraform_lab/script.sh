#!/bin/bash
apt-get update
apt-get install -y apache2
echo "Testing from terraform" > /var/www/html/index.html
service apache2 start
