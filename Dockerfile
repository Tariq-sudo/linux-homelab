FROM nginx:alpine

# Copy a custom index page
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
