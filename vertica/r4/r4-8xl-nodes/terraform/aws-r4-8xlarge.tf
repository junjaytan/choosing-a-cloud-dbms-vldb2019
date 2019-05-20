provider "aws" {
  shared_credentials_file = "PATH/TO/YOURCREDSFILE"
  region     = "us-east-1"
}

resource "aws_instance" "vertica-r4-8xlarge" {
  # Vertica 9.0.1 Centos 7.4 AMI
  ami = "ami-22e69f58"
  count = 1 
  instance_type = "r4.8xlarge"
  availability_zone = "us-east-1a"
  key_name = "YOUR_SSH_KEY"
  placement_group = "vertica-r48xl"
  subnet_id = "YOUR_SUBNET_ID"
  vpc_security_group_ids = ["YOUR_VPC_ID"]
  ebs_optimized = true

	# This is required for the vertica AMI
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 20
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdc"
    volume_size = 512
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdd"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sde"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdi"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdj"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdk"
    volume_size = 200
    volume_type = "gp2"
    #iops = 3000
    delete_on_termination = true
  }

  tags {
    Name = "vertica-r4-8xlarge-${count.index}"
    Owner = "YOURNAME"
    Description = "r4 8xl using vertica AMI"
    class = "verticar48xl"
  }
}
