## Ubuntu Networking Configurations

We explored the various commands to check the Networking Settings and Configurations using the CLI.


### Network Interfaces

![Ubuntu Network Config](/assets/ubun_net.png)


- MTU/MRU - Maximum Transmission Unit/Maximum Receive Unit is the measurement of data in a Network Packet.

According to RFC 4638, the Ethernet header frame defaults to 1500 Bytes, but here it is set to 9001 Bytes which is Jumbo Frames.


> [!IMPORTANT]
> In AWS when sending data between Regions, to defaults back to 1500 Bytes from 9001 Bytes. (More info at AWS Documentation)


> [!TEXT]
> How does different MTU size matter ?
> Having a MTU of 1500 Bytes usually means less bandwidth consumption and faster transfer of data which can be beneficial like during phone calls. And having Jumbo frames of 9001 Bytes means packing more data within a Network Packet in one go.


- Qlen - The transmission queue length is the amount of packets that can be in queue when a lot a network packets a being generated and when the limit is reached then the generated packets start to drop without being added to the queue.


### IP Route Table

The host uses the IP Route Table to look from which interface it needs to send the network packets.

![IP Route Table](/assets/ubun_route.png)


- Metric - It is used to determine which Network Interface will be used as default to send out Network Packets.


> [!NOTE]
> The Metric as a plays an important role because when a host has more than one Network Interface and we are sending out Network Packets from the host to some other machine and if we are sending out Network Packets randomly using both the Network Interface rather than consistently using the same Network Interface , the other machine will assume that the traffic is coming from two different hosts, though its the same host than is sending traffic.


### Manually Adding New IP Address to Secondary Interface

![Secondary IP on Secondary Interface](/assets/ubun_ip.png)

But this process is temporary and the New IP Address will be removed on system reboot. To make the configurations that we do persistent, we need to use `netplan`.

![Netplan](/assets/ubun_netplan.png)


Configuration changes made in the file at `/etc/netplan/50-cloud-init.yaml` are persistent.

![Netplan Config](/assets/ubun_netplan_conf.png)

After setting new config run the command `sudo netplan try` to check if the configurations are correct and then apply it.

![Netplan New Config](/assets/ubun_netplan_new_conf.png)

