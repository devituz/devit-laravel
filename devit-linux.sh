#!/bin/bash

echo "Checking if Docker, Docker Compose, PHP, and Composer are installed..."

echo "Setting permissions to 777 for project directory files..."
sudo chmod -R 777 /home/devit/Work/laravel/DynamicCrud


if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    if [ $? -ne 0 ]; then
        echo "Failed to install Docker. Exiting."
        exit 1
    fi
else
    echo "Docker is installed."
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo apt-get install -y docker-compose
    if [ $? -ne 0 ]; then
        echo "Failed to install Docker Compose. Exiting."
        exit 1
    fi
else
    echo "Docker Compose is installed."
fi

if ! command -v composer &> /dev/null; then
    echo "Composer is not installed. Installing Composer..."
    EXPECTED_SIGNATURE=$(wget -qO - https://composer.github.io/installer.sig)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');")
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        exit 1
    fi
    php composer-setup.php
    if [ $? -ne 0 ]; then
        echo "Failed to install Composer. Exiting."
        exit 1
    fi
    sudo mv composer.phar /usr/local/bin/composer
    rm composer-setup.php
else
    echo "Composer is installed."
fi

if [ -f ".env.example" ]; then
    echo "Copying .env.example to .env..."
    cp .env.example .env
else
    echo "No .env.example file found. Skipping .env file creation."
fi

echo "Running composer install..."
composer install
if [ $? -ne 0 ]; then
    echo "Composer install failed. Exiting."
    exit 1
fi

echo "Generating application key..."
php artisan key:generate
if [ $? -ne 0 ]; then
    echo "Failed to generate application key. Exiting."
    exit 1
fi

echo "Starting Docker containers..."
docker-compose up -d --build
if [ $? -ne 0 ]; then
    echo "Failed to start Docker containers. Exiting."
    exit 1
fi

echo "Waiting for containers to start..."

while ! docker-compose ps | grep -q 'Up'; do
    echo "Containers are not up yet. Waiting 1 second..."
    sleep 1
done

echo "Containers are up. Waiting 3 seconds..."
sleep 3

echo "Now, restarting the containers again..."
docker-compose up -d

echo "Containers have been restarted!"

echo ""
echo "✅ Application is now running!"
echo "🌐 Visit: http://127.0.0.1:8000"
echo "Powered by https://devit.uz"
