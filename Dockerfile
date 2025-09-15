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
COPY lerna.json ./
COPY packages/*/package.json ./packages/*/

# Install dependencies
RUN npm ci --only=production --ignore-scripts

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine AS production

# Install runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    curl

# Create n8n user (handle existing node user)
RUN addgroup -g 1001 n8n && \
    adduser -u 1001 -G n8n -s /bin/sh -D n8n

# Set working directory
WORKDIR /app

# Copy built application from builder stage
COPY --from=builder --chown=n8n:n8n /app/dist ./dist
COPY --from=builder --chown=n8n:n8n /app/node_modules ./node_modules
COPY --from=builder --chown=n8n:n8n /app/packages ./packages
COPY --from=builder --chown=n8n:n8n /app/package*.json ./
COPY --from=builder --chown=n8n:n8n /app/lerna.json ./

# Create necessary directories
RUN mkdir -p /app/data && \
    chown -R n8n:n8n /app/data

# Switch to n8n user
USER n8n

# Expose port
EXPOSE 5678

# Set environment variables
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV N8N_HOST=0.0.0.0

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Start n8n
CMD ["node", "packages/cli/bin/n8n"]