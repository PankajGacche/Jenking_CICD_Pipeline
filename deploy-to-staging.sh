#!/bin/bash

# Define variables
APP_DIR="/home/ubuntu/app"  # Path to your application on the EC2 instance
REPO_URL="https://github.com/PankajGacche/Jenking_CICD_Pipeline.git"  # Your Git repository URL
BRANCH="main"  # Git branch to deploy
VENV_DIR="$APP_DIR/venv"  # Path to the virtual environment
APP_NAME="app"  # Name of your Flask application (adjust as needed)
GUNICORN_SERVICE_NAME="gunicorn_staging"  # Name of the Gunicorn service (adjust as needed)

# Functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Ensure the script is run as root
if [ "$(id -u)" -ne "0" ]; then
    log "This script must be run as root" >&2
    exit 1
fi

# Navigate to the application directory
log "Navigating to the application directory..."
cd $APP_DIR || { log "Application directory not found!"; exit 1; }

# Pull the latest changes from the repository
log "Pulling the latest changes from Git..."
git fetch --all
git checkout $BRANCH
git pull origin $BRANCH

# Activate the virtual environment
log "Activating virtual environment..."
source $VENV_DIR/bin/activate

# Install Python dependencies
log "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Restart the Gunicorn service
log "Restarting Gunicorn service..."
systemctl restart $GUNICORN_SERVICE_NAME

# Optionally, restart Nginx if used
# log "Restarting Nginx..."
# systemctl restart nginx

log "Deployment to staging completed successfully!"
