# call vpc module to create vpc 
module "workload-vpc" {
  source = "../../modules/workload-vpc"
}


# Create transit VPC
module "transit-vpc" {
    source = "../../modules/transit-vpc"
}



# Create EKS cluster
module "uat-cluster" {
    source = "../../modules/eks"
    private_subnet_ids = module.workload-vpc.private_subnet_ids
}