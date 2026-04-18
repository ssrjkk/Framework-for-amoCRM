.PHONY: help install infra-up infra-down test-api test-db test-ui test-kafka test-load test-all allure clean

help:
	@echo "=== amoCRM QA Framework ==="
	@echo ""
	@echo "make install       - Установить зависимости"
	@echo "make infra-up      - Поднять инфраструктуру (все сервисы)"
	@echo "make infra-down    - Остановить инфраструктуру"
	@echo "make test-api      - Запустить API тесты"
	@echo "make test-db       - Запустить DB тесты"
	@echo "make test-ui       - Запустить UI тесты"
	@echo "make test-kafka    - Запустить Kafka тесты"
	@echo "make test-load     - Запустить нагрузочные тесты"
	@echo "make test-all      - Запустить все тесты"
	@echo "make allure        - Открыть Allure отчёт"
	@echo "make clean         - Очистить артефакты"

install:
	pip install -e ".[all]"

infra-up:
	docker-compose up -d --build
	@echo "Waiting for services..."
	@sleep 15
	@echo "Services ready!"

infra-down:
	docker-compose down -v

test-api:
	pytest src/api/ -v --alluredir=reports/allure-results -m api

test-db:
	pytest src/db/ -v --alluredir=reports/allure-results -m db

test-ui:
	pytest src/ui/ -v --alluredir=reports/allure-results -m ui

test-kafka:
	pytest src/kafka/ -v --alluredir=reports/allure-results -m kafka

test-load:
	locust -f src/load/locustfile.py --headless --users 50 --spawn-rate 10 --run-time 60s --host http://localhost:8080

test-k8s:
	pytest src/k8s/ -v --alluredir=reports/allure-results -m k8s

test-logs:
	pytest src/logs/ -v --alluredir=reports/allure-results -m logs

test-all:
	pytest src/ -v --alluredir=reports/allure-results

test-smoke:
	pytest src/ -v -m smoke

allure:
	allure serve reports/allure-results

clean:
	rm -rf reports/
	rm -rf logs/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete