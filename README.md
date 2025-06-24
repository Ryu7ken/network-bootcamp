# Network Bootcamp Learning Journal

This repository documents my comprehensive journey through an intensive Network Bootcamp by **Andrew Brown** and **Tim McConnaughy**, where I gained hands-on experience with a wide range of networking concepts, tools, and technologies. The repository serves as both a personal reference and a demonstration of practical networking skills acquired during the bootcamp.

## Repository Structure

Each directory in this repository represents a specific networking topic covered during the bootcamp. Inside each directory, you'll find detailed documentation of:

- Core concepts and theoretical knowledge
- Step-by-step implementation guides
- Hands-on exercises and their outcomes
- Challenges encountered and their solutions
- Configuration examples and code snippets

## Cloud Environment Setup

The bootcamp began with establishing a robust cloud environment in AWS:

- Configured a VPC with public and private subnets to simulate real-world network segmentation
- Launched multiple EC2 instances running different operating systems:
  - Ubuntu
  - Red Hat Enterprise Linux
  - Windows Server 2025
- Created and attached Elastic Network Interfaces to each instance for advanced networking scenarios
- Implemented appropriate security groups and network ACLs

## Core Networking Topics

### IP Address Management
- Explored Windows networking configuration through both GUI and Command Prompt
- Configured Ubuntu networking via CLI using various commands
- Analyzed network interface details and parameters
- Implemented manual IP address configuration on secondary network interfaces
- Documented the differences between static and dynamic addressing approaches

### Linux Networking Tools
- Examined critical network configuration files:
  - `/etc/hosts` for hostname to IP mapping
  - `/etc/systemd/resolved.conf` for DNS configuration
  - `/etc/nsswitch.conf` for service resolution order
- Utilized DNS lookup tools like `dig` to understand DNS resolution processes
- Employed network monitoring tools including `netstat`, `curl`, and `lsof`
- Captured and analyzed network traffic using `tcpdump`
- Practiced troubleshooting common network connectivity issues

### Windows Networking Tools
- Explored Windows-specific networking utilities and commands
- Configured network settings through Command Prompt
- Implemented Windows network diagnostics and troubleshooting techniques
- Managed Windows network profiles and connection settings

## Advanced Networking Implementations

### Traffic Flow Analysis with Wireshark
- Set up environments for packet capture and analysis
- Performed DHCP protocol analysis to understand address assignment
- Implemented live packet capture techniques in different scenarios
- Explored Wireshark's filtering and analysis capabilities

### Network Simulation and Modeling
- Used Packet Tracer to build and test network topologies
- Implemented Cisco Modeling Labs for advanced network simulation
- Created virtual network environments to test configurations before deployment

### Firewall Configuration
- Implemented and managed Linux firewall rules using iptables and firewalld
- Configured Windows Defender Firewall for different network profiles
- Applied security best practices for network traffic control
- Created rule sets for specific applications and services

### Network Address Translation (NAT)
- Implemented various NAT configurations
- Understood the differences between SNAT, DNAT, and PAT
- Configured NAT in both Linux and Windows environments
- Troubleshot common NAT-related connectivity issues

## Proxy and Load Balancing Solutions

### Reverse Proxy Implementation
- Set up Squid as a reverse proxy on Ubuntu
- Configured Windows Server IIS for reverse proxy functionality
- Addressed common reverse proxy configuration challenges

### Forward Proxy Configuration
- Deployed forward proxy servers for client traffic management
- Distinguished between forward and reverse proxy use cases
- Configured client systems to use proxy servers

### Load Balancing with HAProxy
- Deployed HAProxy in a containerized environment using **Containerlab**
- Configured round-robin load balancing for web servers
- Implemented health checks and failover mechanisms
- Troubleshot connectivity issues between network segments
- Modified routing tables to enable cross-network communication

## Enterprise Networking Solutions

### Virtual Private Network (VPN)
- Established Site-to-Site VPN connection between on-premises and AWS
- Configured Customer Gateway and Virtual Private Gateway in AWS
- Implemented strongSwan on RHEL9 for IPsec VPN connectivity
- Managed firewall rules to allow VPN traffic
- Enabled route propagation for VPN-connected networks
- Tested and validated secure connectivity across environments

### Cloud Networking
- Designed and implemented AWS VPC architectures
- Established VPC peering between cloud environments
- Compared networking approaches across different cloud providers
- Implemented best practices for cloud network security

## Key Learnings and Challenges

Throughout this bootcamp, I encountered and overcame several challenges:

- Troubleshooting connectivity issues between containerized environments and external networks
- Configuring proper routing between different network segments
- Implementing secure VPN connections with appropriate encryption
- Managing firewall rules to balance security and accessibility
- Optimizing network performance across diverse environments

The hands-on approach of this bootcamp provided invaluable experience in applying theoretical networking concepts to practical scenarios, preparing me for real-world networking challenges in enterprise environments.

## Tools and Technologies Used

This bootcamp leveraged a diverse set of tools and technologies:

- **Cloud Platforms**: AWS
- **Network Analysis**: Wireshark, tcpdump, tshark
- **Network Simulation**: Cisco Packet Tracer, Cisco Modeling Labs
- **Containerization**: Docker, Containerlab
- **Proxy and Load Balancing**: HAProxy, Squid
- **VPN Solutions**: strongSwan, AWS Site-to-Site VPN
- **Operating Systems**: Ubuntu, Red Hat Enterprise Linux, Windows Server
- **Firewall Technologies**: iptables, firewalld, Windows Defender Firewall

## Getting Started

To explore a specific topic:

1. Navigate to the corresponding directory
2. Read the README.md file for an overview and implementation details
3. Follow the step-by-step instructions for hands-on exercises
4. Refer to the included screenshots and configuration examples

## Acknowledgments

This repository documents my learning journey through a comprehensive Network Bootcamp that covered both traditional networking concepts and modern cloud networking approaches. The hands-on exercises provided practical experience with essential networking tools and technologies used in enterprise environments.
