## Load Balancer

### Why Load Balance ?

When there are multiple web servers and we want to send client requests to all the web severs and not just one web server we need a Load Balancer that will distribute the client requests equally to all the web servers without overwhelming one web server.


## DNS Load Balancing

When we have multiple web server located across the globe like in North America, Europe, Asia and we would want the client to go to that web server closest to them for the best possible experience.

DNS Load Balancing is one of the oldest and still the most common way to Load Balance.

The Client would send request to as the DNS Server for the IP of `example.com`. The DNS Server can be configured to return the web server IP in different ways, it can be round robin or geographics. Here it would be geographic and it would see the Client is from US, so it would provide the IP of the web server in North America.

![DNS LB](/assets/lb_dns.png)


### TLS Termination on Load Balancer

TLS Encryption is Certificate based encryption and these Certificates contains information that is signed my Certificate Authority to validate it.

In this example the Client has an encrypted connection to the HAProxy Load Balancer, and the TLS terminates on HAProxy. Then HAProxy is connected to the Web servers in the Backend with unencrypted connection and can also do Health Checks to indentify which web servers are active.

**Why TLS Termination on Load Balancer ?**

- Reduce the load on Web servers for decryption.
- To get visibility on the requests for various reasons. 

![TLS on LB](/assets/lb_tls.png)


### TLS Termination on Server

In this example the connection between the Client and HAProxy as well as the connection between HAProxy and the Web servers are encrypted as the TLS Termination take place on the Web servers.

**Why TLS Termination on Servers ?**

- Due to regulation reasons.
- Maybe connection between HAProxy and Web servers is not trusted as it may go over third-party network for some reason.

In this case the HAProxy is severely limited on the information it can use for Load Balancing as it can't see the Client payload.

![TLS on Server](/assets/lb_server_tls.png)


### TLS Termination on Load Balancer with Re-Encryption to Server

In this example the TLS Termination happens on HAProxy and again Re-Encrypting happens on HAProxy before going to the Web servers.

**Why TLS Termination on Load Balancer with Re-Encryption to Server ?**

- Load Balancer gets visibilty on the Client payload for better load balancing decisions.


## Application Load Balancer

With Application Load Balancer we can load balance based on Application traffic. 

In the example the HAProxy sees the request for *web2* server so it sends the request to *web2* servers only.

![ALB](/assets/lb_alb.png)


## Network Load Balancer

Network Load Balancer only uses Network Layer information (layer 3 and layer 4) like IP Address and Port numbers to make routing decisions.

This is generally not used for Websites.

In the example as the Client sends request for *web2* server and if Load Balancer only does Network Layer load balancing, it might load balance to the wrong server like the *web1* server.

![NLB](/assets/lb_nlb.png)
