## Windows Networking Configurations

We explored the different ways to check the Networking Settings and Configurations using the UI and then via the Command Prompt.

### Ethernet/Network Interfaces

![Windows Nic](/assets/win_net.png)

### Primary Ethernet Configurations

![Windows Primary Ethernet](/assets/win_net_eth-1.png)

### Secondary Ethernet Configurations

![Windows Secondary Ethernet](/assets/win_net_eth-2.png)


- **Hyperplane** - Its an abstraction layer that has been created by CSPs that exists between the actual Physical Hardwares and the Customers using the cloud.


- **DHCP** - Dynamic Host Control Protocol helps assign an IP Address to the Network Interface automatically from the CIDR range of the Subnet (Public or Private) in which the Network Interface was created.

Since we are using AWS, so AWS already has a service running in our VPC which is acting as the DHCP server.


- **Lease Obtained & Lease Expires** - These timings determine when the IP Address was provided by the DHCP server to a host and also determines when the assigned IP Address will expire, so that the host can request for new IP Address and a new **Lease Obtained & Lease Expires** timing is provided by the DHCP server to the host.


- **Default Gateway** - Its the gateway that is used when we want to out of our network. It is usually the Routers.


- **Subnet Mask** - Each of the Host within the network use this to know is the other device that they want to communicate with is within the same network or not. If within the same network they will be able to communicate directly, otherwise the have to go to the **Default Gateway**.


> [!IMPORTANT]
> **10.200.123.0**: VPC Network Address.
> **10.200.123.0** - 10.200.123.127: Public Subnet
> **10.200.123.128** - 10.200.123.255: Private Subnet
> 
> *For Public Subnet*
> **10.200.123.1**: Reserved by AWS for the VPC router.
> **10.200.123.2**: Reserved by AWS. The IP address of the DNS server is the base of the VPC network range plus two.
> **10.200.123.3**: Reserved by AWS for future use.
> **10.200.123.127**: Network broadcast address (not used, but still reserved)
> **10.200.123.4 - 10.200.123.126**: Usable IPs
> 
> *For Private Subnet*
> **10.200.123.129**: Reserved by AWS for the VPC router.
> **10.200.123.130**: Reserved by AWS. The IP address of the DNS server is the base of the VPC network range plus two.
> **10.200.123.131**: Reserved by AWS for future use.
> **10.200.123.255**: Network broadcast address (not used, but still reserved)
> **10.200.123.132 - 10.200.123.254**: Usable IPs


### Manually Changing Secondary Ethernet IP Address from UI

The Secondary Ethernet is part of the Private Subnet (10.200.123.128/25) of the VPC.

**Before Manual Configuration**

![Secondary Ethernet Config](/assets/win_net_before.png)

**After Manual Configuration**

![Secondary Ethernet Manual Config](/assets/win_net_after.png)


### Network Configuration from Command Prompt

We can check the network configs from the Command Prompt as well using command `ipconfig`.

![Windows Netowork Config in CMD](/assets/win_cmd-1.png)

To get more details of the Network configs use the command `ipconfig /all`.

![Windows Netowork Config in CMD](/assets/win_cmd-2.png)


- **IP Routing Enabled** - This determines if the server will recieve network packets to pass it to some other machine.
