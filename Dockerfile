# ---- Stage 1: Fetch Mattermost + MostlyMatter ----
    FROM debian:bookworm-slim AS fetcher

    ARG MOSTLYMATTER_VERSION=v10.11.3
    ARG MATTERMOST_VERSION=10.11.3
    
    ARG MM_DOWNLOAD_URL=https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-${MATTERMOST_VERSION}-linux-amd64.tar.gz
    ARG MOSTLY_DOWNLOAD_URL=https://packages.framasoft.org/projects/mostlymatter/mostlymatter-amd64-${MOSTLYMATTER_VERSION}
    
    RUN apt-get update && apt-get install -y --no-install-recommends \
        curl ca-certificates tar \
        && rm -rf /var/lib/apt/lists/*
    
    WORKDIR /tmp
    
    # Download and extract official Mattermost release
    RUN curl -L $MM_DOWNLOAD_URL | tar -xz
    
    # Download MostlyMatter binary and overwrite Mattermost's binary
    RUN curl -L -o mostlymatter $MOSTLY_DOWNLOAD_URL && \
        chmod +x mostlymatter && \
        mv mostlymatter mattermost/bin/
    
    
    # ---- Stage 2: Runtime container ----
    FROM debian:bookworm-slim
    
    # Add runtime deps for Mattermost
    RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates tzdata \
        && rm -rf /var/lib/apt/lists/*
    
    # Create mattermost user
    RUN useradd --system --create-home --uid 2000 mattermost
    
    WORKDIR /mattermost
    
    # Copy prepared Mattermost tree with MostlyMatter binary inside
    COPY --from=fetcher /tmp/mattermost /mattermost
    
    # Adjust permissions
    RUN chown -R mattermost:mattermost /mattermost
    
    USER mattermost
    
    EXPOSE 8065
    
    ENTRYPOINT ["/mattermost/bin/mostlymatter"]
    CMD ["server"]
    