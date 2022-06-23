#!/bin/bash

# Install and configure the necessary dependencies
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Add the GitLab package repository and install the package
 curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash


sudo EXTERNAL_URL="http://gitlab.manrodri.com" apt-get install gitlab-ee
###