#!/bin/bash

# Usage: ./bundle.sh [--from-git <git_url>] OR just ./bundle.sh

START_SCRIPT="start.sh"
GIT_MODE=false
GIT_URL=""

if [[ "$1" == "--from-git" && -n "$2" ]]; then
    GIT_MODE=true
    GIT_URL="$2"
fi

# Start writing the start.sh file
cat <<'EOF' > "$START_SCRIPT"
#!/bin/bash
EOF

if [ "$GIT_MODE" = true ]; then
    cat <<EOF >> "$START_SCRIPT"

# Clone the repository
echo "Cloning repository from $GIT_URL"
git clone "$GIT_URL" gallery

# Install dependencies and run Flask app
cd gallery
sudo apt-get update
sudo apt-get install -yq python3-pip python3-venv git
python3 -m venv gallery_venv
source gallery_venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
export FLASK_APP="main.py"
export FLASK_RUN_PORT="80"
export FLASK_RUN_HOST="0.0.0.0"
flask run
EOF

else
    # Bundle directory as tarball, base64 it
    tar -czf out.tar.gz --exclude=bundle.sh --exclude="$START_SCRIPT" --exclude=out.tar.gz .
    encoded_tarball=$(base64 -i out.tar.gz)

    echo 'tarball="' >> "$START_SCRIPT"
    echo "$encoded_tarball" >> "$START_SCRIPT"
    echo '"' >> "$START_SCRIPT"

    cat <<'EOF' >> "$START_SCRIPT"

# Decode the tarball and extract it
mkdir gallery
echo "Restoring files to the 'gallery' directory..."
echo "$tarball" | base64 --decode | tar -xz -C gallery

echo "Files have been restored inside the 'gallery' directory."

# Install dependencies and run Flask app
sudo apt-get update
sudo apt-get install -yq python3-pip python3-venv

cd gallery
python3 -m venv gallery_venv
source gallery_venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
export FLASK_APP="main.py"
export FLASK_RUN_PORT="80"
export FLASK_RUN_HOST="0.0.0.0"
flask run
EOF
fi

echo "The $START_SCRIPT script has been created."
