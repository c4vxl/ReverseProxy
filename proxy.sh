#!/bin/bash

#
# Reverse Proxy installer using Nginx by c4vxl
# @author c4vxl
# @version 1.0.0
#

download_packages() {
    # download libraries
    echo "Downloading apt-Packages..."
    sudo apt-get install certbot nginx -y
}

add_stream() {
    host = `$host`
    # create stream config
    config="
stream {
    server {
        listen $port;
        proxy_pass $forward_to:$forward_port;
    }
}
"

    # Add the generated stream configuration to the Nginx configuration
    echo "$config" | sudo tee -a /etc/nginx/nginx.conf

    save_config
}

add_https() {
    sudo echo "">/etc/nginx/sites-available/default

    # add http forward
    add_http

    echo ""
    echo ""
    echo "Creating https config.."
    echo ""
    echo ""

    # create ssl certificate
    sudo certbot certonly --standalone -d $domain

    # create https config
    config="
server {
    listen 443 ssl;
    server_name $domain;

    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

    location / {
        proxy_pass http://$forward_to;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}"

    # Add the generated configuration to the Nginx default site configuration
    echo "$config" | sudo tee -a /etc/nginx/sites-available/default

    save_config
}

add_http() {
    sudo echo "">/etc/nginx/sites-available/default

    echo ""
    echo ""
    echo "Creating http config.."
    echo ""
    echo ""

    # create http config
    config="
server {
    listen $port;
    server_name $domain;

    location / {
        proxy_pass http://$forward_to;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}"

    # Add the generated configuration to the Nginx default site configuration
    echo "$config" | sudo tee -a /etc/nginx/sites-available/default

    save_config
}

save_config() {
    # Test configuration and restart Nginx
    sudo nginx -t
    sudo systemctl restart nginx
}


reset
download_packages

main() {
    reset

    read -p "Enter the Domain: " domain
    read -p "Enter Server the connection should be forwarded: " forward_to
    read -p "Please enter the Port to listen to: " port
    read -p "Enter the Type ([1] HTTP, [2] HTTPS, [3] STREAM): " type

    reset

    echo ""
    echo ""
    echo "============================="
    echo "Configuration: "
    echo "Domain: $domain"
    echo "Port: $port"
    echo "Forward domain: $forward_to"
    echo "Forward port: $forward_port"
    echo "Type: $type"
    echo "============================="
    echo ""
    echo ""


    if [ "$type" == "1" ]; then
        add_http
    fi

    if [ "$type" == "2" ]; then
        add_https
    fi

    if [ "$type" == "3" ]; then
        read -p "Please enter the Port to forward to: " forward_port
        add_stream
    fi
}


# Main script
while true; do
    main

    # Get user input for the next iteration
    read -p "Do you want to add another Domain (Y/N): " should_rerun

    # Check if user wants to rerun or exit
    if [ "$should_rerun" != "Y" ] && [ "$should_rerun" != "y" ]; then
	reset
        echo "Complete! Exiting..."
        break
    fi
done
