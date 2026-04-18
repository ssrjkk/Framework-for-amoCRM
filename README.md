# amoCRM QA Automation Framework

![Python](https://img.shields.io/badge/Python-3.12-blue)
![Pytest](https://img.shields.io/badge/Testing-Pytest-green)
![Playwright](https://img.shields.io/badge/UI-Playwright-purple)
![Docker](https://img.shields.io/badge/Infrastructure-Docker-blue)
![License](https://img.shields.io/badge/License-MIT-orange)

Comprehensive QA automation framework for amoCRM with API, UI, DB, Kafka, Load, and K8s testing.

## 🚀 Quick Start

```bash
# Clone and setup
git clone https://github.com/ssrjkk/amoCRM.git
cd amoCRM

# Start infrastructure
docker-compose -f docker-compose.yml up -d

# Run tests
pytest pipelines/ -v --alluredir=reports

# Open report
allure serve reports
```

## 📊 Test Coverage

| Type | Coverage | Tests |
|------|----------|-------|
| **API** | Auth, CRUD, Contracts | 33 tests |
| **UI** | Critical scenarios (Playwright) | 12 tests |
| **DB** | Consistency, Integrity | 12 tests |
| **Kafka** | Events, Async flow, DLQ | 8 tests |
| **Load** | Locust with thresholds | 10 tasks |
| **K8s** | Health checks | 12 tests |
| **Cross-browser** | Chrome, Firefox, Edge | 27 tests |
| **Logs** | Kibana error analysis | 10 tests |

## 🏗️ Architecture

```
amoCRM/
├── pipelines/                 # Test pipelines (POM)
│   ├── api/tests/            # API tests
│   │   ├── test_auth.py      # Authentication
│   │   ├── test_crud.py      # CRUD operations
│   │   └── test_contracts.py # Schema validation
│   ├── ui/                   # UI tests (Playwright)
│   │   ├── pages/            # Page Objects
│   │   └── tests/            # Test scenarios
│   ├── db/                   # Database tests
│   ├── kafka/                # Event tests
│   ├── load/                 # Locust tests
│   ├── k8s/                  # K8s smoke tests
│   ├── crossbrowser/         # Selenium Grid
│   └── logs/                 # Kibana analysis
├── config/                   # Configuration
├── core/                     # Core utilities
├── fixtures/                 # Data factories
├── .github/workflows/        # CI/CD (single pipeline)
└── docker/                   # Docker files
```

## 🧪 Running Tests

```bash
# All tests
pytest pipelines/ -v -n auto

# By marker
pytest pipelines/ -m api -v        # API tests
pytest pipelines/ -m ui -v         # UI tests
pytest pipelines/ -m smoke -v      # Fast smoke tests
pytest pipelines/ -m critical -v   # Critical paths

# Parallel execution
pytest pipelines/ -n auto          # Auto-detect CPU cores

# With Allure
pytest pipelines/ -m api --alluredir=reports
allure serve reports
```

## 📦 Infrastructure

All services with one command:

```bash
docker-compose -f docker-compose.yml up -d
```

Services:
- **App** (Flask) - http://localhost:8080
- **PostgreSQL** - localhost:5432
- **Kafka** - localhost:9092
- **Elasticsearch** - localhost:9200
- **Kibana** - localhost:5601
- **Selenium Grid** - localhost:4444

## 🔧 Tech Stack

- **Python 3.12** - Main language
- **Pytest** - Test framework with xdist
- **Playwright** - UI automation
- **Selenium Grid** - Cross-browser testing
- **Requests** - HTTP client
- **Kafka-python** - Event streaming
- **Locust** - Load testing
- **Kubernetes** - K8s smoke tests
- **Elasticsearch** - Log analysis
- **Allure** - Test reporting
- **GitHub Actions** - CI/CD

## ✨ Features

- **Page Object Model** - Reusable UI components
- **Data Factories** - Consistent test data generation
- **Parallel Execution** - `-n auto` for speed
- **Screenshots on Failure** - Auto-attached to Allure
- **Markers** - Run test subsets
- **Proper Scopes** - Session/function fixtures
- **Retry Logic** - Robust API client
- **Thresholds** - Load testing with baselines

## 🐛 Example: Bug Found by Tests

> **Issue**: Duplicate phone numbers allowed via API
> 
> **Test**: `test_contacts_phone_unique` in `pipelines/db/tests/test_integrity.py`
> 
> **Result**: DB constraint added, API validation implemented

## 📄 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Development workflow
- Code standards
- PR requirements

## 📝 License

MIT License