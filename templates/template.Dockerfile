FROM amd64/ubuntu:jammy

# Install basic utilities and packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    gnupg2 \
    jq \
    curl \
    unzip \
    vim \
    python3 \
    python3-pip \
    wget \
    git \
    less \
    build-essential \
    --no-install-recommends && \
    apt-get -q -y clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install aws-azure-login CLI tool globally using npm
RUN npm install -g aws-azure-login --loglevel=silent

# Create necessary directories
RUN mkdir -p /app /root/.aws /app/pim

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install -i /usr/local/aws -b /usr/local/bin && \
    rm -rf awscliv2.zip aws

# Install terraform
RUN curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg && \
    install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/ && \
    apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y terraform

# Install Cloudera CDP CLI
RUN pip3 install cdpcli boto3

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Puppeteer dependencies (for Chromium)
RUN apt-get install -y \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm-dev \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    libxshmfence1 \
    xvfb

# Set the working directory
WORKDIR /app

# Add an entrypoint script for cloning/updating the Git repository
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Clean up to reduce image size
RUN apt-get -q -y clean && \
   rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
