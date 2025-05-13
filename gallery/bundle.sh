#!/bin/bash

# Output the start.sh script
cat <<'EOF' > start.sh
#!/bin/bash

EOF

tar -czf out.tar.gz --exclude=bundle.sh --exclude=start.sh --exclude=out.tar.gz .
encoded_tarball=$(base64 -i out.tar.gz)

echo 'tarball="' >> start.sh

echo $encoded_tarball >> start.sh

echo '"' >> start.sh

cat <<'EOF' >> start.sh
# Decode the tarball and extract it
mkdir gallery
echo "Restoring files to the 'gallery' directory..."
echo "$tarball" | base64 --decode | tar -xz -C gallery

echo "Files have been restored inside the 'gallery' directory."

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -yq python3-pip python3-venv


# Run the flask app under a venv
cd gallery
python3 -m venv gallery_venv
source gallery_venv/bin/activate
pip install --upgrade pip
pip install -r ./requirements.txt
export FLASK_APP="main.py"
export FLASK_RUN_PORT="80"
export FLASK_RUN_HOST="0.0.0.0"
flask run
EOF

echo "The start.sh script has been created."
