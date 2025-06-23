## Forward Proxy

Proxy is a device that can provide connectivity to another network for hosts behind it. 

It is usually used for:

- Security purposes - It provides internet connectivity for the hosts that don't have direct internet connectivity.

- Content filtering - It can be setup to block certain domains.

- Web caching - It has capability to download static content of websites and serve them directly to the hosts that request it, hence saving bandwidth.


### Setup Environment

![Forward Proxy Diagram](/assets/fp_dia.png)

![Forward Proxy Environment](/assets/fp_aws.png)


- Make sure squid is running and has the below configuration.

![Squid Config](/assets/fp_squid.png)

```sh
#Check active squid config
cat /etc/squid/squid.conf | grep -v '^#' | grep -v '^$'
```
Active Config
```text
acl localnet src 10.200.123.128/25      # AWS Private Subnet
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost manager
http_access deny manager
http_access allow localhost
http_access deny to_localhost
http_access deny to_linklocal
include /etc/squid/conf.d/*.conf
http_access allow localnet
http_access deny all
http_port 3128
coredump_dir /var/spool/squid
```

> [!IMPORTANT]
> We need to make sure that we provide our Private Subnet CIDR in the `localnet` config of Squid, so that Squid is connected to our Private Subnet.


### Network Interface

The Network Interfaces for Proxies are work different as they are transfering packets through them because the packets going through the Proxy are not addressed to the Proxy as the Proxy is not the final destination or originator of the traffic that is going through the Proxy.

When implementing Proxy on a cloud we need to make a change on the Network Interface.

![Network Interface Config](/assets/fp_nic.png)

It is necessary to Disable `Source/destination check` on the Network Interface of the EC2 with Squid Proxy.

By default `Source/destination check` is always Enabled as it is kind of a Security feature, as it checks when traffic is coming into the Network Inteface, it is destined for that Network Interface which usually the normal case. But for transitive virtual machines this is a problem, as the packets that are destined for the Internet from the Proxy Client (in our case Windows Server 2025) are not going to be addressed to the Proxy but the Internet or some Website.

So by Disabling `Source/destination check` we are making sure that we are allowing these Network Interface to be transitive to Accept packets and Forward packets that are not destined or directly addressed to that Network Interface.


### Windows Server 2025

- First connect to the Bastion Windows Server from personal system via RDP and then from the Bastion Windows Server connect to the Windows Server 2025 in the Private Subnet via RDP.

![Windows Server Bastion](/assets/fp_win_bastion.png)


- After successful RDP connection it should look like this.

![Windows Server Private](/assets/fp_win_private.png)


- Configure the Private Windows Server to use Squid Proxy, provide the Private IP of the Primary Network Interface of the Ubuntu EC2 which has Squid Proxy running and provide `port 3128`.

![Windows Server Squid Config](/assets/fp_win_pri_squid-1.png)

![Windows Server Squid Config](/assets/fp_win_pri_squid-2.png)


- Open Browser and check what Public IP is showing within the Private Windows Server.

![Windows Server Browser](/assets/fp_win_ip.png)

We can see that the Public IP is of the Ubuntu EC2.

![Ubuntu EC2](/assets/fp_ubuntu_ip.png)
