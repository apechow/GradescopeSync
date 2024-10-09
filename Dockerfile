# Use an ARM-compatible base image
FROM python:3.9-slim-buster

# Install tzdata for timezone settings
RUN apt-get update && apt-get install -y tzdata

# Set the timezone to PST
ENV TZ=America/Los_Angeles

# Install cron
RUN apt-get update && apt-get install -y cron

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Give execution rights to the script
RUN chmod +x /app/main.py

# Copy the cron job file
COPY crontab.txt /etc/cron.d/gradescopesync-job

# Give execution rights to the cron job file
RUN chmod 0644 /etc/cron.d/gradescopesync-job

# Apply the cron job
RUN crontab /etc/cron.d/gradescopesync-job

# Start cron in the foreground
CMD ["cron", "-f"]





