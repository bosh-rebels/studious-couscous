#!/bin/bash

wget https://github.com/EngineerBetter/control-tower/releases/download/0.16.30/control-tower-linux-amd64
mv control-tower-linux-amd64 /usr/local/bin/
sudo mv control-tower-linux-amd64 /usr/local/bin/
sudo chmod +x /usr/local/bin/control-tower-linux-amd64
wget https://github.com/cloudfoundry/bosh-cli/releases/download/v6.4.4/bosh-cli-6.4.4-linux-amd64
sudo mv bosh-cli-6.4.4-linux-amd64 /usr/local/bin/
wget https://releases.hashicorp.com/terraform/1.0.3/terraform_1.0.3_linux_amd64.zip
unzip terraform_1.0.3_linux_amd64.zip
rm terraform_1.0.3_linux_amd64.zip
sudo mv terraform /usr/local/bin/