# Use the official Node.js 22 Alpine image as base
FROM node:22-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm@10.12.1

# Copy package files for dependency resolution
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

# Copy all package.json files to enable proper dependency resolution
COPY packages/*/package.json ./packages/*/
COPY packages/@n8n/*/package.json ./packages/@n8n/*/

# Install dependencies with frozen lockfile
RUN pnpm install --frozen-lockfile

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm@10.12.1

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/packages ./packages

# Copy source code and configuration files
COPY . .

# Set environment variables for build
ENV NODE_ENV=production
ENV DOCKER_BUILD=true

# Build the application using the build script
RUN pnpm build

# Create production deployment using the same script as the project
RUN pnpm --filter=n8n --prod --legacy deploy --no-optional ./compiled

# Production image, copy all the files and run n8n
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 n8n

# Copy the compiled application from builder stage
COPY --from=builder --chown=n8n:nodejs /app/compiled ./

# Copy task runner if it exists
COPY --from=builder --chown=n8n:nodejs /app/dist/task-runner-javascript ./task-runner-javascript

# Set the correct permissions
RUN chown -R n8n:nodejs /app

# Switch to non-root user
USER n8n

# Expose the port n8n runs on
EXPOSE 5678

# Set environment variables
ENV PORT=5678
ENV HOSTNAME="0.0.0.0"
ENV N8N_HOST="0.0.0.0"
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV WEBHOOK_URL=http://localhost:5678/

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5678/healthz', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Start n8n
CMD ["node", "bin/n8n"]
