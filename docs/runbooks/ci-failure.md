# Runbook: CI Test Failures

## Quick Reference

| Error Pattern | Likely Cause | Resolution Time |
|---------------|--------------|-----------------|
| `ConnectionError` | Service down | 2 min |
| `401 Unauthorized` | Token expired | 1 min |
| `TimeoutError` | Service slow | 5 min |
| `Flaky test` | Test in quarantine | 10 min |
| `AssertionError` | Regression | 30 min |

## 🚨 Step 1: Identify Failure Type

```bash
# Look at the test output
cat reports/allure-results/*.json | jq '.status'
```

### Common Patterns

| Pattern | Meaning | Action |
|---------|---------|--------|
| `ConnectionError` to Kafka | Kafka not ready | Check `docker-compose ps` |
| `ConnectionError` to DB | PostgreSQL issue | Check DB health |
| `401 Unauthorized` | Token issues | Refresh `AMOCRM_LONG_TOKEN` |
| `404 Not Found` | Endpoint changed | Check API contract |
| `Timeout` | Service slow | Check service health |
| `StaleElementReference` | Page changed | Update locator |

## 🔧 Step 2: Reproduce Locally

### Quick Local Run

```bash
# Run only the failing test
pytest pipelines/api/tests/test_auth.py::TestAuth::test_account_info -v

# Run with full debug output
pytest pipelines/ -k "test_name" -vv --capture=no -o log_cli=true

# Run specific pipeline
pytest pipelines/api/ -v -n auto
```

### Full Environment

```bash
# Start infrastructure
docker-compose -f docker-compose.yml up -d

# Wait for services
sleep 30

# Verify services
docker-compose ps

# Run tests
pytest pipelines/ -v --alluredir=reports

# View report
allure serve reports
```

## 📊 Step 3: Analyze Failure

### Check Test History

```bash
# Find flaky tests (3+ failures in last 5 runs)
grep -r "FAILED" reports/allure-results/ | cut -d'/' -f4 | sort | uniq -c | sort -rn | head -10
```

### Check Logs

```bash
# Docker logs
docker-compose logs postgres --tail=100
docker-compose logs kafka --tail=100
docker-compose logs app --tail=100

# Application logs
cat reports/allure-results/*-result.json | jq '.steps[].name'
```

### Check Metrics

```python
# In prometheus format (exposed at /metrics)
test_duration_seconds{test="test_name"}
test_status{test="test_name",status="passed|failed"}
```

## 🛠️ Step 4: Fix

### If Flaky Test

```python
# Add explicit wait or retry
@pytest.mark.flaky(reruns=3, reruns_delay=2)
def test_sometimes_fails():
    # Test code
    pass
```

### If Regression

```python
# Create issue with label
# Fix the bug in source code
# Add test that catches the bug
# Update baseline if needed
```

### If Environment Issue

```bash
# Restart services
docker-compose restart

# Or rebuild
docker-compose down -v
docker-compose up -d --build
```

## 📢 Step 5: Notify

### Discord Notification (automatic on main branch failure)

```json
{
  "content": "⚠️ CI Pipeline Failed",
  "embeds": [{
    "title": "Test Failure",
    "description": "33 tests failed in api pipeline",
    "url": "https://github.com/ssrjkk/amoCRM/actions"
  }]
}
```

### Manual Escalation

1. **Post in #qa-automation** with:
   - Test name
   - Error message
   - Link to CI run

2. **Create Issue** if bug:
   - Label: `bug`, `priority:high`
   - Assign to relevant team

## ✅ Step 6: Verify Fix

```bash
# Run the test again
pytest pipelines/ -k "test_name" -v

# If fixed, commit with message
git commit -m "fix(test): resolve flaky test_test_name

- Added explicit wait for element
- Increased timeout to 30s
- Test now passes consistently"
```

## 📋 Emergency Contacts

| Role | Contact |
|------|---------|
| QA Lead | @ssrjk |
| Dev Lead | Check #team channel |
| On-call | Check PagerDuty |

## 🔄 Rollback Procedure

If CI breaks production:

```bash
# Revert last commit
git revert HEAD

# Push revert
git push origin main

# This will trigger another CI run
# If still failing, check the previous working commit
git log --oneline -10
```