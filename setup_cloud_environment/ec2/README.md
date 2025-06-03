## Launch EC2 Instances

Launching Ubuntu, RedHat Enterprise Linux and Windows EC2 Instance in the Public Subnet of the VPC and attaching the previous created Network Interfaces as secondary Network Interface to each of the Instances respectively.


## EC2 Config

### Ubuntu Instance Config

- AMI ID = ami-0e35ddab05955cf57
- Instance Type = t3.micro
- Key Pair = net-boot-pem
- Auto Assign Public IP = Enable
- Security Group = sg-07d680556da04d553
- Storage = 10GiB (gp3) Root volume,3000 IOPS,Not encrypted
- Network Interface ID = eni-066f4c4ad5979d9cd

### RedHat Enterprise Linux Config

- AMI ID = ami-0038df39db13a87e2
- Instance Type = t3.micro
- Key Pair = net-boot-pem
- Auto Assign Public IP = Enable
- Security Group = sg-07d680556da04d553
- Storage = 10GiB (gp3) Root volume,3000 IOPS,Not encrypted
- Network Interface ID = eni-06c1711d1fab49521

### Windows Instance Config

- AMI ID = ami-0266c1f64e2a73942
- Instance Type = t3.medium
- Key Pair = net-boot-pem
- Auto Assign Public IP = Enable
- Security Group = sg-015b61d0b2bc01cdf
- Storage = 30GiB (gp3) Root volume,3000 IOPS,Not encrypted
- Network Interface ID = eni-016f9b4453dd191ca


## EC2 Security Group Rules

### Security Group Rules for Ubuntu and RedHat Enterprise Linux
![Ubuntu and RedHat Enterprise Linux SG](/assets/linux_sg.png)

### Security Group Rules for Windows
![Windows SG](/assets/windows_sg.png)


## Generate CloudFormation Template

Followed the instructions and used Claude to generate CloudFormation Template `template.yaml` and deployment script `deploy_ec2.sh`.


## Visualization with Infrastructure Composer

![EC2 Infra](/assets/ec2_infra.png)


## EC2 Stack

After successful creation EC2 CFN stack.

![EC2 CFN Stack](/assets/ec2_cfn_stack.png)

Check EC2 Console for the 3 Instances created.

![EC2 Instances](/assets/ec2_ins.png)
