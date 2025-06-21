## Network Address Translation

### Why NAT?

- To preserve the limited number of IPv4 Addresses.

- To provide connectivity between networks that use the same IPs.

- To obscure networks (This is different than true security).


## Static NAT

![STATIC NAT](/assets/nat_static.png)

Assume that there was no NAT between the two Networks, the packet originating from the *Server* in *Network 1* would have Destination IP as `10.10.10.50`. The packet will never reach *Network 2* because the Destination IP is same network as *Network 1* and the packet might even go to one of the system that might have the IP `10.10.10.50` within *Network 1*.


- The Client in *Network 1* wants to send a packet to Server in *Network 2*. So the packet has a Destination IP of the NAT Device that gets the packet.

![Packet NAT in Network 1](/assets/nat_static-1.png)


- The NAT Device after receiving the packet changes the Source IP with its own IP according to *Network 2*, so that it will receive the reply back from the Server then send it back to the Client on *Network 1* and the Destination IP with the actual Server IP.

![Packet NAT in Network 2](/assets/nat_static-2.png)


## NAT Pool

- ISP Perspective - The objective of NAT Pool is to Load Balance the Client traffic between ISPs to prevent overwhelming a single ISP.

![ISP NAT Pool](/assets/nat_isp.png)


- Cloud Perspective - In the Cloud there is more Client device than the IPs. In this example the NAT device will create mapping as traffic goes through it. It will map an internal Client IP to one of the Public IP from the NAT Pool and also append a Port Number to it and this Port Number is written in a NAT Table. This way the NAT Device can keep track which IP form the NAT Pool and Port Number is associated with which Internal Client.

![Cloud NAT Pool](/assets/nat_cloud.png)


## PAT/NAT Overload

Port Address Translation / Network Address Translation Overload is usually seen in Home or Office Networks.

- Translate ALL internal addresses to 1 Public IP.

- Use Port numbers to track connections.

- Most common with home internet.

![PAT/NAT Overload](/assets/nat_overload.png)


## Cisco DevNet

In Cisco Modeling Sandbox we see with the help of Packet Capture how the NAT happens.


- We will do Packet Capture between the Swtich (iosvl2) and the Router (cat8000v), then run `ping 8.8.8.8` on the Alpine VM.

We can see in the Packet Capture the Source IP is of the Alpine VM.

![Alpine IP Packet](/assets/nat_alpine.png)


- Now we will do Packet Capture between the Router (cat8000v) and the External Connection (ext-conn), then again run `ping 8.8.8.8` on Alpine VM.

We can now see NAT in action as we see the Source IP is of the Router and not the Alpine VM.

![Router IP Packet](/assets/nat_router.png)
