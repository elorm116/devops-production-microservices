FROM python:3.12-slim AS builder

WORKDIR /app

# Install build dependencies only if needed (gcc for C extensions)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Final stage: Runtime image (slim + non-root)
FROM python:3.12-slim

WORKDIR /app

# Copy only the installed packages from builder
COPY --from=builder /install /usr/local/lib/python3.12/site-packages/
COPY --from=builder /install /usr/local/bin/

# Copy application code
COPY . .

# Create non-root user and set ownership
RUN useradd -m -r appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Run uvicorn with multiple workers (adjust based on resources)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]