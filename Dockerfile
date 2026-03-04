# Lightweight Nginx image to serve static content
FROM nginx:alpine

# Copy the static site to the Nginx html directory
COPY index.html /usr/share/nginx/html/index.html

# Expose HTTP port
EXPOSE 80
