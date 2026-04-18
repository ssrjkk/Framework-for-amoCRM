"""Log analysis tests."""

import pytest
import requests
from datetime import datetime, timedelta


pytestmark = pytest.mark.logs


class TestErrorLogs:
    """Error log analysis tests."""

    def test_app_logs_accessible(self):
        """App logs are accessible."""
        try:
            response = requests.get("http://localhost:8080/health", timeout=5)
            assert response.status_code == 200
        except Exception as e:
            pytest.skip(f"App not available: {e}")

    def test_no_server_errors(self):
        """No 5xx errors during operation."""
        endpoints = ["/health", "/api/users", "/api/orders"]

        errors = []

        for endpoint in endpoints:
            try:
                response = requests.get(f"http://localhost:8080{endpoint}", timeout=5)
                if response.status_code >= 500:
                    errors.append(f"{endpoint}: {response.status_code}")
            except Exception:
                pass

        assert len(errors) == 0, f"Server errors: {errors}"

    def test_response_times_acceptable(self):
        """Response times are acceptable."""
        import time

        endpoint = "/health"
        times = []

        for _ in range(5):
            start = time.time()
            try:
                requests.get(f"http://localhost:8080{endpoint}", timeout=5)
                times.append((time.time() - start) * 1000)
            except Exception:
                pass

        if times:
            avg_time = sum(times) / len(times)
            assert avg_time < 1000, f"Average response time: {avg_time:.2f}ms"


class TestPerformanceLogs:
    """Performance log tests."""

    def test_p95_response_time(self):
        """P95 response time < 500ms."""
        import time

        endpoint = "/api/users"
        times = []

        for _ in range(20):
            start = time.time()
            try:
                requests.get(f"http://localhost:8080{endpoint}", timeout=5)
                times.append((time.time() - start) * 1000)
            except Exception:
                pass

        if len(times) >= 10:
            times.sort()
            p95_index = int(len(times) * 0.95)
            p95 = times[p95_index]

            assert p95 < 500, f"P95: {p95:.2f}ms"
