# Gunakan Node.js versi LTS
FROM node:20-slim

# Install dependencies yang dibutuhkan Prisma (openssl)
RUN apt-get update -y && apt-get install -y openssl

WORKDIR /app

# Copy package files dulu biar layer caching lebih efisien
COPY package*.json ./
COPY prisma ./prisma
COPY prisma.config.ts ./

# Install semua dependencies (termasuk devDependencies buat build)
RUN npm install

# Copy semua source code
COPY . .

# Generate Prisma Client
RUN npx prisma generate

# Compile TypeScript ke JavaScript (folder dist/)
RUN npm run build

# Expose port (sesuaikan kalau app kamu pakai port lain)
EXPOSE 3000

# Jalankan migrasi Prisma lalu start server
CMD npx prisma migrate deploy && npm start
