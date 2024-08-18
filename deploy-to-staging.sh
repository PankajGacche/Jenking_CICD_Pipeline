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
 Paths
SERVICE_FILE=/etc/systemd/system/my-flask-app.service
PROJECT_DIR=/home/ubuntu/myproject

# Create or update the Gunicorn service file
if [ ! -f "$SERVICE_FILE" ]; then
    echo "Gunicorn service file not found. Creating..."
    sudo bash -c 'cat > /etc/systemd/system/my-flask-app.service <<EOF
    [Unit]
    Description=Gunicorn instance to serve my-flask-app
    After=network.target

    [Service]
    User=ubuntu
    Group=ubuntu
    WorkingDirectory=/home/ubuntu/myproject
    ExecStart=/home/ubuntu/myproject/venv/bin/gunicorn --workers 3 --bind unix:/home/ubuntu/myproject/my-flask-app.sock app:app

    [Install]
    WantedBy=multi-user.target
    EOF'
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

# Install Python dependencies
log "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Restart the Gunicorn service
log "Restarting Gunicorn service..."
if systemctl list-units --type=service | grep -q "$GUNICORN_SERVICE_NAME"; then
    if systemctl is-active --quiet "$GUNICORN_SERVICE_NAME"; then
        systemctl restart "$GUNICORN_SERVICE_NAME"
    else
        log "Gunicorn service is not active. Starting..."
        systemctl start "$GUNICORN_SERVICE_NAME"
    fi
else
    log "Gunicorn service file not found. Please ensure the service is properly set up."
    exit 1
fi

# Optionally, restart Nginx if used
# log "Restarting Nginx..."
# systemctl restart nginx

log "Deployment to staging completed successfully!"
