# Eon mode with data loaded into s3 from original raw tables.
provider "aws" {
  shared_credentials_file = "PATH/TO/YOURCREDSFILE"
  region     = "us-east-1"
}

resource "aws_instance" "vertica-r4-8xlarge" {
  # Vertica 9.1.0-3 Red Hat 7.4
  ami = "ami-fc742183"
  count = 4 
  instance_type = "r4.8xlarge"
  availability_zone = "us-east-1a"
  key_name = "jjtalum-aws"
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

  tags {
    Name = "vertica-eon-r4-8xlarge-${count.index}"
    Owner = "YOURNAME"
    Description = "r4 8xl using vertica AMI eon"
    class = "verticar48xleon"
  }
}
