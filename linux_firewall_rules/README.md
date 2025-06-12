## Ubuntu Firewall

### ufw

Uncomplicated Firewall (UFW) works in the layer 4 of the OSI Model. We can Allow, Deny and Route traffic.


- Rule to allow SSH on port 22 before enabling `ufw`.

```text
ubuntu@ip-10-200-123-39:~$ sudo ufw allow from any to any port 22
Rules updated
Rules updated (v6)

ubuntu@ip-10-200-123-39:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup

ubuntu@ip-10-200-123-39:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)
```

- Rule to deny telnet

First we will try to telnet to **aardwolf.org** on port 4000 to test telnet is working.

```text
ubuntu@ip-10-200-123-39:~$ telnet aardwolf.org 4000
Trying 23.111.142.226...
Connected to aardwolf.org.
Escape character is '^]'.
#############################################################################
##[                                               ]##########################
##[        --- Welcome to Aardwolf MUD ---        ]############ /"  #########
##[                                               ]########  _-`"""', #######
##[         Players Currently Online: 172         ]#####  _-"       )  ######
##[                                               ]### _-"          |  ######
################################################### _-"            ;  #######
######################################### __---___-"              |  ########
######################################  _"   ,,                  ;  `,,  ####
#################################### _-"    ;''                 |  ,'  ; ####
##################################  _"      '                    `"'   ; ####
###########################  __---;                                 ,' ######
######################## __""  ___                                ,' ########
#################### _-""   -"" _                               ,' ##########
################### `-_         _                              ; ############
#####################  ""----"""   ;                          ; #############
#######################  /          ;                        ; ##############
#####################  /             ;                      ; ###############
###################  /                `                    ; ################
#################  /                                      ; #################
-----------------------------------------------------------------------------
    Enter your character name or type 'NEW' to create a new character
-----------------------------------------------------------------------------
What be thy name, adventurer?
```

After successful tlenet connection, we close it and define a `ufw` rule to deny outgoing with `telnet`.

```text
ubuntu@ip-10-200-123-39:~$ sudo ufw deny out telnet
Rule added
Rule added (v6)

ubuntu@ip-10-200-123-39:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)

23/tcp                     DENY OUT    Anywhere
23/tcp (v6)                DENY OUT    Anywhere (v6)

ubuntu@ip-10-200-123-39:~$ telnet aardwolf.org 4000
Trying 23.111.142.226...
Connected to aardwolf.org.
Escape character is '^]'.
#############################################################################
##[                                               ]##########################
##[        --- Welcome to Aardwolf MUD ---        ]############ /"  #########
##[                                               ]########  _-`"""', #######
##[         Players Currently Online: 170         ]#####  _-"       )  ######
##[                                               ]### _-"          |  ######
################################################### _-"            ;  #######
######################################### __---___-"              |  ########
######################################  _"   ,,                  ;  `,,  ####
#################################### _-"    ;''                 |  ,'  ; ####
##################################  _"      '                    `"'   ; ####
###########################  __---;                                 ,' ######
######################## __""  ___                                ,' ########
#################### _-""   -"" _                               ,' ##########
################### `-_         _                              ; ############
#####################  ""----"""   ;                          ; #############
#######################  /          ;                        ; ##############
#####################  /             ;                      ; ###############
###################  /                `                    ; ################
#################  /                                      ; #################
-----------------------------------------------------------------------------
    Enter your character name or type 'NEW' to create a new character
-----------------------------------------------------------------------------
What be thy name, adventurer?
```

But we see we are still able to `telnet` to **aardwolf.org** because by default the `telnet` port assumed by the firewall is 23 and **aardwolf.org** is on port 4000. So we need to provide the correct port in the rule.

```text
ubuntu@ip-10-200-123-39:~$ sudo ufw deny out 4000/tcp
Rule added
Rule added (v6)

ubuntu@ip-10-200-123-39:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)

23/tcp                     DENY OUT    Anywhere
4000/tcp                   DENY OUT    Anywhere
23/tcp (v6)                DENY OUT    Anywhere (v6)
4000/tcp (v6)              DENY OUT    Anywhere (v6)

ubuntu@ip-10-200-123-39:~$ telnet aardwolf.org 4000
Trying 23.111.142.226...
```

- Rule to deny telnet connection only to aardwolf.org from 4000

First we need to get the IP of aardwolf.org server.

```text

ubuntu@ip-10-200-123-39:~$ dig aardwolf.org

; <<>> DiG 9.18.30-0ubuntu0.24.04.2-Ubuntu <<>> aardwolf.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54373
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;aardwolf.org.                  IN      A

;; ANSWER SECTION:
aardwolf.org.           300     IN      A       23.111.142.226

;; Query time: 193 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Thu Jun 12 12:55:19 UTC 2025
;; MSG SIZE  rcvd: 57
```

Now we will use the IP of **aardwolf.org**.

```text
ubuntu@ip-10-200-123-39:~$ sudo ufw deny out proto tcp from any to 23.111.142.226 port 4000
Rule added

ubuntu@ip-10-200-123-39:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)

23.111.142.226 4000/tcp    DENY OUT    Anywhere

ubuntu@ip-10-200-123-39:~$ telnet aardwolf.org 4000
Trying 23.111.142.226...
```


## RedHat Firewall

### firewalld

`firewalld` is a zone based firewall which is different than `ufw` firewalls. Zone based firewall takes interfaces and assigns them to a zone and the firewall rules are assigned to these zones. So all the interfaces in these zones get the firewall rules applied to them automatically. It is kind of similar to Windows Domain firewall.

Make sure `firewalld-cmd` is present or we need to install it.
```sh
sudo dnf install firewalld
```

Then start the firewalld service.
```sh
sudo systemctl start firewalld
```

- Check the active zones

```text
[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --get-active-zones
public (default)
  interfaces: ens5 ens6
```

- Rule to deny outgoing from port 4000

```text
[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -p tcp --dport 4000 -j REJECT
success

[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --reload
success

[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --direct --get-all-rules
ipv4 filter OUTPUT 0 -p tcp --dport 4000 -j REJECT

[ec2-user@ip-10-200-123-41 ~]$ telnet aardwolf.org 4000
Trying 23.111.142.226...
telnet: connect to address 23.111.142.226: Connection refused
```

- Create a new zone

```text
[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --permanent --new-zone private
success

[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --reload
success

[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --get-zones
block dmz drop external home internal nm-shared private public trusted work
```

- Add interface to the new zone

```text
[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --permanent --zone private --add-interface ens6
The interface is under control of NetworkManager, setting zone to 'private'.
success
```

- Confirm if the interface is bound to the zone

```text
[ec2-user@ip-10-200-123-41 ~]$ sudo firewall-cmd --query-interface ens6
yes
```

Finally stop the firewalld service.
```sh
sudo systemctl stop firewalld
```


## Linux Firewall

### iptables

- Rule to deny outgoing from port 4000

```text
[ec2-user@ip-10-200-123-41 ~]$ sudo iptables -A OUTPUT -p tcp --dport 4000 -j DROP

[ec2-user@ip-10-200-123-41 ~]$ telnet aardwolf.org 4000
Trying 23.111.142.226...
```

Finally delete the iptables rule.
```sh
sudo iptables -D OUTPUT -p tcp --dport 4000 -j DROP
```
