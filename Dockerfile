# Use Node.js 20 Alpine as base image
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    ca-certificates \
    tzdata

# Copy package files
COPY package*.json ./
COPY packages ./packages
COPY tsconfig*.json ./
COPY .npmrc ./

# Install dependencies
RUN npm ci --include=dev

# Build the project
RUN npm run build

# Production stage
FROM node:20-alpine AS production

# Install runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    curl

# Create n8n user
RUN addgroup -g 1000 node && \
    adduser -u 1000 -G node -s /bin/sh -D node

# Set working directory
WORKDIR /home/node

# Copy built application from builder stage
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=builder --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/package*.json ./

# Create necessary directories
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n

# Switch to n8n user
USER node

# Expose port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Set environment variables
ENV NODE_ENV=production
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_VERSION_NOTIFICATIONS_ENABLED=false

# Start n8n
CMD ["node", "dist/cli/bin/n8n", "start"]