## Linux Network Files

### /etc/hosts

`/etc/hosts` contains mapping between hostname and IP addresses. By default when we try to reach a host, first it is check if its IP is mapped in this file or not before going to DNS.

We can manually map an IP for a host/domain.

```text
127.0.0.1 localhost
1.2.3.4 www.google.com

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```

Now if we ping `google.com`, our mapped IP will be used to resolve the IP of `google.com`

```text
ubuntu@ip-10-200-123-39:~$ ping www.google.com
PING www.google.com (1.2.3.4) 56(84) bytes of data.
^C
--- www.google.com ping statistics ---
102 packets transmitted, 0 received, 100% packet loss, time 103454ms
```


### /etc/systemd/resolved.conf

`/etc/systemd/resolved.conf` contains the DNS configs.

We can configure here which DNS server to use to resolve hostnames.


### /etc/nsswitch.conf

`/etc/nsswitch.conf` contains cofig for different service.

We can make changes here, so that `/etc/hosts` is not used and directly DNS server is used to resolve hostnames.

```text
hosts:          dns
```

```text
ubuntu@ip-10-200-123-39:~$ ping www.google.com
PING www.google.com (142.250.192.132) 56(84) bytes of data.
64 bytes from bom12s18-in-f4.1e100.net (142.250.192.132): icmp_seq=1 ttl=117 time=1.70 ms
64 bytes from bom12s18-in-f4.1e100.net (142.250.192.132): icmp_seq=2 ttl=117 time=1.73 ms
64 bytes from bom12s18-in-f4.1e100.net (142.250.192.132): icmp_seq=3 ttl=117 time=1.75 ms
64 bytes from bom12s18-in-f4.1e100.net (142.250.192.132): icmp_seq=4 ttl=117 time=1.74 ms
64 bytes from bom12s18-in-f4.1e100.net (142.250.192.132): icmp_seq=5 ttl=117 time=1.79 ms
64 bytes from bom12s18-in-f4.1e100.net (142.250.192.132): icmp_seq=6 ttl=117 time=1.74 ms
64 bytes from bom12s18-in-f4.1e100.net (142.250.192.132): icmp_seq=7 ttl=117 time=1.75 ms
^C
--- www.google.com ping statistics ---
7 packets transmitted, 7 received, 0% packet loss, time 6011ms
rtt min/avg/max/mdev = 1.699/1.742/1.793/0.025 ms
```


## Linux Networking Tools

### dig

`dig` is similar to `nslookup` used to lookup DNS records as well as different types of DNS records.

```text
ubuntu@ip-10-200-123-39:~$ dig exampro.co

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> exampro.co
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10966
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;exampro.co.                    IN      A

;; ANSWER SECTION:
exampro.co.             60      IN      A       3.169.71.31
exampro.co.             60      IN      A       3.169.71.4
exampro.co.             60      IN      A       3.169.71.51
exampro.co.             60      IN      A       3.169.71.84

;; Query time: 35 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Mon Jun 09 18:06:28 UTC 2025
;; MSG SIZE  rcvd: 103
```


With `dig +trace` we can see how DNS resolution takes place.

