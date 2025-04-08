# Base image
FROM node:22-alpine

# Install PM2 globally
RUN npm install -g pm2

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy all source code
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Start the app with PM2
CMD ["pm2-runtime", "index.js"]
