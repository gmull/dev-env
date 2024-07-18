# Use Ubuntu Latest as the base image
FROM ubuntu:22.04

# Set maintainer information
LABEL maintainer="gerald.mull@gmail.com"

# Argument for Software versions
ARG GOLANG_VERSION=1.22.3
ARG DOTNET_SDK_VERSION=6.0
ARG PYTHON_VERSION=3.10
ARG TERRAFORM_VERSION=1.3.0
ARG ISTIO_VERSION=1.22.2

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Install basic utilities and software properties
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    software-properties-common \
    build-essential \
    apt-transport-https \
    ca-certificates \
    lsb-release \
    gnupg \
    zip \
    unzip \
    openssh-client \
    mysql-client \
    jq \
    vim \
    nano \
    tmux \
    screen

# Install Python 3 and pip
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install -y \
    python${PYTHON_VERSION} \
    python3-pip

# Update PIP and Packages
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade setuptools wheel  && \
    python3 -m pip install --upgrade pypi

# Alias Python to Python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Golang
RUN wget https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    tar -xvf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    mv go /usr/local
ENV PATH="$PATH:/usr/local/go/bin"

# Install .NET SDK
RUN apt-get update && \
    apt-get install -y aspnetcore-runtime-${DOTNET_SDK_VERSION}

# Install Java (OpenJDK)
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli

# Install Azure Functions Core Tools
RUN wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install azure-functions-core-tools-4

# Install Azure AKS CLI
RUN az aks install-cli

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && apt-get install -y google-cloud-sdk && \
    apt-get install google-cloud-cli-gke-gcloud-auth-plugin

# Install Istio
RUN curl -L https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istio-$ISTIO_VERSION-linux-amd64.tar.gz | tar xz \
    && mv istio-$ISTIO_VERSION /opt/istio \
    && export PATH=/opt/istio/bin:$PATH
    
# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install OPA for policy enforcement
RUN wget https://openpolicyagent.org/downloads/latest/opa_linux_amd64 \
    && chmod 755 opa_linux_amd64 \
    && mv opa_linux_amd64 /usr/local/bin/opa

# Install Ruby and RubyGems
RUN apt-get update && apt-get install -y ruby-full && \
    gem install jekyll bundler

# Install Ansible
RUN add-apt-repository --yes --update ppa:ansible/ansible && \
    apt-get install -y ansible

# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add - && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install -y helm
    

# Clean up APT and temporary files to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Define environment variable for the username
ENV USERNAME=ubuntu

# Create a user based on the environment variable
RUN useradd -m -s /bin/bash ${USERNAME}

# Set user context
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Copy the entrypoint script with correct host permissions and ensure it's executable
COPY --chown=${USERNAME}:${USERNAME} entrypoint.sh /home/${USERNAME}/entrypoint.sh
RUN chmod +x /home/${USERNAME}/entrypoint.sh

# Ensure that user has correct permissions to their home directory
USER root
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Set the entry point to the startup script
ENTRYPOINT ["/home/ubuntu/entrypoint.sh"]
CMD ["/bin/bash"]