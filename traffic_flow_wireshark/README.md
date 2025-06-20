## Cisco DevNet

Starting a Cisco Modeling Lab Sandbox on DevNet and importing the `cml-vpn-lab.yaml` file into the Lab.


- Releasing the IP on Alpine VM.

![IP Release](/assets/wire_vm.png)


- Start Packet Capture between the Alpine VM and Switch (iosvl2) and initiate a DHCP DORA from the Alpine VM to the Router (cat8000v).

![Packet Capture](/assets/wire_pak_cap.png)

After IP is received from DHCP, stop the Packet Capture and download it.


## Wireshark

Wireshark is a Packet capture and Packet capture analysis tool.


### CML Packet Capture Analysis

- Open the downloaded Packet capture file from CML Sandbox.

![Wireshark](/assets/wire_download.png)


- Filter out only the DHCP Protocol

![DHCP](/assets/wire_dhcp.png)


### Live Packet Capture

- We turn on a Ubuntu VM on VMware Workstation Pro and select its Network Adapter on Wireshark and filter by `icmp`.

`ping 8.8.8.8` from the Ubuntu VM and start the Packet Capture on Wireshark.

![Ubuntu VM](/assets/wire_ubuntu.png)

![Network Adapter and Filter](/assets/wire_net_filter.png)

![Live Packet Capture](/assets/wire_live.png)

We can see in the Live capture that the Source IP is of the Ubuntu VM from where we are running `ping 8.8.8.8`.


### Wireshark Capture Options

![Capture Options](/assets/wire_options.png)

- **Create a new file automatically...** - with this option we can create new file after every certain amout of **time** or **packet** or **size**.

- **Use a ring buffer** - after creating 'x' number of files it starts overwriting the previous files.
