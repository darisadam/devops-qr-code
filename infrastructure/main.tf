module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "qr-code-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # For cost saving in dev/test. Set false for high availability prod.
  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Project     = "devops-qr-code"
  }
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~>20.0"

    cluster_name = "qr-code-project"
    cluster_version = "1.32"

    cluster_endpoint_public_access = true

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    control_plane_subnet_ids = module.vpc.private_subnets

    eks_managed_node_groups = {
        green = {
            min_size = 1
            max_size = 1
            desired_size = 1
            instance_type = ["t3.medium"]
        }
    }
}