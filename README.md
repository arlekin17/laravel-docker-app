
```text
.
├── laravel/                # Исходный код приложения
├── Deploy/
│   ├── dev/                # Конфигурации для разработки
│   └── prod/               # Multi-stage конфигурации для продакшена
├── docker-compose.dev.yml  # Сервисы для разработки
├── docker-compose.prod.yml # Сервисы для продакшена
├── .dockerignore
└── deploy.sh               # Скрипт автоматического деплоя
