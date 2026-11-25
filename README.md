
## Project Structure

```text
.
├── laravel/                  # Laravel application source code
├── Deploy/
│   ├── dev/                  # Development service Dockerfiles and configs
│   └── prod/                 # Autonomous production service Dockerfiles and configs
│       ├── php/
│       ├── nginx/
│       ├── postgres/
│       └── pgadmin/
├── docker-compose.dev.yml    # Development environment compose file
├── docker-compose.prod.yml   # Production environment compose file
├── check-multistage.sh       # Multi-stage build and artifact verification script
├── deploy.sh                 # Production build, Trivy scan, and service startup script
├── .dockerignore             # Docker build context exclusions
└── .gitignore                # Git exclusions
