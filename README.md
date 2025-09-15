# n8n Enterprise Unlocked

Este es n8n con todas las restricciones de licencia enterprise desbloqueadas.

## 🚀 Características Desbloqueadas

- ✅ **Todas las características enterprise** habilitadas
- ✅ **Sin límites de usuarios** (ilimitado)
- ✅ **Sin límites de workflows activos** (ilimitado)
- ✅ **Sin límites de variables** (ilimitado)
- ✅ **Sin límites de proyectos de equipo** (ilimitado)
- ✅ **AI Credits ilimitados**
- ✅ **Workflow History ilimitado**
- ✅ **Custom NPM Registry habilitado**
- ✅ **Multi-Main Instances habilitado**
- ✅ **LDAP/SAML/OIDC habilitado**
- ✅ **Source Control habilitado**
- ✅ **External Secrets habilitado**
- ✅ **Advanced Permissions habilitado**
- ✅ **API Key Scopes habilitado**
- ✅ **Folders habilitado**
- ✅ **Log Streaming habilitado**
- ✅ **Debug in Editor habilitado**
- ✅ **Binary Data S3 habilitado**

## 🐳 Construcción con Docker

### Opción 1: Docker Compose (Recomendado)

```bash
# Construir y ejecutar
docker-compose up --build

# Acceder a n8n
# URL: http://localhost:5678
# Usuario: admin
# Contraseña: admin123
```

### Opción 2: Docker Build Manual

```bash
# Construir la imagen
docker build -t n8n-enterprise .

# Ejecutar el contenedor
docker run -d \
  --name n8n-enterprise \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=admin123 \
  -v n8n_data:/home/node/.n8n \
  n8n-enterprise
```

## 📋 Instrucciones de Uso

1. **Clonar el repositorio** (si aún no lo has hecho)
2. **Ejecutar con Docker Compose**:
   ```bash
   docker-compose up --build
   ```
3. **Acceder a la interfaz web**:
   - URL: http://localhost:5678
   - Credenciales: admin/admin123

## 🔧 Variables de Entorno

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `N8N_BASIC_AUTH_ACTIVE` | Activar autenticación básica | `true` |
| `N8N_BASIC_AUTH_USER` | Usuario para autenticación | `admin` |
| `N8N_BASIC_AUTH_PASSWORD` | Contraseña para autenticación | `admin123` |
| `N8N_HOST` | Host del servidor | `localhost` |
| `N8N_PORT` | Puerto del servidor | `5678` |
| `N8N_PROTOCOL` | Protocolo (http/https) | `http` |
| `WEBHOOK_URL` | URL para webhooks | `http://localhost:5678/` |

## 📝 Notas Importantes

- **Esta versión tiene todas las restricciones de licencia desactivadas**
- **No requiere licencia válida para funcionar**
- **Todas las características enterprise están disponibles**
- **Los límites de cuota están establecidos a ilimitado (-1)**

## 🔄 Actualización

Para actualizar con nuevos cambios:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up
```

## 🆘 Solución de Problemas

Si encuentras problemas:
1. Verifica que Docker esté instalado y ejecutándose
2. Asegúrate de que el puerto 5678 esté disponible
3. Revisa los logs con: `docker-compose logs -f n8n`
4. Para reiniciar: `docker-compose restart n8n`
