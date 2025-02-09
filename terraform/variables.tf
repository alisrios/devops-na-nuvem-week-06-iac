
variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "devops-na-nuvem-week"
  }
}

variable "aws_provider" {
  type = object({
    region = string,
    assume_role = object({
      role_arn = string
    })
  })

  default = {
    region = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::148761658767:role/TerraformAssumeRole"
    }
  }
}

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string
    nat_gateway_eip_name     = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    })),
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })

  default = {
    cidr_block               = "10.0.0.0/24"
    name                     = "devops-na-nuvem-week-vpc"
    internet_gateway_name    = "internet-gateway"
    nat_gateway_name         = "nat-gateway"
    public_route_table_name  = "public-route-table"
    private_route_table_name = "private-route-table"
    nat_gateway_eip_name     = "nat-gateway-eip"
    public_subnets = [{
      name                    = "public-subnet-us-east-1a"
      cidr_block              = "10.0.0.0/26"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      },
      {
        name                    = "public-subnet-us-east-1b"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
    }]
    private_subnets = [{
      name                    = "private-subnet-us-east-1a"
      cidr_block              = "10.0.0.128/26"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
      },
      {
        name                    = "private-subnet-us-east-1b"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = false
    }]
  }
}


variable "eks_cluster" {
  type = object({
    name      = string
    role_name = string
    access_config = object({
      authentication_mode = string
    })
    enabled_cluster_log_types = list(string)
    version                   = string
    node_group = object({
      role_name      = string
      name           = string
      capacity_type  = string
      instance_types = list(string)
      scaling_config = object({
        desired_size = number
        max_size     = number
        min_size     = number
      })
    })
  })

  default = {
    name      = "devops-na-nuvem-week-eks-cluster"
    role_name = "DevOpsNaNuvemWeekEksClusterRole-06"
    access_config = {
      authentication_mode = "API_AND_CONFIG_MAP"
    }
    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    version                   = "1.31"
    node_group = {
      role_name      = "DevOpsNaNuvemWeekEksClusterNodeGroupRole-06"
      name           = "devops-na-nuvem-week-eks-node-group"
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
      scaling_config = {
        desired_size = 2
        max_size     = 2
        min_size     = 2
      }
    }
  }
}

variable "repositories" {
  type = list(object({
    name                 = string
    image_tag_mutability = string
  }))

  default = [{
    name                 = "devops-na-nuvem-week/production/backend"
    image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "devops-na-nuvem-week/production/frontend"
      image_tag_mutability = "MUTABLE"
  }]
}
