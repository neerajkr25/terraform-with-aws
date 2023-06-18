Steps to create infra 
1- Run below commands 
    terraform init
    terraform plan
    terraform apply --auto-approve
It will create a workload vpc / Transit vpc / IAM role for pipeline / 
2- Fetch the PrivateSubnet ID from console and provide it to the varibales in EKS module 
3- Rerun the Step number 1 
4- Create Pipeline for Infra As Code in Code build and attach it to the AWS code pipeline
Note:- Use devops-cicd-role for all code build and code pipeline. 

================================
Terraform note :- Terraform can crash mid-apply. If this happens and your AWS session has expired, it might not be able to write to S3. The are other errors as well that may prevent Terraform from writing the updated state to the configured backend.
To allow for recovery, the state may be written to the file errored.tfstate in the current working directory.

#terraform state push errored.tfstate