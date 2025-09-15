ARG NODE_VERSION=22

# ==============================================================================
# STAGE 1: Builder for Base Dependencies
# ==============================================================================
FROM node:${NODE_VERSION}-alpine AS builder

# Install fonts
RUN \
  apk --no-cache add --virtual .build-deps-fonts msttcorefonts-installer fontconfig && \
  update-ms-fonts && \
  fc-cache -f && \
  apk del .build-deps-fonts && \
  find /usr/share/fonts/truetype/msttcorefonts/ -type l -exec unlink {} \;

# Install essential OS dependencies
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.22/main" >> /etc/apk/repositories && echo "https://dl-cdn.alpinelinux.org/alpine/v3.22/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
        git \
        openssh \
        openssl \
        graphicsmagick \
        tini \
        tzdata \
        ca-certificates \
        libc6-compat \
        jq \
        curl

# Install full-icu
RUN npm install -g full-icu@1.5.0

RUN rm -rf /tmp/* /root/.npm /root/.cache/node /opt/yarn* && \
  apk del apk-tools

# ==============================================================================
# STAGE 2: Final Base Runtime Image
# ==============================================================================
FROM node:${NODE_VERSION}-alpine

COPY --from=builder / /

WORKDIR /home/node

# Install pnpm globally
RUN npm install -g pnpm@latest

# Set environment variables
ENV NODE_ICU_DATA=/usr/local/lib/node_modules/full-icu
ENV N8N_PORT=5678
ENV N8N_LISTEN_ADDRESS=0.0.0.0
ENV NODE_ENV=production

# Expose port
EXPOSE 5678/tcp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5678/healthz || exit 1

# Use existing node user
USER node

# Copy application files
COPY --chown=node:node . .

# Install dependencies using pnpm
RUN pnpm install --prod --frozen-lockfile && \
    pnpm store prune

# Start the application
ENTRYPOINT ["tini", "--"]
CMD ["node", "packages/cli/bin/n8n"]