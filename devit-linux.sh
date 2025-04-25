#!/bin/bash

echo "Checking if Docker, Docker Compose, PHP, and Composer are installed..."

echo "Setting permissions to 777 for project directory files..."
sudo chmod -R 777 /home/devit/Work/laravel/devit-laravel


if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."

    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce=5:26.1.5~3-0~ubuntu-focal docker-ce-cli=5:26.1.5~3-0~ubuntu-focal containerd.io

    if [ $? -ne 0 ]; then
        echo "Failed to install Docker. Exiting."
        exit 1
    fi
else
    echo "Docker is installed."
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."

    curl -SL https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    if [ $? -ne 0 ]; then
        echo "Failed to install Docker Compose. Exiting."
        exit 1
    fi
else
    echo "Docker Compose is installed."
fi

if ! command -v php &> /dev/null; then
    echo "PHP is not installed. Installing PHP 8.3.20..."

    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get update
    sudo apt-get install -y php8.3 php8.3-cli php8.3-common php8.3-mbstring php8.3-xml php8.3-zip php8.3-curl

    if [ $? -ne 0 ]; then
        echo "Failed to install PHP. Exiting."
        exit 1
    fi
else
    echo "PHP is installed."
fi

if ! command -v composer &> /dev/null; then
    echo "Composer is not installed. Installing Composer 2.8.8..."

    EXPECTED_SIGNATURE=$(wget -qO - https://composer.github.io/installer.sig)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');")
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        exit 1
    fi
    php composer-setup.php --version=2.8.8
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
sudo chmod -R 775 storage
sudo chown -R www-data:www-data storage
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

PORT=$(grep -oP '^APP_PORT=\K.*' .env)


echo ""
echo "✅ Application is now running!"
echo "🌐 Visit: http://127.0.0.1:$PORT"
echo "Powered by https://devit.uz"


