## Windows Firewall

- Domain Profile - This is applied if part of Active Directory domain.

- Private Profile - This is applied for Private networks.

- Public Profile - This is applied for Public networks.


### Serve Static Website

First install Python on the Windows Server 2025.

Then create a folder and a `index.html` file in the folder.

```sh
mdkir website

cd website
```

Then serve the `index.html` page using the command

```sh
python -m http.server 8000
```

OR

```sh
py -m http.server 8000
```

![Static Website](/assets/website.png)

Check if the Website is running correctly.

![Website Reachable](/assets/website_curl.png)


### Access Website from Other System

We need to open port 8000 on the AWS Security Group for Inbound Access, so that we can acces the website from the Public IP Address of the Windwos Server.

![AWS Security Group](/assets/website_sg.png)


But we can see that we are still not able to access the website from Public IP Address, so allowing Inbound Access from Security Group is not enough and we have to configure Windows Firewall for Inbound Acces to port 8000 as well.

![Website Unreachable form Public IP](/assets/website_public_error.png)


### Setup Windows Firewall

Allow Inbound Access on port 8000 to access the Website.

![Windows Firewall](/assets/firewall_1.png)

![Windows Firewall](/assets/firewall_2.png)

![Windows Firewall](/assets/firewall_3.png)

![Windows Firewall](/assets/firewall_4.png)

![Windows Firewall](/assets/firewall_5.png)

![Windows Firewall](/assets/firewall_6.png)


After correctly configuring the Windows Firewall we are able to access the Website using the Public IP Address of the Windows Server.

![Website Accessible from Public IP](/assets/website_public_success_1.png)

![Website Accessible from Public IP](/assets/website_public_success_2.png)


> [!IMPORTANT]
> Finally delete the Windows Firewall Rule and the Security Group Rule for port 8000.
