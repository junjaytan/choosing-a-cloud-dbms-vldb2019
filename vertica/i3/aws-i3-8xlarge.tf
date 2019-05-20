provider "aws" {
  shared_credentials_file = "PATH/TO/YOURCREDSFILE"
  region     = "us-east-1"
}

# Note: THERE is a terraform bug that prevents you from launching
# nvme instance stores correctly, so have to launch this manually at the moment
# see: https://github.com/hashicorp/terraform/issues/12738
resource "aws_instance" "vertica-i3-8xlarge" {
  # Red Hat Enterprise Linux 7.3 (HVM)
  ami = "ami-9e2f0988"
  count = 4
  instance_type = "i3.8xlarge"
  availability_zone = "us-east-1a"
  key_name = "YOUR_SSH_KEY"
  placement_group = "vertica-i3"
  subnet_id = "YOUR_SUBNET_ID"
  vpc_security_group_ids = ["YOUR_VPC_ID"]
  ebs_optimized = false

  root_block_device {
    volume_size = 25
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    volume_size = 250
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ephemeral_block_device {
    device_name = "/dev/sdj"
    virtual_name = "ephemeral0"
  }

  ephemeral_block_device {
    device_name = "/dev/sdk"
    virtual_name = "ephemeral1"
  }

  ephemeral_block_device {
    device_name = "/dev/sdl"
    virtual_name = "ephemeral2"
  }

  ephemeral_block_device {
    device_name = "/dev/sdm"
    virtual_name = "ephemeral3"
  }

  tags {
    Name = "vertica-i38xlarge-${count.index}"
    Owner = "YOURNAME"
    Description = "i3 10GB network"
    class = "verticai38xl"
  }
}
