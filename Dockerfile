# Start from an official image that already has Node.js installed
FROM node:lts-alpine AS build

# Work inside a folder called /app in the container
WORKDIR /app

# Copy the project files into the container
COPY app/ .

# Install the app's dependencies
RUN npm ci --omit=dev

# Start a fresh, clean image for the final result
FROM node:lts-alpine

# Work inside a folder called /app in the container
WORKDIR /app

# Copy only what the app needs from the build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./
COPY --from=build /app/src ./src

# The app listens on port 3000
EXPOSE 3000

# Command that starts the app
CMD ["node", "src/index.js"]