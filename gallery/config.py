import os
from dotenv import load_dotenv
import requests

METADATA_URL = "http://metadata.google.internal/computeMetadata/v1/instance/attributes/"
HEADERS = {"Metadata-Flavor": "Google"}

def get_metadata(path):
    url = f"{METADATA_URL}{path}"
    response = requests.get(url, headers=HEADERS)
    response.raise_for_status()
    return response.text

# Google Cloud SQL Connection
DB_USER = get_metadata("DB_USERNAME")
DB_PASSWORD = get_metadata("DB_PASSWORD")

DB_NAME = get_metadata("DB_NAME")
DB_INSTANCE_CONNECTION_NAME = get_metadata("DB_CONN")

# Google Cloud Storage
GCS_BUCKET_NAME = get_metadata("BUCKET_NAME")


class Config:
    # Google Cloud SQL Connection
    DB_USER = DB_USER
    DB_PASSWORD = DB_PASSWORD

    DB_NAME = DB_NAME
    DB_INSTANCE_CONNECTION_NAME = DB_INSTANCE_CONNECTION_NAME

    GCS_BUCKET_NAME = GCS_BUCKET_NAME
