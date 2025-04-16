# 🚀 Devit-laravel - Powerful Laravel Deployment Platform

Welcome to **Devit-laravel** — the ultimate platform for rapid Laravel application deployment.  
With **Devit-laravel**, you can deploy your Laravel apps in seconds, not hours.

Automatic Setup with Docker
This project includes an automatic setup for Laravel with Redis, PostgreSQL, Nginx, and other services. Follow these steps to quickly get your application up and running with Docker.

## 🌟 Features

- ⚡ **Blazing Fast Deployment**  
  Deploy your Laravel application quickly with minimal setup — no manual configuration required.  
  **Devit-laravel** eliminates the long setup time and streamlines your deployment process, allowing you to push your app to the server in record time. Whether it's a small update or a fresh deployment, the entire process takes just minutes!

- 🔧 **Customizable Setup**  
  Devit-laravel includes a prebuilt `devit-linux.sh, .\devit-windows.ps1, devit-macos.sh ` script that automates environment setup for you.

- 📦 **Modern Docker Support**  
  Works seamlessly with custom Docker environments — no need for Sail.

- 🛡️ **Secure by Default**  
  Devit-laravel follows the best security practices to ensure your environment and app are safe.

- 🎨 **Beautiful Landing Page**  
  A clean, animated UI greets you after deployment, giving your users a great first impression.

---

## 🚀 Getting Started

### 1. Clone the Project
Clone the repository to your local machine and navigate into the project folder:

```bash
git clone git@github.com:devituz/devit-laravel.git
cd devit-laravel
```

### 2. Set Permissions
Give execute permissions to the devit-linux.sh, .devit-windows.ps1, devit-macos.sh script so it can be run. This step ensures the script is executable:

Linux
```bash
chmod +x devit-linux.sh
```
Macos
```bash
chmod +x devit-macos.sh
```
Windows
```bash
Set-ExecutionPolicy RemoteSigned
```

### 3. Run the Setup Script
Execute the setup script to start the deployment process. Devituz ensures that deploying your Laravel application is quick and easy. By running the following command, you will deploy your app to the server instantly:

Linux
```bash
sudo ./devit-linux.sh 
```
Macos
```bash
./devit-macos.sh 
```
Windows
```bash
.\devit-windows.ps1
```
### 4. Access Your Application
Once deployment is complete, you can access your application by navigating to the server's IP address or domain in a web browser:

```bash
http://127.0.0.1:8000/
```
Enjoy the convenience of instant deployment, and start building on top of your app!



## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Devit via [shohbozbek.uz24@gmail.com](mailto:shohbozbek.uz24@gmail.com). All security vulnerabilities will be promptly addressed.

## License

The Devit-laravel framework is open-sourced software licensed under the [MIT license](https://devit.uz/licenses/devit-laravel).
