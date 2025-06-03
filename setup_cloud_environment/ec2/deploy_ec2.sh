#!/usr/bin/env bash

# CloudFormation Deployment Script for Net-Bootcamp EC2 Instances

set -e  # Exit on any error

# Configuration
STACK_NAME="Net-Bootcamp-EC2"
TEMPLATE_FILE="template.yaml"
REGION="ap-south-1"

# Colors for output (if supported)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
echo "=================================================="
echo "   EC2 Instances Stack Deployment"
echo "   Stack Name: $STACK_NAME"
echo "   Region: $REGION"
echo "=================================================="
echo

# Check if AWS CLI is installed
print_status "Checking AWS CLI installation..."
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed or not in PATH"
    exit 1
fi
print_success "AWS CLI found"

# Check if template file exists
print_status "Checking CloudFormation template..."
if [ ! -f "$TEMPLATE_FILE" ]; then
    print_error "Template file '$TEMPLATE_FILE' not found in current directory"
    exit 1
fi
print_success "Template file found: $TEMPLATE_FILE"

# Check AWS credentials
print_status "Validating AWS credentials..."
if ! aws sts get-caller-identity --region $REGION &> /dev/null; then
    print_error "AWS credentials not configured or invalid"
    print_warning "Please run 'aws configure' to set up your credentials"
    exit 1
fi
print_success "AWS credentials validated"

# Verify prerequisite resources
print_status "Verifying prerequisite resources..."

# VPC and Subnets
VPC_ID="vpc-0e4cdd49890790399"
PUBLIC_SUBNET_ID="subnet-020bb119f922bbd66"
PRIVATE_SUBNET_ID="subnet-08c61632685853e00"

# Network Interfaces
UBUNTU_NIC="eni-066f4c4ad5979d9cd"
REDHAT_NIC="eni-06c1711d1fab49521"
WINDOWS_NIC="eni-016f9b4453dd191ca"

# Security Groups
LINUX_SG="sg-07d680556da04d553"
WINDOWS_SG="sg-015b61d0b2bc01cdf"

# Key Pair
KEY_PAIR="net-boot-pem"

# Verify VPC
if ! aws ec2 describe-vpcs --vpc-ids $VPC_ID --region $REGION &> /dev/null; then
    print_error "VPC $VPC_ID not found"
    exit 1
fi

# Verify Subnets
if ! aws ec2 describe-subnets --subnet-ids $PUBLIC_SUBNET_ID --region $REGION &> /dev/null; then
    print_error "Public subnet $PUBLIC_SUBNET_ID not found"
    exit 1
fi

# Verify Network Interfaces
for nic in $UBUNTU_NIC $REDHAT_NIC $WINDOWS_NIC; do
    if ! aws ec2 describe-network-interfaces --network-interface-ids $nic --region $REGION &> /dev/null; then
        print_error "Network Interface $nic not found"
        print_warning "Please ensure the Net-Bootcamp-NICs stack is deployed first"
        exit 1
    fi
    
    # Check if NIC is already attached
    ATTACHMENT_STATUS=$(aws ec2 describe-network-interfaces \
        --network-interface-ids $nic \
        --region $REGION \
        --query 'NetworkInterfaces[0].Attachment.Status' \
        --output text 2>/dev/null || echo "None")
    
    if [ "$ATTACHMENT_STATUS" != "None" ] && [ "$ATTACHMENT_STATUS" != "null" ]; then
        print_error "Network Interface $nic is already attached to another instance"
        print_warning "Please detach it first or use a different network interface"
        exit 1
    fi
done

# Verify Security Groups
for sg in $LINUX_SG $WINDOWS_SG; do
    if ! aws ec2 describe-security-groups --group-ids $sg --region $REGION &> /dev/null; then
        print_error "Security Group $sg not found"
        exit 1
    fi
done

# Verify Key Pair
if ! aws ec2 describe-key-pairs --key-names $KEY_PAIR --region $REGION &> /dev/null; then
    print_error "Key Pair '$KEY_PAIR' not found"
    exit 1
fi

print_success "All prerequisite resources verified"

# Check if stack already exists
print_status "Checking if stack already exists..."
if aws cloudformation describe-stacks --stack-name "$STACK_NAME" --region $REGION &> /dev/null; then
    print_error "Stack '$STACK_NAME' already exists in region $REGION"
    print_warning "Please delete the existing stack or use a different name"
    exit 1
fi
print_success "Stack name is available"

# Deploy the CloudFormation stack
print_status "Deploying CloudFormation stack..."
echo "Stack Name: $STACK_NAME"
echo "Template: $TEMPLATE_FILE"
echo "Region: $REGION"
echo
echo "Resources to be created:"
echo "  • Ubuntu EC2 (t3.micro) with NIC: $UBUNTU_NIC"
echo "  • RedHat EC2 (t3.micro) with NIC: $REDHAT_NIC"
echo "  • Windows EC2 (t3.medium) with NIC: $WINDOWS_NIC"
echo

aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body file://"$TEMPLATE_FILE" \
    --region $REGION

if [ $? -eq 0 ]; then
    print_success "Stack creation initiated successfully"
else
    print_error "Failed to create stack"
    exit 1
fi

# Wait for stack creation to complete
print_status "Waiting for stack creation to complete..."
echo "This may take 3-5 minutes for EC2 instances to launch..."

aws cloudformation wait stack-create-complete \
    --stack-name "$STACK_NAME" \
    --region $REGION

if [ $? -eq 0 ]; then
    print_success "Stack '$STACK_NAME' created successfully!"
else
    print_error "Stack creation failed or timed out"
    print_warning "Check AWS Console for detailed error information"
    exit 1
fi

# Display stack outputs
print_status "Fetching stack outputs..."
echo
echo "=================================================="
echo "           STACK OUTPUTS"
echo "=================================================="

aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region $REGION \
    --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue,Description]' \
    --output table

echo
echo "=================================================="
echo "         EC2 INSTANCE DETAILS"
echo "=================================================="

# Get Instance IDs from outputs
INSTANCE_IDS=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region $REGION \
    --query 'Stacks[0].Outputs[?contains(OutputKey, `InstanceId`)].OutputValue' \
    --output text)

# Display detailed instance information
for instance_id in $INSTANCE_IDS; do
    echo
    print_status "Instance: $instance_id"
    aws ec2 describe-instances \
        --instance-ids $instance_id \
        --region $REGION \
        --query 'Reservations[0].Instances[0].[Tags[?Key==`Name`].Value|[0], InstanceType, State.Name, PublicIpAddress, PrivateIpAddress]' \
        --output table \
        --no-cli-pager
done

echo
print_success "Deployment completed successfully!"
echo
echo "Stack Details:"
echo "  Name: $STACK_NAME"
echo "  Region: $REGION"
echo "  Status: CREATE_COMPLETE"
echo
echo "Resources Created:"
echo "  • 3 EC2 Instances (Ubuntu, RedHat, Windows)"
echo "  • 3 Network Interface Attachments (secondary interfaces)"
echo
print_warning "Remember: Each instance has two network interfaces!"
print_warning "Primary (eth0): Public subnet with internet access"
print_warning "Secondary (eth1): Private subnet for internal communication"
