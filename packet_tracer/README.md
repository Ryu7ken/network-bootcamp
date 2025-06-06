## Simulating A Network

In Cisco Packet Tracer we have to have to simulate a networking using a PC, Swtich, Router and Server. The Server needs to be configured to act as an DHCP server.


### Setting up the Network Environment

![Network](/assets/pckt_net.png)


### Configuring the Router

Followed the instructions to do the necessary configurations and bring UP the Router.

![Router](/assets/pckt_router.png)


### Configuring the Server

Followed the instructions to configure DHCP service on the Server.

![DHCP Server Global Settings](/assets/pckt_server_global.png)

![DHCP Server FastEthernet Settings](/assets/pckt_server_fasteth.png)


### Configuring the Server for DHCP Service

We avoid changing the Pool Name as the default Pool that is provided cannot be removed so creating another pool causes conflicts. So just configuring the Pool that is provided by default gets the work done.

![DHCP Service](/assets/pckt_server_dhcp.png)


### Trigger Packet Generation from PC

We need to run the command `ipconfig /renew` to generate a **Broadcast** packet from the PC.

![PC Broadcast](/assets/pckt_pc.png)


> [!NOTE]
> With DHCP there will be 4 steps involved known as DORA (Discover, Offer, Request and Acknowledge).


The PC generates a Discover Message.

![Discover Message](/assets/pckt_discover.png)


The Switch recieves the Discover Message and knows that its a Broadcast.

![Switch with Broadcast](/assets/pckt_switch_broadcast.png)


The Switch forwards the Broadcast to all the other ports that is alive except the port from which it recieved the Message.

![Broadcast Recieved by Router and Server](/assets/pckt_broadcast_sent.png)


The Server sends back Offer Message which is also a Broadcast as the PC doesn't have an IP.
![Offer Message](/assets/pckt_offer.png)


The PC after recieving the Offer Message sends out a Request Message which is also a Broadcast destined to the Server.

![Request Message](/assets/pckt_request.png)


The Server finally sends out Acknowledge Message for the PC and the PC gets an IP Address assigned to it.

![Acknowledge Message](/assets/pckt_acknowledge.png)

![PC IP Address](/assets/pckt_pc_ip.png)
