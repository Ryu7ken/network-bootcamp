## VPC Settings

These are the VPC settings for the cloud environment in AWS:

- IPv4 CIDR block - 10.200.123.0/24
- IPv6 CIDR block - NO
- 1 public subnet
- 1 private subnet
- Single AZ
- No VPC endpoint
- No NAT gateways
- Enable DNS Hostname
- Enable DNS Resolution


## Generate VPC CloudFormation Template

Followed the instructions and used Claude to generate CloudFormation Template `template.yaml` and deployment script `vpc_cfn_script.sh`.


## VPC Visualization using Infrastructute Composer

Not the best representation.

![VPC](/assets/vpc_infra.png)


## VPC Stack 

After successful creation of VPC CFN stack.

![CFN Stack](/assets/vpc_cfn_stack.png)

Check VPC console for this.

![VPC](/assets/vpc.png)
