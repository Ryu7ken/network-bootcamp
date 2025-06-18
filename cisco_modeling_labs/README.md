## VMware and CML Installation

We need to first install **VMware Workstation Pro** and then we need to download **Cisco Modeling Labs (CML)** `.ova` file and the `.iso` to create a Virtual Machine in VMware Workstation.


Faced issues with starting the Cisco Modeling Labs VM as Hyper-V and WSL was causing issues so had to disable them.

```sh
bcdedit /set hypervisorlaunchtype off
DISM /Online /Disable-Feature:Microsoft-Hyper-V
DISM /Online /Disable-Feature:VirtualMachinePlatform
DISM /Online /Disable-Feature:WindowsHypervisorPlatform
DISM /Online /Disable-Feature:HypervisorPlatform
```

Later on Hyper-V and WSL can be re-enabled.

```sh
bcdedit /set hypervisorlaunchtype auto
DISM /Online /Enable-Feature:Microsoft-Hyper-V /All
DISM /Online /Enable-Feature:VirtualMachinePlatform /All
DISM /Online /Enable-Feature:WindowsHypervisorPlatform /All
DISM /Online /Enable-Feature:HypervisorPlatform /All
```

> [!IMPORTANT]
> Unfortunately CML Free Tier comes with CML 2.8.1 which does not have some node devices like the **cat8000v** and few more. These are available in the CML 2.7.2 but that is not Free Tier.


## Cisco DevNet

This is a Sandbox environment where we can launch Cisco Modeling Labs and set a duration to use the Sandbox before it get destroyed automatically.


### Launching Cisco Modeling Labs Sandbox in DevNet

Search for Cisco Modeling Labs sandbox.

![CML DevNet](/assets/devnet_cml.png)

After launching the sandbox environment, it should look like this:

![DevNet CML Environment](/assets/devnet_env.png)


### VPN Connection to Sandbox

Follow the instruction to connect to the sandbox environment via VPN. I used OpenConnect VPN.

![OpenConnect VPN](/assets/devnet_openconnect.png)


### Issue with OpenConnect VPN

There seems to be an issue with OpenConnect VPN when trying to make changes on Windows to establish VPN connection. In that case just open the **New profile (advanced)** and just provide any name under **Interface** and this solves the issue.


### Importing Labs

- Imported pre-created CML using the provided file called `cml-vpn-lab.yaml`. Then turned ON the Lab.

![CML VPN Sample](/assets/cml_vpn_sample.png)


- It is a best practice to not use **Vlan 1** as it is generally used for communications and since it is the default it can cause security issues. So we created seperated **Vlan 10**.

![CML VLAN](/assets/cml_vlan.png)


- We can check the Router Ip Configurations.

![CML Router](/assets/cml_router.png)


- Checking the network on GigabitEthernet2

![CML Gi2 Config](/assets/cml_gi2.png)


- The Router has been configured with DHCP to handout IP Addresses. It is set to handout IP Address after `10.10.10.10`, so the first device (alpine-0) has IP `10.10.10.11`.

![CML Gi2 dhcp](/assets/cml_gi2_dhcp.png)

![CML Alpine](/assets/cml_alpine_ip.png)
