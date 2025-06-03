#!/usr/bin/env bash

# CloudFormation Deployment Script for Net-Bootcamp VPC

set -e  # Exit on any error

# Configuration
STACK_NAME="Net-Bootcamp"
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
echo "   CloudFormation Deployment Script"
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

aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body file://"$TEMPLATE_FILE" \
    --region $REGION \
    --capabilities CAPABILITY_IAM

if [ $? -eq 0 ]; then
    print_success "Stack creation initiated successfully"
else
    print_error "Failed to create stack"
    exit 1
fi

# Wait for stack creation to complete
print_status "Waiting for stack creation to complete..."
echo "This may take a few minutes..."

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
print_success "Deployment completed successfully!"
echo
echo "Stack Details:"
echo "  Name: $STACK_NAME"
echo "  Region: $REGION"
echo "  Status: CREATE_COMPLETE"
