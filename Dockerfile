# Dockerfile optimizado para EasyPanel
# Usa la imagen oficial de n8n para evitar problemas de compilación

FROM docker.n8n.io/n8nio/n8n:latest

# Variables de entorno para configuración básica
ENV NODE_ENV=production
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV N8N_HOST=0.0.0.0

# Crear directorio para datos persistentes
RUN mkdir -p /home/node/.n8n

# Establecer permisos correctos
USER root
RUN chown -R node:node /home/node/.n8n

# Cambiar al usuario node para seguridad
USER node

# Exponer el puerto 5678
EXPOSE 5678

# Health check para verificar que el servicio está funcionando
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5678/healthz || exit 1

# Comando por defecto
CMD ["n8n", "start", "--tunnel"]