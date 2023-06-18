# IAM for EKS

resource "aws_iam_role" "eks-iam-role" {
 name = "dev-eks-cluster-iam-role"

 path = "/"

 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF
}

# Attach policy to it 

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}

# Create the cluster 

resource "aws_eks_cluster" "dev-eks" {
 name = "dev-cluster"
 role_arn = aws_iam_role.eks-iam-role.arn
 
 

 vpc_config {
  subnet_ids = var.private_subnet_ids
  endpoint_private_access = true
  endpoint_public_access  = true
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

# Setup IAM role for worker nodes 

resource "aws_iam_role" "workernodes" {
  name = "eks-worker-node-group"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.workernodes.name
 }

 # Create worker nodes 

  resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.dev-eks.name
  node_group_name = "dev-workernodes"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = var.private_subnet_ids
  instance_types  = ["t3.medium", "t3.large"]  # Add the spot instance type(s) here
  capacity_type = "SPOT"

  tags = {
    Name = "workernode"
  }

 
  scaling_config {
   desired_size = 3
   max_size   = 5
   min_size   = 2
  }

  remote_access {
    ec2_ssh_key          = "dev-workernode-key"
  }
  
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }
