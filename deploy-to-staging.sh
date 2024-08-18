#!/bin/bash

# Variables
APP_DIR=/home/ubuntu/myproject
REPO_URL=https://github.com/PankajGacche/Jenking_CICD_Pipeline.git

# Navigate to app directory
cd $APP_DIR || { echo "Directory $APP_DIR not found"; exit 1; }

# Pull the latest code
git pull origin main

# Create a virtual environment if not exists
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

# Activate virtual environment and install dependencies
source venv/bin/activate
pip install -r requirements.txt

# Restart the Flask application (this depends on your setup)
sudo systemctl restart my-flask-app.service
