# token for getting cortexcli image
ARG TOKEN

# --- Stage 1: Certificate Preparation ---
# Use a minimal Debian/Ubuntu-based image for preparing certificates.
# This keeps the final image clean by not carrying build-time dependencies.
FROM ubuntu:latest AS cert-builder

# Install the ca-certificates package if not already present
# This package provides the update-ca-certificates utility
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy your custom certificate bundle into a location where update-ca-certificates can find it.
COPY custom-ca-bundle.crt /usr/local/share/ca-certificates/custom-ca-bundle.crt

# Update the CA certificates store in this builder stage.
# This command processes the .crt files in /usr/local/share/ca-certificates/
# and generates the /etc/ssl/certs/ca-certificates.crt bundle.
RUN update-ca-certificates

# --- Stage 2: Final Cortexcli Image ---
FROM distributions.traps.paloaltonetworks.com/cli-docker/$TOKEN/method:arm64-0.13.0

# Copy the generated, updated certificate bundle from the 'cert-builder' stage.
# This ensures only the final, processed bundle is included, not the tools used to create it.
# /etc/ssl/certs/ca-certificates.crt is the standard location for the combined bundle on Debian/Ubuntu.
COPY --from=cert-builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# If your base image might have its own update-ca-certificates process
# or if you want to be absolutely sure the copied bundle is active,
# you can run update-ca-certificates again in the final stage.
# This is often redundant if the bundle is directly overwritten, but can be a safeguard.
USER root
RUN update-ca-certificates
CMD ./cortexcli
