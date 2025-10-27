# 🧠 Pamflet — Setup Guide

Pamflet is a modular, containerized project that includes separate backend and frontend services.  
This guide explains how to set up the development environment using Docker and Make commands.

## Prerequisites

Before starting, make sure the following are installed and running on your system:

- [Docker](https://www.docker.com/)
- [Git](https://git-scm.com/)


## 🚀 Setup Instructions

### 1. Clone the Root Repository

Clone the root repository that contains the **Makefile**, **Docker Compose** configurations, and the environment file template.

```bash
git clone https://github.com/Ramzy842/Pamflet-root.git
cd Pamflet-root
```

# 2. Configure environment

Copy the example environment file and edit it with your configuration values.
```bash
cp .env.example .env
```
Then open the .env file and set your environment variables as needed.

# 3. Clone the Application Repositories

Clone the backend and frontend repositories inside the pamflet-root directory.

```bash
git clone https://github.com/Ramzy842/Pamflet-backend.git
git clone https://github.com/Ramzy842/Pamflet-frontend.git
```

Your folder structure should look like this:
```bash
pamflet-root/
├── Pamflet-backend/
├── Pamflet-frontend/
├── docker-compose.dev.yml
├── docker-compose.prod.yml
├── Makefile
├── .gitignore
├── README.md
└── .env
```

# 4. Build and Start the Application

Run the following command to initialize, build, start, migrate, and seed the entire project:

```bash
make setup
```

This command will:

- Build Docker images

- Start all containers

- Run database migrations

- Seed initial data

# 5. Access the application

Once the setup is complete, you can access the services at the following URLs:

| Service           | URL                                            |
| ----------------- | ---------------------------------------------- |
| **Frontend**      | [http://localhost:3000](http://localhost:3000) |
| **Backend API**   | [http://localhost:4040](http://localhost:4040) |
| **Prisma Studio** | [http://localhost:5555](http://localhost:5555) |


## 🧩 Common Make Commands

| Command       | Description                                                     |
| ------------- | --------------------------------------------------------------- |
| `make setup`  | Complete setup: initialize, build, start, migrate, and seed     |
| `make up`     | Start all Docker containers                                     |
| `make down`   | Stop all containers                                             |
| `make build`  | Build all containers                                            |
| `make logs`   | View real-time service logs                                     |
| `make reset`  | Reset everything (**⚠️ Deletes data**) and rebuild from scratch |
| `make studio` | Open Prisma Studio for database management                      |
