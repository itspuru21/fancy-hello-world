# Stage 1: The Node Builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
# Compiles your code into static HTML/CSS/JS in the /dist folder
RUN npm run build 

# Stage 2: The Nginx Server
FROM nginx:alpine
# Delete the default Nginx config
RUN rm /etc/nginx/conf.d/default.conf
# Copy in our custom reverse proxy config
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copy the built Vite files from Stage 1 into Nginx's hosting directory
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]