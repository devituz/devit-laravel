Write-Host "Checking if Docker, Docker Compose, PHP, and Composer are installed..."

$dockerInstalled = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerInstalled) {
    Write-Host "Docker is not installed. Installing Docker..."
    Invoke-WebRequest -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile "$env:USERPROFILE\Downloads\DockerInstaller.exe"
    Start-Process -FilePath "$env:USERPROFILE\Downloads\DockerInstaller.exe"
} else {
    Write-Host "Docker is installed."
}

$dockerComposeInstalled = Get-Command docker-compose -ErrorAction SilentlyContinue
if (-not $dockerComposeInstalled) {
    Write-Host "Docker Compose is not installed. Installing Docker Compose..."
    Invoke-WebRequest -Uri https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Windows-x86_64.exe -OutFile "C:\Program Files\Docker\docker-compose.exe"
} else {
    Write-Host "Docker Compose is installed."
}

$phpInstalled = Get-Command php -ErrorAction SilentlyContinue
if (-not $phpInstalled) {
    Write-Host "PHP is not installed. Installing PHP..."
    Invoke-WebRequest -Uri https://windows.php.net/downloads/releases/php-7.4.21-Win32-vc15-x64.zip -OutFile "$env:USERPROFILE\Downloads\php.zip"
    Expand-Archive "$env:USERPROFILE\Downloads\php.zip" -DestinationPath "$env:USERPROFILE\php"
    [Environment]::SetEnvironmentVariable('PATH', "$env:USERPROFILE\php;$env:PATH", 'User')
} else {
    Write-Host "PHP is installed."
}

$composerInstalled = Get-Command composer -ErrorAction SilentlyContinue
if (-not $composerInstalled) {
    Write-Host "Composer is not installed. Installing Composer..."
    Invoke-WebRequest -Uri https://getcomposer.org/installer -OutFile "$env:USERPROFILE\composer-setup.php"
    php "$env:USERPROFILE\composer-setup.php"
    Move-Item -Path "$env:USERPROFILE\composer.phar" -Destination "C:\Program Files\Composer\composer.phar"
} else {
    Write-Host "Composer is installed."
}

if (Test-Path ".env.example") {
    Write-Host "Copying .env.example to .env..."
    Copy-Item ".env.example" -Destination ".env"
} else {
    Write-Host "No .env.example file found. Skipping .env file creation."
}

Write-Host "Running composer install..."
composer install

Write-Host "Generating application key..."
php artisan key:generate

Write-Host "Starting Docker containers..."
docker-compose up -d --build

Write-Host "Waiting for containers to start..."
do {
    $containersStatus = docker-compose ps
    Start-Sleep -Seconds 1
} until ($containersStatus -match "Up")

Write-Host "Containers are up. Waiting 3 seconds..."
Start-Sleep -Seconds 3

Write-Host "Now, restarting the containers again..."
docker-compose up -d

Write-Host "Containers have been restarted!"

Write-Host ""
Write-Host "✅ Application is now running!"
Write-Host "🌐 Visit: http://127.0.0.1:8000"
Write-Host ""
Write-Host "🚀 Powered by https://devit.uz"
