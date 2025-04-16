#!/bin/bash

echo "Checking if Docker, Docker Compose, PHP, and Composer are installed..."

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    brew install --cask docker
else
    echo "Docker is installed."
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    brew install docker-compose
else
    echo "Docker Compose is installed."
fi

if ! command -v php &> /dev/null; then
    echo "PHP is not installed. Installing PHP..."
    brew install php
else
    echo "PHP is installed."
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
    mv composer.phar /usr/local/bin/composer
    rm composer-setup.php
else
    echo "Composer is installed."
fi

echo "Running composer install..."
composer install


echo "Starting Docker containers..."

docker-compose up -d --build

echo "Waiting for containers to start..."

while ! docker-compose ps | grep -q 'Up'; do
    echo "Containers are not up yet. Waiting 1 second..."
    sleep 1
done

echo "Containers are up. Waiting 3 seconds..."
sleep 3

echo "Now, starting the containers again..."
docker-compose up -d

echo "Containers have been restarted!"



echo ""
echo "✅ Application is now running!"
echo "🌐 Visit: http://127.0.0.1:8000"

echo "Powered by https://devit.uz"
