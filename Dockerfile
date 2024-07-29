# Use the official Python image based on Debian
FROM python:3.11-slim-buster

# Download and install ttyd binary
RUN apt-get update && \
    apt-get install -y curl && \
    curl -L https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 -o /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*
    
# Create a non-root user and switch to it (for security)
RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /home/appuser/app

# Copy requirements.txt first (for efficient caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your Python script 
COPY script.py .

# Expose the port
EXPOSE 80

# Use a more efficient CMD to start ttyd and the script
CMD ["ttyd", "-p", "80", "-t", "titleFixed=true", "sh", "-c", "nohup python3 /app/script.py 2>&1 | tail -f /proc/self/fd/0"]
