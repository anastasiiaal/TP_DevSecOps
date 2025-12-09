# STAGE 1 : build / deps
FROM node:20 AS builder
# ou FROM node:20-slim si tu veux

WORKDIR /app

# Copier Prisma + dépendances
COPY package*.json ./
COPY prisma ./prisma

# Installer toutes les dépendances (incluant Prisma)
RUN npm ci

# Copier le reste du code
COPY . .

# Générer le client Prisma
RUN npx prisma generate


# STAGE 2 : image de prod
FROM node:20 AS production

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

COPY package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/src ./src

EXPOSE 3000

CMD ["node", "src/index.js"]
