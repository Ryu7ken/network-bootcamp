## Cisco DevNet CML Sandbox

Unfortunately will not be moving forward with the DevNet CML Sandbox as it has restrictions.

Since I already had a RedHat Enterprise Linux 9 VM on my Oracle VirtualBox, so thought to move forward with it.


## Oracle VirtualBox VM

The VM Networking settings should be set to Bridged Adapter.

![Oracle VM](/assets/oracle_vm.png)


## AWS VPN Console

First we need to setup Customer Gateway and Virtual Private Gateway to setup a Site-to-Site VPN Connection.


### Customer Gateway

Let the **BGP ASN** be default (65000) and for **IP address** provide your own Public IP which can be found through `curl whatismyip.akamai.com`.

![Customer Gateway](/assets/vpn_cg.png)

- **BGP ASN** - Border Gateway Protocol (BGP) is the routing protocol that the internet runs on and is the only protocol that we can use on the cloud. BGP uses the concept of autonomous system numbers to identify the systems that are connecting to each other.

Here we want the BGP to act in a certiain way, so we are going to make it external BGP and its external when two sides of the BGP has different autonomous system numbers, so they recognise each other as members of a different organization.


### Virtual Private Gateway

Let the **Autonomous System Number (ASN)** be set to **Amazon default ASN**.

![Virtual Private Gateway](/assets/vpn_vpg.png)

- **ipsec** - It means encrypted tunnel connectivity between two end points and it is cryptographically encrypted inside the tunnel. Inside the tunnel Private IP Addresses will be used but on the outside there is a Header on top of the Private Address which is the Public Address.


### Site-to-Site VPN Connection

Select the **Virtual private gateway** and the **Customer gateway**. And for the **Routing options** select **Static** and provide the Network CIDR of the VM. No configuration needed for all the *optional*.

![VPN Connection](/assets/vpn_conn.png)

![VPN Connection Console](/assets/vpn_conn_console.png)

- Now select the VPN Connection and **Download Configuration** as below.

![VPN Config](/assets/vpn_config.png)


### Configuring RHEL9 VM

I used Claude to guide me throughout the configuration of my RHEL9 VM.

- We need to install necessary tools to proceed with the VPN Connectivity.

```sh
sudo dnf update
sudo dnf install strongswan strongswan-charon-nm -y
```

- Start the `firewalld` service if its not started.

```sh
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-service=ipsec
sudo firewall-cmd --permanent --add-port=4500/udp
sudo firewall-cmd --permanent --add-port=500/udp
sudo firewall-cmd --permanent --add-masquerade
sudo firewall-cmd --reload
```

- When facing issues with starting `firewalld`, checking if the SELinux is set to `Enforcing` can be an issue. To change to `Permissive` will solve the issue.

```sh
#Check status
getenforce

#Change Status
setenforce 0
```

- We also need to enable IP forwarding.

```sh
sudo sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
```

- We need to start and enable **strongSwan**.

```sh
sudo systemctl start strongswan
sudo systemctl enable strongswan
```

- With the previously downloaded VPN Configuration we need to create config file for **strongSwan**.

```sh
sudo mkdir -p /etc/strongswan/swanctl/conf.d
```
```sh
sudo vim /etc/strongswan/swanctl/swanctl.conf
```
```text
connections {
    aws-tunnel-1 {
        version = 2
        local_addrs = 192.168.1.15
        remote_addrs = 13.126.215.141
        local {
            auth = psk
            id = 184.23.59.111
        }
        remote {
            auth = psk
            id = 13.126.215.141
        }
        children {
            aws-tunnel-1 {
                local_ts = 192.168.1.0/24
                remote_ts = 10.200.123.0/24
                esp_proposals = aes256gcm16-modp2048
                dpd_action = restart
                start_action = start
                close_action = restart
                mode = tunnel
            }
        }
        proposals = aes256gcm16-sha384-modp2048
        dpd_delay = 10s
        dpd_timeout = 30s
    }
}

secrets {
    ike-1 {
        id = 184.23.59.111
        secret = "Shqu0pSstcMHD7H2YZEaMQtbcfNWIj1n"
    }
}
```

- Check if all the IP route are correct.

```text
[baquiur@localhost ~]$ ip route show
default via 192.168.1.254 dev enp0s3 proto dhcp src 192.168.1.15 metric 100
192.168.1.0/24 dev enp0s3 proto kernel scope link src 192.168.1.15 metric 100
```

- Loading the new configuration and starting the tunnel.

```sh
# Reload the configuration
sudo swanctl --load-all

# Initiate the first tunnel
sudo swanctl --initiate --child aws-tunnel-1

# Check status
sudo swanctl --list-sas
```


### VPC Private Subnet

We need to enable **Route Propagation** in the Private Subnet Route Table and the VM Network CIDR will automatically show up on the Private Subnet Route Table.

![VPC Subnet](/assets/vpn_prop-1.png)

![VPC Subnet](/assets/vpn_prop-2.png)

- **Route Propagation** - This is used to import routes from third party sources into the Subnet Route Table.


### EC2 Security Group

We need to add the VM Network CIDR to the EC2 Security Group.

![EC2 Security Group](/assets/vpn_ec2_sg.png)


### Testing VPN Connection

Now if we `ping` to the EC2 instance on the Private Subnet we will be able to reach it.

```text
[baquiur@localhost ~]$ ping 10.200.123.233
PING 10.200.123.233 (10.200.123.233) 56(84) bytes of data.
64 bytes from 10.200.123.233: icmp_seq=1 ttl=64 time=43.2 ms
64 bytes from 10.200.123.233: icmp_seq=2 ttl=64 time=42.7 ms
64 bytes from 10.200.123.233: icmp_seq=3 ttl=64 time=43.0 ms
64 bytes from 10.200.123.233: icmp_seq=4 ttl=64 time=43.7 ms
64 bytes from 10.200.123.233: icmp_seq=5 ttl=64 time=43.3 ms
64 bytes from 10.200.123.233: icmp_seq=6 ttl=64 time=43.4 ms
64 bytes from 10.200.123.233: icmp_seq=7 ttl=64 time=42.8 ms
64 bytes from 10.200.123.233: icmp_seq=8 ttl=64 time=43.0 ms
^C
--- 10.200.123.233 ping statistics ---
8 packets transmitted, 8 received, 0% packet loss, time 7015ms
rtt min/avg/max/mdev = 42.728/43.141/43.701/0.306 ms
```

### Terminate Tunnel and Stop strongSwan

```sh
sudo swanctl --terminate --child aws-tunnel-1

sudo systemctl stop strongswan
```
