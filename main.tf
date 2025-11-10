provider "aws" {
    region = "eu-north-1"  
}

resource "aws_instance" "foo" {
  ami           = "ami-05fa00d4c63e32376" # eu-north-2
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}
