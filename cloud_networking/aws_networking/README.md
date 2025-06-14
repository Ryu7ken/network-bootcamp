## VPC Setup

We will setup 2 VPCs with 2 Availability Zones and 2 Subnets per Availability Zones. Also 1 NAT Gateway on one of the Availability Zones.


### VPC

After creating the 2 VPCs, it should be like in the below images.

![VPC1](/assets/vpc-1.png)

![VPC2](/assets/vpc-2.png)


### Subnet

The Public Subnets have routing to the Internet Gateway and the Private Subnets have routing to the NAT Gateway.

![Public Subnet](/assets/public-subnet.png)

![Private Subnet](/assets/private-subnet.png)


## VPC Peering

VPC Peering enables traffic flow between 2 VPCs staying within the AWS Network, eliminating the need to go to other VPC via the Public Internet.

- First we will send Peering request from VPC ryu to VPC ken and VPC ken has to accept the Peering request.

![VPC Peering Console](/assets/vpc_peering-ryu.png)

![Accept Peering](/assets/vpc_peering_accept-ryu.png)


- We will add routing for traffic flow between *ryu-subnet-private2-ap-south-1c* and *ken-subnet-private1-ap-south-1c*. So we will add routing in the *ryu-rtb-private2-ap-south-1c* route table and *ken-rtb-private1-ap-south-1c* route table.

![Peering Routing](/assets/vpc_peering_routing-ryu.png)

![Peering Routing](/assets/vpc_peering_routing-ken.png)
