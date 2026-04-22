FROM node:22 AS builder

WORKDIR /app

# Install dependencies first
COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build


FROM node:22-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Install only production dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy backend source
COPY src ./src

# Copy built frontend from previous stage
COPY --from=builder /app/static ./static

# Fix permissions for app directory
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose app port
EXPOSE 3000

# Start server
CMD ["node", "src/server/app.js"]