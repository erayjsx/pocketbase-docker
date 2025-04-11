# Build stage (optional, if building from source)
# ...

# Final stage
FROM debian:stable-slim AS final

# Install necessary packages like ca-certificates
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Download PocketBase (replace X.Y.Z with the actual version)
ARG PB_VERSION=0.26.6
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# Set working directory
WORKDIR /pb

# Create data directory (will be mounted over)
RUN mkdir -p /pb/pb_data

# Expose the default port Cloud Run expects (or the one you configure)
# Cloud Run will set the PORT env var, PocketBase will use it via the command arg
EXPOSE 8080

# Start PocketBase, listening on all interfaces and the port from $PORT
# Health check endpoint is /api/health
CMD ["./pocketbase", "serve", "--http=0.0.0.0:${PORT}"]
