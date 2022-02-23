FROM ubuntu:20.04

# Install the minimum required packages.
RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    sudo \
    ca-certificates

# Copy bootstrap script
COPY bootstrap.sh /

CMD [ "bin/bash" ]