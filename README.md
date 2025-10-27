# Pamflet - Setup Guide

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
-   `make studio` - Open Prisma Studio