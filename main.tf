provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "demovpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
      Name = "Demo"
      terraformed = "Yes"
    }
}

resource "aws_subnet" "demosubnet" {
    vpc_id = "${aws_vpc.demovpc.id}"
    cidr_block =  "10.1.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "Demo_subnet"
        terraformed = "yes"
    }
}

resource "aws_internet_gateway"  "IGW" {
  vpc_id = "${aws_vpc.demovpc.id}"
  tags = {
      Name = "Demo_IGW"
      terraformed = "Yes"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.demovpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.IGW.id}"
  }


}

resource "aws_route_table_association" "Public-route" {
  subnet_id = "${aws_subnet.demosubnet.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_key_pair" "krishna_keys" {
  key_name   = "krishnakeys"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcU1AXIkeSOYkJuGgjd++M8q5eox1arQ5cesF0pmZp5HMugqnqlO8B27bs8rTgjHFfEMCmU9bQm3jg98i9SjvA0CuPOl8tJiHec6Oq0oW35d5Asiufwy/Arx5xLLGXbfw8ZPqNBZKSH43pehNxmwrKWnCZH9OSp55BaZVWdszPQAzEFg1Z2qy0VyrzEQyrSmRTvIAboMM+9AxoVl2iZlGcpgSaxH1nCPZ98mK5T37/iC455/cEX3jm/YjTJoSgWRQxLU9Ft/f0NHpEWHTOSrspDhPec6HDPO+42m9avwDsgTP7tnCw2iwx+XWbPGNwb7Ydhvh5M8lW5hx6HJ3tMi29"

}

resource "aws_instance" "Ubuntu" {
  ami          = "ami-04125d804acca5692"
  instance_type = "t2.micro"
  key_name = "krishnakeys"
  subnet_id = "${aws_subnet.demosubnet.id}"
  
  tags = {
    Name = "ubuntu Instance"
  }
}
