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
    echo "Composer is not installed."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "Installing Composer using Homebrew..."
    brew install composer
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

echo "Generating application key..."
php artisan key:generate

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
echo ""
echo "🚀 Powered by https://devit.uz"
