# Pamflet - Setup Guide

## Prerequisites

-   Docker installed and running
-   Git

## Quick Start

1. Clone the repository

```bash
git clone https://github.com/Ramzy842/Pamflet-backend
git clone https://github.com/Ramzy842/Pamflet-frontend
```

2. Copy environment file

```bash
cp .env.example .env
```

3. Update `.env` with your values

4. Start the application

```bash
make up
```

5. Access the application

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

## Troubleshooting

Initial Setup (First Time Ever)
If you're starting from scratch:
bash# 1. Initialize Prisma (do this ONCE, then commit)
cd PamfletAI/backend
npx prisma init

# 2. Edit prisma/schema.prisma (add your models)

# 3. Create initial migration (do this ONCE, then commit)

npx prisma migrate dev --name init

# 4. Commit to Git

git add prisma/
git commit -m "Initial Prisma schema and migration"

# 5. Now Docker build will work

make build
make up
For Team Members (Cloning Existing Repo)
bash# 1. Clone repo (gets schema.prisma and migrations)
git clone <repo>

# 2. Configure environment

cp .env.example .env

# Edit .env with your values

# 3. Build and start

Complete project setup (init + build + up + migrate + seed)

