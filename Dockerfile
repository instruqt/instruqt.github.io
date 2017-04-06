FROM nginx

# Nginx config.
COPY nginx.conf /etc/nginx/nginx.conf

# Website files.
COPY fonts /www/fonts
COPY img /www/img
COPY css /www/css

# Website.
COPY index.html /www/index.html
