resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0c55b159cbfafe1f0" # Example AMI, replace as needed
  instance_type          = var.instance_type
  key_name               = var.key_name
  security_groups        = var.security_group_ids
  subnet_id              = var.subnet_id

  root_block_device {
    volume_size = var.ebs_volume_size
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = data.aws_availability_zone.current.name
  size              = var.ebs_volume_size
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.ec2_instance.id
}
