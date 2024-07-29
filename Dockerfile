# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Install dependencies: python, pip, ttyd
RUN apt-get update && \
    apt-get install -y python3 python3-pip ttyd && \
    apt-get clean && \
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
