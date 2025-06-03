## Creating New Network Interface

New Network interface is required for the EC2 instances to the networking configurations changes and practice without affecting the main Network Interface of the EC2 instances. Otherwise it would cause issues in connecting with the EC2 instances if done on the main Network Interface. ALso the new Network Interface will be in the private subnet of the our VPC.


## Network Interface Config

- Network Interface for 3 EC2 instances - Ubuntu, RedHat Enterprise Linux, Windows Server 2025.
- Network Interface should be in private subnet (10.200.123.128/25).
- Security Group with Inbound rules set to `All traffic` for the source `10.200.123.0/24`.


## Generate CloudFormation Template

Followed the instructions and used Claude to generate CloudFormation Template `template.yaml` and depoyment script `deploy_nic.sh`.


## Visualization with Infrastructure Composer

![Network Interface](/assets/nic_infra.png)


## Network Interface Stack

After successful creation Network Interface CFN stack.

![Nic CFN Stack](/assets/nic_cfn_stack.png)

Check EC2 console for the 3 Network Interfaces created.

![Ubuntu Network Interface](/assets/Net-Ubuntu.png)

![RedHat Network Interface](/assets/Net-RedHat.png)

![Windows Network Interface](/assets/Net-Windows.png)

Check the EC2 console or the VPC console for the Security Group of the Network Interfaces.

![Network Interface SG](/assets/nic_sg.png)
