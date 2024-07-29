# Use a smaller base image: Alpine Linux is a lightweight alternative to Ubuntu
FROM python:3.11-alpine 

# Install essential packages (including build dependencies for later steps)
RUN apk add --no-cache --virtual .build-deps \
    gcc musl-dev libffi-dev openssl-dev \
    && pip install --upgrade pip \
    && apk del .build-deps

# Create a non-root user and switch to it (for security)
RUN adduser -D appuser
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
CMD ["ttyd", "-p", "80", "-t", "titleFixed=true", "sh", "-c", "nohup /venv/bin/python3 /app/script.py 2>&1 | tail -f /proc/self/fd/0"]
