# Builder stage
FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Debug: list installed binaries (remove after testing)
RUN ls -la /install/usr/local/bin/

# Final stage
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /install /usr/local/lib/python3.12/site-packages/
COPY --from=builder /install /usr/local/bin/

COPY . .

RUN useradd -m -r appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Explicit full path to uvicorn (fixes "not found in $PATH")
CMD ["/usr/local/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
