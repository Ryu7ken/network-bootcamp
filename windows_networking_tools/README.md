## Cloud Environment

The Windows Server 2025 is running on an EC2 instance in AWS and accessing it via RDP.

![Windows Server 2025](/assets/windows.png)


## Windows Networking Tools

### ipconfig

`ipconfig /?` shows all the options.


- Clearing previous local DNS Caches.

```text
C:\Users\Administrator>ipconfig /flushdns

Windows IP Configuration

Successfully flushed the DNS Resolver Cache.
```


### ping

`ping /?` shows all the options.


- Persistent pinging.

```text
C:\Users\Administrator>ping -t www.exampro.co

Pinging www.exampro.co [18.239.111.125] with 32 bytes of data:
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249

Ping statistics for 18.239.111.125:
    Packets: Sent = 9, Received = 9, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms
Control-C
^C
```


- Resolving address to hostname

```text
C:\Users\Administrator>ping -a 18.239.111.125

Pinging server-18-239-111-125.bom54.r.cloudfront.net [18.239.111.125] with 32 bytes of data:
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249
Reply from 18.239.111.125: bytes=32 time<1ms TTL=249

Ping statistics for 18.239.111.125:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms
```


- Increase the size of ping packets

```text
C:\Users\Administrator>ping -l 1100 www.exampro.co

Pinging www.exampro.co [18.239.111.106] with 1100 bytes of data:
Reply from 18.239.111.106: bytes=1100 time<1ms TTL=249
Reply from 18.239.111.106: bytes=1100 time<1ms TTL=249
Reply from 18.239.111.106: bytes=1100 time<1ms TTL=249
Reply from 18.239.111.106: bytes=1100 time<1ms TTL=249

Ping statistics for 18.239.111.106:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms
```


- Prevent fragmenting for packets greater than 1500 mtu.

When sending packets larger than the default 1500 mtu, then packets are fragmented before being sent out. This option prevents the fragmenting.

```text
C:\Users\Administrator>ping -f -l 1800 www.exampro.co

Pinging www.exampro.co [18.239.111.63] with 1800 bytes of data:
Packet needs to be fragmented but DF set.
Packet needs to be fragmented but DF set.
Packet needs to be fragmented but DF set.
Packet needs to be fragmented but DF set.

Ping statistics for 18.239.111.63:
    Packets: Sent = 4, Received = 0, Lost = 4 (100% loss),
```


- Set Time To Live(TTL)

When we want to reach a target machine with fixed max number of hops we can use TTL for it. The reply that we receive will be from the last machine where till where the hop reached because on every hop the TTL we provide keeps decrease by 1. 

```text
C:\Users\Administrator>ping -i 4 www.google.com

Pinging www.google.com [142.250.70.36] with 32 bytes of data:
Reply from 142.251.225.207: TTL expired in transit.
Reply from 142.251.225.207: TTL expired in transit.
Reply from 142.251.225.207: TTL expired in transit.
Reply from 142.251.225.207: TTL expired in transit.

Ping statistics for 142.250.70.36:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
```


### tracert

`tracert /?` shows all the options.


- Trace hops to domain

`tracert` can help in troubleshooting if there is some issue with some device on the network.

```text
C:\Users\Administrator>tracert www.google.com

Tracing route to www.google.com [142.250.183.36]
over a maximum of 30 hops:

  1     *        *        *     Request timed out.
  2     *        *        *     Request timed out.
  3     2 ms     2 ms     2 ms  99.82.180.91
  4     2 ms     1 ms     1 ms  142.251.225.29
  5     2 ms     1 ms     1 ms  142.250.62.153
  6     2 ms     2 ms     2 ms  bom12s11-in-f4.1e100.net [142.250.183.36]

Trace complete.
```


### nslookup

- Check the DNS

```text
C:\Users\Administrator>nslookup
Default Server:  ip-10-200-123-2.ap-south-1.compute.internal
Address:  10.200.123.2
```


- Check details of other Domain

```text
> www.cnn.com
Server:  ip-10-200-123-2.ap-south-1.compute.internal
Address:  10.200.123.2

Non-authoritative answer:
Name:    cnn-tls.map.fastly.net
Addresses:  2a04:4e42:24::773
          151.101.155.5
Aliases:  www.cnn.com
```


- Change DNS

```text
> server 8.8.8.8
Default Server:  dns.google
Address:  8.8.8.8

> www.cnn.com
Server:  dns.google
Address:  8.8.8.8

Non-authoritative answer:
Name:    cnn-tls.map.fastly.net
Addresses:  2a04:4e42::773
          2a04:4e42:200::773
          2a04:4e42:600::773
          2a04:4e42:400::773
          151.101.3.5
          151.101.131.5
          151.101.195.5
          151.101.67.5
Aliases:  www.cnn.com
```


### netstat

`netstat /?` shows all the options.


- Check active connections

