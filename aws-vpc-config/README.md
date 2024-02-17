# aws-vpc-config



### Overview
In this project, I demonstrate how to provision a secure and scalable AWS VPC infrastructure using Terraform. A VPC is a fundamental building block for any AWS environment, providing isolated networking resources within the AWS cloud.

### Features
- **Network Segmentation**: Utilize Terraform to define multiple subnets within the VPC, enabling logical segmentation of resources based on security and performance requirements.
- **Internet Gateway**: Configure an internet gateway to allow public access to resources within the VPC, while maintaining control over inbound and outbound traffic.
- **Route Tables **: Define custom route tables to route traffic between different subnets and the internet. Use Terraform to manage route propagation and association with subnets.
- **Network Access Control Lists (NACLs)**: Implement NACLs to control traffic at the subnet level, providing an additional layer of security beyond security groups.
- **Security Groups**: Define security groups to control inbound and outbound traffic to EC2 instances and other resources within the VPC.


### Getting Started
To deploy the AWS VPC infrastructure using Terraform:
1. Clone this repository to your local machine.
2. Install Terraform CLI (https://learn.hashicorp.com/tutorials/terraform/install-cli).
3. Configure AWS credentials with appropriate permissions (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
4. Navigate to the project directory and run `terraform init` to initialize the Terraform working directory.
5. Customize the `terraform.tfvars` file with your desired configurations (e.g., VPC CIDR block, subnet configurations, etc.).
6. Run `terraform plan` to preview the changes that will be applied.
7. Run `terraform apply` to create the AWS VPC infrastructure.

### Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!
