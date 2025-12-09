# STAGE 1 : build Vue
FROM node:20-alpine AS builder

WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm ci

# Copier le reste du code
COPY . .

# Build Vite / Vue
RUN npm run build


# STAGE 2 : Nginx pour servir le front
FROM nginx:alpine AS production

# Supprimer la config Nginx par défaut
RUN rm /etc/nginx/conf.d/default.conf
# Copier la config Nginx custom
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les assets buildés
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
