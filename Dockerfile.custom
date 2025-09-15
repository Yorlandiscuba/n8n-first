ARG NODE_VERSION=20

# 1. Create an image to build n8n
FROM --platform=linux/amd64 n8nio/base:${NODE_VERSION} AS builder

# Build the application from source
WORKDIR /src
COPY . /src

# Configurar npm para usar mirror más rápido y más reintentos
RUN npm config set registry https://registry.npmmirror.com/ && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retry-maxtimeout 120000

# Aplicar nuestros parches para habilitar características enterprise
RUN sed -i 's/return this.isLicensed(LICENSE_FEATURES.SHARING);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.LOG_STREAMING);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.LDAP);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.SAML);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.API_KEY_SCOPES);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.AI_ASSISTANT);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.ASK_AI);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.AI_CREDITS);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.ADVANCED_EXECUTION_FILTERS);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.ADVANCED_PERMISSIONS);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.DEBUG_IN_EDITOR);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.BINARY_DATA_S3);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.MULTIPLE_MAIN_INSTANCES);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.VARIABLES);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.SOURCE_CONTROL);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.EXTERNAL_SECRETS);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.WORKFLOW_HISTORY);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.API_DISABLED);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.WORKER_VIEW);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.PROJECT_ROLE_ADMIN);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.PROJECT_ROLE_EDITOR);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.PROJECT_ROLE_VIEWER);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.COMMUNITY_NODES_CUSTOM_REGISTRY);/return true;/g' packages/cli/src/license.ts && \
    sed -i 's/return this.isLicensed(LICENSE_FEATURES.FOLDERS);/return true;/g' packages/cli/src/license.ts

# Modificar frontend.service.ts para habilitar características enterprise
RUN sed -i 's/sharing: false,/sharing: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/ldap: false,/ldap: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/saml: false,/saml: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/logStreaming: false,/logStreaming: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/advancedExecutionFilters: false,/advancedExecutionFilters: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/variables: false,/variables: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/sourceControl: false,/sourceControl: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/auditLogs: false,/auditLogs: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/externalSecrets: false,/externalSecrets: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/showNonProdBanner: false,/showNonProdBanner: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/debugInEditor: false,/debugInEditor: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/binaryDataS3: false,/binaryDataS3: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/workflowHistory: false,/workflowHistory: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/workerView: false,/workerView: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/advancedPermissions: false,/advancedPermissions: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/apiKeyScopes: false,/apiKeyScopes: true,/g' packages/cli/src/services/frontend.service.ts && \
    sed -i 's/limit: 0,/limit: 999999,/g' packages/cli/src/services/frontend.service.ts

# Instalar dependencias y construir
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN --mount=type=cache,id=pnpm-store,target=/root/.local/share/pnpm/store --mount=type=cache,id=pnpm-metadata,target=/root/.cache/pnpm/metadata DOCKER_BUILD=true pnpm install --no-frozen-lockfile
RUN pnpm build

# Delete all dev dependencies
RUN jq 'del(.pnpm.patchedDependencies)' package.json > package.json.tmp; mv package.json.tmp package.json
RUN node .github/scripts/trim-fe-packageJson.js

# Delete any source code or typings
RUN find . -type f -name "*.ts" -o -name "*.vue" -o -name "tsconfig.json" -o -name "*.tsbuildinfo" | xargs rm -rf

# Deploy the `n8n` package into /compiled
RUN mkdir /compiled
RUN NODE_ENV=production DOCKER_BUILD=true pnpm --filter=n8n --prod --no-optional --legacy deploy /compiled

# 2. Start with a new clean image with just the code that is needed to run n8n
FROM n8nio/base:${NODE_VERSION}
ENV NODE_ENV=production

LABEL org.opencontainers.image.title="n8n-enterprise"
LABEL org.opencontainers.image.description="Workflow Automation Tool with Enterprise Features"
LABEL org.opencontainers.image.source="https://github.com/n8n-io/n8n"
LABEL org.opencontainers.image.url="https://n8n.io"

WORKDIR /home/node
COPY --from=builder /compiled /usr/local/lib/node_modules/n8n
COPY docker/images/n8n/docker-entrypoint.sh /

# Setup the Task Runner Launcher
ARG TARGETPLATFORM
ARG LAUNCHER_VERSION=1.1.2
COPY docker/images/n8n/n8n-task-runners.json /etc/n8n-task-runners.json
# Download, verify, then extract the launcher binary
RUN \
	if [[ "$TARGETPLATFORM" = "linux/amd64" ]]; then export ARCH_NAME="amd64"; \
	elif [[ "$TARGETPLATFORM" = "linux/arm64" ]]; then export ARCH_NAME="arm64"; fi; \
	mkdir /launcher-temp && \
	cd /launcher-temp && \
	wget https://github.com/n8n-io/task-runner-launcher/releases/download/${LAUNCHER_VERSION}/task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz && \
	wget https://github.com/n8n-io/task-runner-launcher/releases/download/${LAUNCHER_VERSION}/task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz.sha256 && \
	echo "$(cat task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz.sha256) task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz" > checksum.sha256 && \
	sha256sum -c checksum.sha256 && \
	tar xvf task-runner-launcher-${LAUNCHER_VERSION}-linux-${ARCH_NAME}.tar.gz --directory=/usr/local/bin && \
	cd - && \
	rm -r /launcher-temp

RUN \
	cd /usr/local/lib/node_modules/n8n && \
	npm rebuild sqlite3 && \
	cd - && \
	ln -s /usr/local/lib/node_modules/n8n/bin/n8n /usr/local/bin/n8n && \
	mkdir .n8n && \
	chown node:node .n8n

ENV SHELL=/bin/sh
USER node
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"] 