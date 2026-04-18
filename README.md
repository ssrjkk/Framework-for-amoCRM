# amoCRM QA Automation

**Полная тестовая инфраструктура для amoCRM API v4**

---

## Пайплайны

| Пайплайн | Стек | Файлы |
|----------|------|-------|
| **API** | pytest + requests + AmoCRMClient | `pipelines/api/` |
| **UI** | Playwright + POM | `pipelines/ui/` |
| **DB** | psycopg2 + PostgreSQL | `pipelines/db/` |
| **Kafka** | kafka-python | `pipelines/kafka/` |
| **Load** | Locust | `pipelines/load/` |
| **K8s** | kubernetes | `pipelines/k8s/` |
| **Cross-browser** | Selenium Grid | `pipelines/crossbrowser/` |
| **Logs** | Elasticsearch | `pipelines/logs/` |

## Быстрый старт

```bash
# Установка зависимостей
pip install -r requirements.txt

# Настройка переменных окружения
export AMOCRM_LONG_TOKEN="ваш_долгосрочный_токен"
export AMOCRM_SUBDOMAIN="ваш_аккаунт"

# Запуск тестов
pytest pipelines/api/ -m api -v -n auto
```

## Настройка в GitHub Secrets

- `AMOCRM_LONG_TOKEN` — долгосрочный токен amoCRM
- `AMOCRM_SUBDOMAIN` — домен аккаунта
- `DATABASE_URL` — PostgreSQL
- `KAFKA_BROKERS` — Kafka
- `KIBANA_URL` — Kibana
- `SELENIUM_GRID` — Selenium Grid URL

## GitHub Actions

Все 8 workflows в `.github/workflows/`:
- `api.yml` — API тесты
- `ui.yml` — UI тесты (Playwright)
- `db.yml` — DB тесты
- `kafka.yml` — Kafka тесты
- `load.yml` — Нагрузочные тесты
- `k8s_smoke.yml` — K8s smoke тесты
- `crossbrowser.yml` — Cross-browser тесты
- `logs.yml` — Log analysis
- `all.yml` — Все тесты

## Структура

```
pipelines/
├── api/           # API тесты + AmoCRMClient
├── ui/            # Playwright + Page Objects
├── db/            # PostgreSQL тесты
├── kafka/         # Kafka тесты
├── load/          # Locust нагрузка
├── k8s/          # K8s smoke
├── crossbrowser/    # Selenium Grid
└── logs/          # Kibana анализ
```

## Токен

Получить долгосрочный токен: https://www.amocrm.ru/developers/content/oauth/long-term