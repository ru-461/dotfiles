FROM ubuntu:20.04

# Install the minimum required packages.
RUN apt-get update && apt-get install -y git curl sudo ca-certificates --no-install-recommends

# Copy bootstrap script
COPY bootstrap.sh /

CMD [ "bin/bash" ]