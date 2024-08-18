#!/bin/bash

# Define variables
APP_DIR="/home/ubuntu/myproject"
REPO_URL="https://github.com/PankajGacche/Jenking_CICD_Pipeline.git"
BRANCH="main"
VENV_DIR="$APP_DIR/venv"
APP_NAME="app"
GUNICORN_SERVICE_NAME="gunicorn_staging"

# Functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check for necessary commands
# for cmd in git python3 systemctl pip; do
#     if ! command -v $cmd &> /dev/null; then
#         log "$cmd command not found. Please install it."
#         exit 1
#     fi
# done

# Ensure the application directory exists
if [ ! -d "$APP_DIR" ]; then
    log "Application directory not found, creating..."
    mkdir -p "$APP_DIR"
fi

# Navigate to the application directory
log "Navigating to the application directory..."
cd "$APP_DIR" || { log "Application directory not found!"; exit 1; }

# Ensure the repository is cloned and update
if [ ! -d ".git" ]; then
    log "Repository not found, cloning..."
    git clone "$REPO_URL" .
else
    log "Repository found, fetching and updating..."
    git fetch --all
    git stash push -m "Jenkins auto-stash before pull"
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
    git stash pop || true
fi

# Activate the virtual environment
log "Activating virtual environment..."
if [ -f "$VENV_DIR/bin/activate" ]; then
    source "$VENV_DIR/bin/activate"
else
    log "Virtual environment not found, creating a new one..."
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
fi

# Install dependencies
log "Installing dependencies..."
if [ -f requirements.txt ]; then
    pip install --upgrade pip
    pip install -r requirements.txt
else
    log "requirements.txt file not found"
    exit 1
fi

# Restart the Gunicorn service
log "Restarting Gunicorn service..."
sudo systemctl daemon-reload
sudo systemctl restart "$GUNICORN_SERVICE_NAME" || { log "Failed to restart Gunicorn"; exit 1; }

log "Deployment to staging completed successfully!"
