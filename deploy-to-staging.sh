#!/bin/bash

# Define variables
APP_DIR="/var/lib/jenkins/workspace/Python_Flask_Pipeline"  # Path to your application on the EC2 instance
REPO_URL="https://github.com/PankajGacche/Jenking_CICD_Pipeline.git"  # Your Git repository URL
BRANCH="main"  # Git branch to deploy
VENV_DIR="$APP_DIR/venv"  # Path to the virtual environment
APP_NAME="app"  # Name of your Flask application (adjust as needed)
GUNICORN_SERVICE_NAME="gunicorn_staging"  # Name of the Gunicorn service (adjust as needed)

# Functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check for necessary commands
for cmd in git python3 systemctl pip; do
    if ! command -v $cmd &> /dev/null; then
        log "$cmd command not found. Please install it."
        exit 1
    fi
done

# Navigate to the application directory
log "Navigating to the application directory..."
if ! cd "$APP_DIR"; then
    log "Application directory not found!"
    exit 1
fi

# Ensure the repository is cloned and update
if [ ! -d ".git" ]; then
    log "Repository not found, cloning..."
    git clone "$REPO_URL" .
else
    log "Repository found, fetching and updating..."
    git fetch --all

    # Handle uncommitted local changes by stashing them
    git stash push -m "Jenkins auto-stash before pull"

    git checkout "$BRANCH"
    git pull origin "$BRANCH"

    # Apply stashed changes if needed
    git stash pop || true
fi
 
# Reload systemd and restart the service
sudo systemctl daemon-reload
sudo systemctl restart my-flask-app
# Activate the virtual environment
log "Activating virtual environment..."
if [ -f "$VENV_DIR/bin/activate" ]; then
    source "$VENV_DIR/bin/activate"
else
    log "Virtual environment not found, creating a new one..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
fi

echo "Navigating to the application directory..."
cd /home/ubuntu/myproject || { echo "Directory not found"; exit 1; }

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing dependencies..."
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
else
    echo "requirements.txt file not found"
    exit 1
fi

echo "Restarting Gunicorn service..."
sudo systemctl restart my-flask-app || { echo "Failed to restart Gunicorn"; exit 1; }


# Install Python dependencies
log "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
log "Deployment to staging completed successfully!"
