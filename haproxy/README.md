## HAProxy

We will use the Ubuntu EC2 on which we will install Containerlab to create a lab environment consisting of HAProxy and two Apache Web Servers. The Haproxy will be connfigured to Load Balance using the Round-Robin algorithm. We will access the web page served by Apache Web Servers from Windows Server 2025 by sending request to the HAProxy Container IP.

![AWS Environment](/assets/hap_dia.png)


## Containerlab Setup

- First we need to add the Containerlab repository.

```sh
echo "deb [trusted=yes] https://netdevops.fury.site/apt/ /" | sudo tee -a /etc/apt/sources.list.d/netdevops.list
```


- Update the package repositories, then install Containerlab and Docker.

```sh
sudo apt update
sudo apt install containerlab docker.io -y
```

### Launching Containers

We will use the `haproxy.clb.yaml` file to launch the Containerlab environment.

- `haproxy-new.cfg` contains the configuration for the HAProxy.

- `proxy-startup.sh` configures the HAProxy with the new config file and makes sure its running correctly.

- `replace-index.sh` check for the HTML files and copies them to the `/var/www/html` directory to be served by Apache Web Server.

- `setup-ssh.sh` install OpenSSH and starts it to provide access to the containers via SSH rather than relying on Docker. Also creates a new user and password for it.

```sh
#To start the Contianerlab environment creation
containerlab deploy
```


### Troubleshooting

- After the container were created I was not able to SSH into any of the containers as it kept showing error.

```text
ubuntu@ip-10-200-123-39:~$ ssh demo@172.20.20.2
ssh: connect to host 172.20.20.2 port 22: Connection refused
```

- I used Docker to attach into the containers and found the SSH service not running which caused to error. So manually enabled SSH service on the contaners.


```text
ubuntu@ip-10-200-123-39:~$ sudo docker ps -a
CONTAINER ID   IMAGE                               COMMAND                  CREATED         STATUS         PORTS     NAMES
745fc0efbc4f   ubuntu/apache2:latest               "apache2-foreground"     6 minutes ago   Up 6 minutes   80/tcp    clab-basic-haproxylab1-web1
f057b3bb70f9   haproxytech/haproxy-ubuntu:latest   "/docker-entrypoint.…"   6 minutes ago   Up 6 minutes             clab-basic-haproxylab1-haproxy
f9bfceaf2a10   ubuntu/apache2:latest               "apache2-foreground"     6 minutes ago   Up 6 minutes   80/tcp    clab-basic-haproxylab1-web2

ubuntu@ip-10-200-123-39:~$ sudo docker exec -it 745 /bin/bash

root@web1:/# service ssh status
 * sshd is not running

root@web1:/# service ssh start
 * Starting OpenBSD Secure Shell server sshd                                                                                                  [ OK ]

root@web1:/# service ssh status
 * sshd is running
```


- Now successfully able to SSH into the containers.

![Container SSH](/assets/hap_ssh.png)


### Windows Route Table

- We need to add a routing for the Containerlab environment network (172.20.20.0/24) as the Windows Server is not aware of it. We will use the Secondary Network Interface that is in the Private Subnet.

```sh
route add 172.20.20.0 mask 255.255.255.0 10.200.123.129 IF 8
```


- Check is the Route is added correctly.

![Windows Route Table](/assets/hap_win_route.png)


### AWS VPC Private Subnet Route Table

- We also need to add the Containerlab network routing in the Private Subnet Route Tables as well, so that the Windows Server can send packets to the Private Network Interface of the Ubuntu EC2 to view the Web pages.

![Private Route Table](assets/hap_ps_rt.png)


- We also need to Disable `Source/destination check` on the Secondary Network Interface of the Ubuntu EC2, so that the packets sent for the Containerlab network are not dropped.

![Private NIC](assets/hap_ps_nic.png)


- We can see the Web page and also the HAProxy Round-Robin in action.

![Web Page](assets/hap_page-1.png)

![Web Page](assets/hap_page-2.png)
