#!/bin/bash

apt-get update
apt-get install -y openssh-server sudo bash nano

mkdir -p /run/sshd
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create user with bash as default shell
useradd -m -s /bin/bash demo
echo 'demo:demo' | chpasswd
usermod -aG sudo demo

# Create a basic .bashrc file for demo user
cat > /home/demo/.bashrc << 'EOF'
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
alias ls='ls --color=auto'
alias ll='ls -la'
EOF

# Set proper ownership
chown demo:demo /home/demo/.bashrc

# Check if SSH service is running, if not start it
if systemctl is-active --quiet ssh; then
    echo "SSH service is already running"
elif systemctl is-active --quiet sshd; then
    echo "SSH service (sshd) is already running"
else
    echo "SSH service is not running. Starting SSH service..."
    systemctl start ssh
    if [ $? -eq 0 ]; then
        echo "SSH service started successfully"
        systemctl enable ssh
        echo "SSH service enabled to start on boot"
    else
        echo "Failed to start SSH service. Trying sshd..."
        systemctl start sshd
        if [ $? -eq 0 ]; then
            echo "SSH service (sshd) started successfully"
            systemctl enable sshd
            echo "SSH service (sshd) enabled to start on boot"
        else
            echo "Failed to start SSH service"
        fi
    fi
fi

# Verify SSH service status
if systemctl is-active --quiet ssh || systemctl is-active --quiet sshd; then
    echo "SSH service is now running and ready for connections"
else
    echo "Warning: SSH service may not be running properly"
fi
