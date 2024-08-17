#!/bin/bash

# Fail the script if any command fails
set -e

# Define variables
APP_NAME="flask_app"
STAGING_SERVER="ec2-16-171-253-111.eu-north-1.compute.amazonaws.com"
REPO_URL="https://github.com/PankajGacche/Jenking_CICD_Pipeline.git"
DEPLOY_PATH="/home/ubuntu/flask_app"
VENV_PATH="/home/ubuntu/flask_app/venv"
SERVICE_NAME="flask_app.service"
SSH_KEY="/home/pankajgacche/cicd.pem"

# Optional: Print start of deployment
echo "Starting deployment to staging environment..."

# Connect to staging server
echo "Connecting to staging server and deploying the application..."

ssh -i $SSH_KEY $STAGING_SERVER << 'EOF'
    # Go to the application directory
    cd $DEPLOY_PATH || exit

    # Pull the latest code from the repository
    echo "Pulling latest code from repository..."
    git pull origin staging

    # Activate the virtual environment
    echo "Activating virtual environment..."
    source venv/bin/activate

    # Install/Upgrade dependencies
    echo "Installing/Upgrading dependencies..."
    pip install -r requirements.txt

    # Restart the application service
    echo "Restarting application service..."
    sudo systemctl restart $SERVICE_NAME

    # Optional: Check the status of the service
    echo "Checking application service status..."
    sudo systemctl status $SERVICE_NAME

    # Optional: Verify application is running (e.g., check if it's listening on port 80)
    echo "Verifying application..."
    curl -s -o /dev/null -w "%{http_code}" http://localhost:80
EOF

# Optional: Notify success
echo "Deployment to staging completed successfully."