```text
ubuntu@ip-10-200-123-39:~$ dig +trace www.exampro.co

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> +trace www.exampro.co
;; global options: +cmd
.                       7187    IN      NS      l.root-servers.net.
.                       7187    IN      NS      e.root-servers.net.
.                       7187    IN      NS      a.root-servers.net.
.                       7187    IN      NS      g.root-servers.net.
.                       7187    IN      NS      k.root-servers.net.
.                       7187    IN      NS      c.root-servers.net.
.                       7187    IN      NS      h.root-servers.net.
.                       7187    IN      NS      j.root-servers.net.
.                       7187    IN      NS      b.root-servers.net.
.                       7187    IN      NS      i.root-servers.net.
.                       7187    IN      NS      f.root-servers.net.
.                       7187    IN      NS      m.root-servers.net.
.                       7187    IN      NS      d.root-servers.net.
;; Received 239 bytes from 127.0.0.53#53(127.0.0.53) in 0 ms

;; UDP setup with 2001:7fd::1#53(2001:7fd::1) for www.exampro.co failed: network unreachable.
;; no servers could be reached
;; UDP setup with 2001:7fd::1#53(2001:7fd::1) for www.exampro.co failed: network unreachable.
;; no servers could be reached
;; UDP setup with 2001:7fd::1#53(2001:7fd::1) for www.exampro.co failed: network unreachable.
co.                     172800  IN      NS      ns1.cctld.co.
co.                     172800  IN      NS      ns2.cctld.co.
co.                     172800  IN      NS      ns3.cctld.co.
co.                     172800  IN      NS      ns4.cctld.co.
co.                     172800  IN      NS      ns5.cctld.co.
co.                     172800  IN      NS      ns6.cctld.co.
co.                     172800  IN      NS      ns7.cctld.co.
co.                     172800  IN      NS      ns8.cctld.co.
co.                     86400   IN      DS      62110 8 2 4857EE1A85E661C92156AD09B40139DAE7D5BE37D117A1223289F0E2 0CF9D654
co.                     86400   IN      RRSIG   DS 8 1 86400 20250622170000 20250609160000 53148 . XZ3Z/6lCYCiK8qdDWSmR1r0A7zSDcDB1daFW6P0KDO/bmhaW8hf1S2FJ jbe+wyhhbju2iU4La0EbEEB/kdIAq4d0wQDKIloEB1DrPwG9+JLAjVMb bQguN2L1XQr4aB2+e+ZRvcGkBXUWJs4VU+CpRRI9dU2Q8ehXoYLUDkWB wSlV6QNvV01333TzOf90xisb+JnqyldMIcY80nJK2IwKHjey0hhZcyiT dauutO5UhwFrCODp5+a6HnfD1936xPL0c+QA8ak3omoMiwNeNHKktmIh vgxZQ/Umr5JRpxlfbNrVyBjbXTjvOAD5VguRlqCt03aXtK9MXNnQoa5H 0Nkunw==
;; Received 880 bytes from 192.203.230.10#53(e.root-servers.net) in 2 ms

;; UDP setup with 2610:a1:1010::21#53(2610:a1:1010::21) for www.exampro.co failed: network unreachable.
exampro.co.             3600    IN      NS      ns-415.awsdns-51.com.
exampro.co.             3600    IN      NS      ns-568.awsdns-07.net.
exampro.co.             3600    IN      NS      ns-1027.awsdns-00.org.
exampro.co.             3600    IN      NS      ns-1965.awsdns-53.co.uk.
ldc0c7m112348qmhs09hokrvkepgubv6.co. 900 IN NSEC3 1 1 0 - LDC4LEP8QU156F8RL7HUF2CRKB495JBF NS SOA RRSIG DNSKEY NSEC3PARAM CDS CDNSKEY TYPE65534
ldc0c7m112348qmhs09hokrvkepgubv6.co. 900 IN RRSIG NSEC3 8 2 900 20250623105506 20250609101840 19065 co. cIGFyNi4HU+BQN9UKykGq5MQKQIkZ6OjJAj590maauxWo/M67QoxQr12 Pfz6MDF1woPSy4JtlHbpUBPbAmj6Sb3p1JgEddFQUxFhknmKE+Oop6gx uP6P0PZznTq9MQoRd1ma8kDYDurVcqLxAOBqjYjj7PYBsAiKdfTKJnEN OZU+f50a0ot08YhqcARdKsLUX7yPXBAGnsoOmfUEBvrVFA==
ohggemehmciri7538dga0fkr1tpk062p.co. 900 IN NSEC3 1 1 0 - OHH5NPU5KRJS8766C7I0L9RI4SG2OIV1 NS DS RRSIG
ohggemehmciri7538dga0fkr1tpk062p.co. 900 IN RRSIG NSEC3 8 2 900 20250619083131 20250605081148 19065 co. aKN+y29o0jC+ubhlss44HsQgVfIpa6Z83GfPPahulRSy7PsMWx6VifWe /qdacxCecVzDOOlINknZ7cjG8Ee44V6FQs5gecGE2EKb7bv/6ZDgnzk/ OsOXXSxErGPR0LwZQst8MmqN/QZnvYDK7EADZNEg4JZGFgdcbMd3TMiF /Vj9B6hQEKsrRrHrprRf7Vl/WIZIG2qRwUnzqnjcuYSsEA==
;; Received 795 bytes from 156.154.104.25#53(ns5.cctld.co) in 29 ms

;; UDP setup with 2600:9000:5307:ad00::1#53(2600:9000:5307:ad00::1) for www.exampro.co failed: network unreachable.
;; UDP setup with 2600:9000:5301:9f00::1#53(2600:9000:5301:9f00::1) for www.exampro.co failed: network unreachable.
www.exampro.co.         60      IN      A       18.239.111.106
www.exampro.co.         60      IN      A       18.239.111.11
www.exampro.co.         60      IN      A       18.239.111.125
www.exampro.co.         60      IN      A       18.239.111.63
exampro.co.             172800  IN      NS      ns-1027.awsdns-00.org.
exampro.co.             172800  IN      NS      ns-1965.awsdns-53.co.uk.
exampro.co.             172800  IN      NS      ns-415.awsdns-51.com.
exampro.co.             172800  IN      NS      ns-568.awsdns-07.net.
;; Received 247 bytes from 205.251.196.3#53(ns-1027.awsdns-00.org) in 4 ms
```


### netstat

It works the same way as in Windows.


### curl

`curl` is used to do everything manually that is done by browsers.

```text
ubuntu@ip-10-200-123-39:~$ curl -I https://exampro.co
HTTP/2 301
content-length: 0
location: http://www.exampro.co/
date: Sun, 08 Jun 2025 22:26:29 GMT
server: AmazonS3
x-cache: Hit from cloudfront
via: 1.1 906003c0e266a42e33244267f37672f8.cloudfront.net (CloudFront)
x-amz-cf-pop: TLV55-P1
x-amz-cf-id: gTD9wRR0IGHP6r7Yo9FHfTsWt8IQRnAD9Z-6QhoSHHsgckCNIYDuBw==
age: 71408
```


### lsof

`lsof` is used to check which files open and listening to which port.

First start a simple server with python

```sh
python3 -m http.server 8080
```

```text
ubuntu@ip-10-200-123-39:~$ python3 -m http.server 8080&
[1] 1456
ubuntu@ip-10-200-123-39:~$ Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...
```

```text
ubuntu@ip-10-200-123-39:~$ lsof -i
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
python3 1456 ubuntu    3u  IPv4  11843      0t0  TCP *:http-alt (LISTEN)
```
