## Reverse Proxy

Reverse Proxy gets the request from the Client and sends it to the Web Server, the Web Server sends the requested content back and the Reverse Proxy gets it and sends it back to the Client.

![Reverse Proxy Diagram](/assets/rp_dia.png)


### Setup Reverse Proxy

We will setup Reverse Proxy on Ubuntu VM that was previously created on AWS and install Squid to configure it as Reverse Proxy.

```sh
sudo apt install squid -y
```
```sh
sudo systemctl status squid
```

The squid configuration file can be found at `/etc/squid/squid.conf`.

Below is the configuration for squid created using Claude.

```text
#Define the HTTP port for incoming reverse proxy requests
http_port 8080 accel vhost

#Define the Backend Server (Windows Server)
cache_peer 10.200.123.112 parent 80 0 no-query originserver name=iis-server

#Define as ACL for requests to our reverse proxy
acl site dstdomain proxy-demo

#Allow all request to the reverse proxy
http_access allow all

#Route the correct requests to the backend
cache_peer_access iis-server allow site
```

> [!NOTE]
> For Backend Server we will provide the Private IP of the Primary Network Interface.

```sh
sudo systemctl restart squid
```


### Setup Windows Server IIS

We need to turn on and configure Web Services on the Windows Server 2025 that was previously launched on AWS.

We will open **Server Manager** and click on **Add roles and features**.

![Windows Server Manager](/assets/rp_win_ser_man-1.png)

![Windows Server Manager](/assets/rp_win_ser_man-2.png)

![Windows Server Manager](/assets/rp_win_ser_man-3.png)

![Windows Server Manager](/assets/rp_win_ser_man-4.png)


### Personal System Windows

We can optionally on our own system create a DNS for the Reverse Proxy by providing the name from the squid config and Public IP of the Ubuntu EC2 at `C:\Windows\System32\drivers\etc\hosts`.

![Windows Hosts](/assets/rp_win_hosts.png)


### Windows IIS

Make sure IIS is running.

![Windows IIS](/assets/rp_win_iis.png)


### Security Group

We need to open port 8080 on our Ubuntu EC2, so that the Reverse Proxy can recieve requests from outside.

![Security Group](/assets/rp_sg.png)


### Troubleshooting

In the squid config at `/etc/squid/squid.conf` we need to do two more config to prevent Access Denied issue.

![Access Deine Issue](/assets/rp_error.png)

- First add this config

```text
acl Safe_ports port 8080
```

- Secondly comment out line present at **line 1624**

```text
http_access deny all
```

And restart squid.

![Windows IIS Page](/assets/rp_iis_page.png)
