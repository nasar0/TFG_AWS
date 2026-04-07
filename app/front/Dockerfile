# Etapa 1: Construcción (Build)
FROM node:20-alpine AS build

WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos dependencias con límite de memoria para evitar fallos en entornos limitados
RUN NODE_OPTIONS="--max-old-space-size=1024" npm install

# Copiamos el resto del código fuente
COPY . .

# Ejecutamos el build con límite de memoria
RUN NODE_OPTIONS="--max-old-space-size=1024" npm run build

# Etapa 2: Producción (Servidor Nginx)
FROM nginx:stable-alpine

# Copiamos los archivos generados desde la etapa de build
# Nota: Asegúrate de que tu carpeta de salida sea 'dist' (común en Vite) o 'build'
COPY --from=build /app/build /usr/share/nginx/html

# Copiamos la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]