# Builder stage
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build deps (gcc for any C extensions, curl for debugging if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Debug: show where uvicorn was installed (remove after confirming)
RUN echo "Checking /install/bin:" && ls -la /install/bin/ 2>/dev/null || echo "No /install/bin" && \
    echo "Checking /install/usr/local/bin:" && ls -la /install/usr/local/bin/ 2>/dev/null || echo "No /install/usr/local/bin"

# Final stage
FROM python:3.12-slim

WORKDIR /app

# Copy installed packages and binaries
COPY --from=builder /install /usr/local/

# Copy application code
COPY . .

# Create non-root user
RUN useradd -m -r appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Explicit full path to uvicorn (fixes any $PATH issues)
CMD ["/usr/local/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]