<!-- # Pamflet - Setup Guide

## Prerequisites

-   Docker installed and running
-   Git


# 1. Now Docker build will work

1. Clone root repo that contains Makefile + docker-compose files and .env.example
git clone https://github.com/Ramzy842/Pamflet-root.git

# 2. Configure environment

cp .env.example .env

# Edit .env with your values

# 3. Clone Backend and Frontend

Clone the following essential repositories inside the pamflet-root folder:
git clone https://github.com/Ramzy842/Pamflet-backend.git
git clone https://github.com/Ramzy842/Pamflet-frontend.git

# 4. Build and start

Run the command `make setup`: Complete project setup (init + build + up + migrate + seed)


# 5. Access the application

-   Frontend: http://localhost:3000
-   Backend API: http://localhost:4040
-   Prisma Studio: http://localhost:5555

## Common Commands

-   `make setup` - Complete project setup (init + build + up + migrate + seed)
-   `make up` - Start all services
-   `make down` - Stop all services
-   `make build` - Rebuild containers
-   `make logs` - View logs
-   `make reset` - Reset everything (WARNING: deletes data) and setups everything from scratch
-   `make studio` - Open Prisma Studio -->

🧠 Pamflet — Setup Guide
📋 Prerequisites

Before setting up the project, ensure that you have the following installed and running:

Docker

Git

🚀 Setup Instructions
1. Clone the Root Repository

This repository contains the Makefile, Docker Compose configuration, and environment file templates.

git clone https://github.com/Ramzy842/Pamflet-root.git
cd Pamflet-root

2. Configure Environment Variables

Copy the example environment file and update it with your own values:

cp .env.example .env


Then open .env and configure it according to your local setup.

3. Clone the Application Repositories

Inside the pamflet-root directory, clone both the backend and frontend repositories:

git clone https://github.com/Ramzy842/Pamflet-backend.git
git clone https://github.com/Ramzy842/Pamflet-frontend.git

4. Build and Start the Application

Run the following command to initialize, build, start, migrate, and seed the entire project:

make setup


This command automates the full setup process.

5. Access the Application

Once the setup is complete, you can access the following services:

Frontend: http://localhost:3000

Backend API: http://localhost:4040

Prisma Studio: http://localhost:5555

🧩 Common Make Commands
Command	Description
make setup	Complete project setup (init + build + up + migrate + seed)
make up	Start all services
make down	Stop all services
make build	Rebuild all containers
make logs	View service logs
make reset	Reset everything (⚠️ deletes data) and set up from scratch
make studio	Open Prisma Studio
🧠 Notes

The first build may take a few minutes as Docker pulls and builds all dependencies.

Use make down when stopping the project to ensure all containers shut down cleanly.