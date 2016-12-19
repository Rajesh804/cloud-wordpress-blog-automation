provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY_ID}"
    secret_key = "${var.AWS_SECRET_ACCESS_KEY}"
    region = "${var.aws_region}"
}
resource "aws_security_group" "default" {
    name = "WordpressSG-${var.APP_NAME}-${var.USER_NAME}"
    description = "Used by instance hosting Wordpress docker environment"
    tags {
        Name = "wp-docker-sg-${var.APP_NAME}-${var.USER_NAME}"
    }
    vpc_id = "${var.vpc_id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Open HTTP
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Outbond rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "web" {
  name = "wordpress-elb-${var.APP_NAME}-${var.USER_NAME}"

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  subnets = ["${var.subnet_id}"]
  security_groups = ["${aws_security_group.default.id}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:8080"
    interval = 5
  }
  tags {
        Name = "wp-docker-elb-${var.APP_NAME}-${var.USER_NAME}"
    }

  # Lets add our instances 
  instances = ["${aws_instance.web.*.id}"]
}

resource "aws_instance" "web" {

  instance_type = "${var.SERVER_SIZE}"
  count = "${var.NUM_SERVERS}"
  # AMI to be used
  ami = "${var.aws_amis}"
  # SSH keypair to use
  key_name = "${var.key_name}"
  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  # Subnet id to use
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  tags {
        Name = "wp-docker-ec-${var.APP_NAME}-${var.USER_NAME}"
    }

}