```text
C:\Users\Administrator>netstat

Active Connections

  Proto  Local Address          Foreign Address        State
  TCP    10.200.123.112:3389    42.110.170.205:2245    ESTABLISHED
  TCP    10.200.123.112:57694   4.213.25.242:https     ESTABLISHED
```


- Check for applications that are active

```text
C:\Users\Administrator>netstat -b

Active Connections

  Proto  Local Address          Foreign Address        State
  TCP    10.200.123.112:3389    42.110.172.188:5506    ESTABLISHED
  TermService
 [svchost.exe]
  TCP    10.200.123.112:59961   4.213.25.241:https     ESTABLISHED
  WpnService
 [svchost.exe]
```


### route

`route /?` shows all the options

With DHCP enabled we don't need to worry about adding routes manually, but if for some reason we want to use the other Private Network Interface to connect to private service then this will be useful as Windows will know that to connect to the private service it has to go through the Private Network Interface.

```text
C:\Users\Administrator>route print
===========================================================================
Interface List
  3...02 41 b4 ff 35 2f ......Amazon Elastic Network Adapter
  8...02 70 6b 85 82 57 ......Amazon Elastic Network Adapter #2
  1...........................Software Loopback Interface 1
===========================================================================

IPv4 Route Table
===========================================================================
Active Routes:
Network Destination        Netmask          Gateway       Interface  Metric
          0.0.0.0          0.0.0.0   10.200.123.129   10.200.123.139    276
          0.0.0.0          0.0.0.0     10.200.123.1   10.200.123.112     20
     10.200.123.0  255.255.255.128         On-link    10.200.123.112    276
   10.200.123.112  255.255.255.255         On-link    10.200.123.112    276
   10.200.123.127  255.255.255.255         On-link    10.200.123.112    276
   10.200.123.128  255.255.255.240         On-link    10.200.123.139    276
   10.200.123.139  255.255.255.255         On-link    10.200.123.139    276
   10.200.123.143  255.255.255.255         On-link    10.200.123.139    276
        127.0.0.0        255.0.0.0         On-link         127.0.0.1    331
        127.0.0.1  255.255.255.255         On-link         127.0.0.1    331
  127.255.255.255  255.255.255.255         On-link         127.0.0.1    331
  169.254.169.123  255.255.255.255         On-link    10.200.123.112     40
  169.254.169.249  255.255.255.255         On-link    10.200.123.112     40
  169.254.169.250  255.255.255.255         On-link    10.200.123.112     40
  169.254.169.251  255.255.255.255         On-link    10.200.123.112     40
  169.254.169.253  255.255.255.255         On-link    10.200.123.112     40
  169.254.169.254  255.255.255.255         On-link    10.200.123.112     40
        224.0.0.0        240.0.0.0         On-link         127.0.0.1    331
        224.0.0.0        240.0.0.0         On-link    10.200.123.139    276
        224.0.0.0        240.0.0.0         On-link    10.200.123.112    276
  255.255.255.255  255.255.255.255         On-link         127.0.0.1    331
  255.255.255.255  255.255.255.255         On-link    10.200.123.139    276
  255.255.255.255  255.255.255.255         On-link    10.200.123.112    276
===========================================================================
Persistent Routes:
  Network Address          Netmask  Gateway Address  Metric
          0.0.0.0          0.0.0.0   10.200.123.129  Default
===========================================================================

IPv6 Route Table
===========================================================================
Active Routes:
 If Metric Network Destination      Gateway
  1    331 ::1/128                  On-link
  3     40 fd00:ec2::123/128        On-link
  3     40 fd00:ec2::250/128        On-link
  3     40 fd00:ec2::253/128        On-link
  3     40 fd00:ec2::254/128        On-link
  8    276 fe80::/64                On-link
  3    276 fe80::/64                On-link
  8    276 fe80::ade6:9996:b384:41a/128
                                    On-link
  3    276 fe80::c837:564f:fa81:c71d/128
                                    On-link
  1    331 ff00::/8                 On-link
  8    276 ff00::/8                 On-link
  3    276 ff00::/8                 On-link
===========================================================================
Persistent Routes:
  None
```


- Add a route

The route added by this way is not persistent.

```text
C:\Users\Administrator>route ADD 157.0.0.0 MASK 255.0.0.0 10.200.123.1 IF 3
 OK!
```


- Add persistent route

```text
C:\Users\Administrator>route ADD 157.0.0.0 MASK 255.0.0.0 10.200.123.1 IF 3 -p
 OK!

===========================================================================
Persistent Routes:
  Network Address          Netmask  Gateway Address  Metric
          0.0.0.0          0.0.0.0   10.200.123.129  Default
        157.0.0.0        255.0.0.0     10.200.123.1       1
===========================================================================
```


- Delete route

```text
C:\Users\Administrator>route DELETE 157.0.0.0 MASK 255.0.0.0 10.200.123.1 IF 3
 OK!

===========================================================================
Persistent Routes:
  Network Address          Netmask  Gateway Address  Metric
          0.0.0.0          0.0.0.0   10.200.123.129  Default
===========================================================================
```
