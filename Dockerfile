# -------------------
# Stage 1: Build Node.js App
# -------------------
FROM node:22-alpine as builder

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

# -------------------
# Stage 2: Final image with Nginx + Node.js + PM2
# -------------------
FROM nginx:alpine

# Install Node.js & PM2
RUN apk add --no-cache nodejs npm && \
    npm install -g pm2 \
    npm install -g express

# Set working directory for app
WORKDIR /app

# Copy app from builder stage
COPY --from=builder /app /app

# Copy nginx config (overwriting default)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificate files
COPY fullchain.pem /etc/nginx/ssl/fullchain.pem
COPY privkey.pem /etc/nginx/ssl/privkey.pem

# Expose both backend and proxy ports
EXPOSE 80 3000 443

# Start Node.js (via PM2) and Nginx together
CMD sh -c "pm2 start index.js && nginx -g 'daemon off;'"

