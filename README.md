# amoCRM QA Automation Framework

Полностью рабочий фреймворк для тестирования demo-приложения.

## Быстрый старт (5 минут)

```bash
# 1. Клонировать
git clone https://github.com/ssrjkk/amoCRM
cd amoCRM

# 2. Установить зависимости
make install

# 3. Поднять инфраструктуру
make infra-up

# 4. Запустить тесты
make test-api

# 5. Открыть отчёт
make allure
```

## Структура проекта

```
amocrm-qa/
├── demo-app/           # Flask приложение для тестирования
│   ├── app.py         # REST API с /health, /api/users, /api/orders
│   └── Dockerfile     # Docker образ
├── src/               # Тестовые модули
│   ├── api/           # API тесты (7 тестов)
│   ├── db/            # Database тесты (7 тестов)
│   ├── ui/            # UI тесты (Selenium, 4 теста)
│   ├── kafka/         # Kafka тесты (3 теста)
│   ├── load/          # Locust нагрузка (2 сценария)
│   ├── k8s/           # K8s smoke тесты (3 теста)
│   └── logs/          # Log analysis тесты (3 теста)
├── core/               # Общие компоненты
│   ├── config.py      # pydantic-settings
│   ├── logger.py      # JSON логгер
│   └── fixtures.py     # pytest фикстуры
├── utils/              # Утилиты
│   ├── api_client.py  # HTTP клиент
│   └── db_client.py   # PostgreSQL клиент
├── docker-compose.yml # Инфраструктура
├── pyproject.toml     # Зависимости
├── Makefile          # Команды
└── README.md
```

## Demo App

Встроенное Flask-приложение с endpoints:

| Endpoint | Methods | Description |
|----------|---------|-------------|
| `/health` | GET | Health check |
| `/api/users` | GET, POST | CRUD пользователей |
| `/api/users/{id}` | GET, PUT, DELETE | Операции с пользователем |
| `/api/orders` | GET, POST | CRUD заказов |

## Тесты

### API Tests (`src/api/`)
- `test_create_user_success` - создание пользователя
- `test_create_user_validation_pydantic` - валидация через Pydantic
- `test_user_crud` - полный CRUD цикл
- `test_get_user_not_found` - 404 обработка

### DB Tests (`src/db/`)
- `test_user_created_via_api_exists_in_db` - проверка в БД
- `test_orders_have_valid_user_reference` - foreign key
- `test_no_duplicate_emails` - уникальность

### UI Tests (`src/ui/`)
- `test_health_page_loads` - загрузка страниц
- `test_no_horizontal_scroll` - responsive

### Kafka Tests (`src/kafka/`)
- `test_produce_message` - отправка в Kafka
- `test_consumer_receives_message` - получение

### Load Tests (`src/load/`)
- `UserScenario` - сценарий: register → view
- `ApiStressTest` - 100 RPS stress test

## Команды

```bash
make install        # Установить зависимости
make infra-up      # Поднять Docker
make infra-down     # Остановить Docker

make test-api      # API тесты
make test-db       # DB тесты
make test-ui       # UI тесты
make test-kafka    # Kafka тесты
make test-load     # Нагрузка
make test-all      # Все тесты

make allure        # Открыть Allure
make clean         # Очистить
```

## CI/CD

GitHub Actions автоматически запускают:
- При push в main
- При pull request
- По расписанию (ежедневно)

## Требования

- Python 3.10+
- Docker + Docker Compose
- PostgreSQL (в docker-compose)
- Kafka (в docker-compose)
- Selenium Grid (в docker-compose)

## Переменные окружения

Создайте `.env`:
```env
APP_URL=http://localhost:8080
DB_HOST=localhost
DB_PORT=5432
DB_NAME=amocrm
DB_USER=user
DB_PASSWORD=pass
KAFKA_BROKERS=localhost:9092
```

## Разработка

Добавить новый тест:
1. Создать файл `src/<module>/test_<name>.py`
2. Использовать фикстуры `api_client`, `db_client`
3. Добавить маркер `@pytest.mark.<module>`

```python
@pytest.mark.api
def test_example(api_client):
    response = api_client.get("/health")
    assert response.status_code == 200
```

## Лицензия

MIT