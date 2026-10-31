FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for spaCy, camelot, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ghostscript \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN python -m spacy download en_core_web_sm

COPY . .

# Create necessary directories
RUN mkdir -p dump/structured_db uploads faiss_dbs

# Expose port (Railway sets PORT env var)
EXPOSE 8000

# Command to run the application
CMD gunicorn --bind 0.0.0.0:${PORT:-8000} --timeout 120 --workers 2 app:app
