# Stage 1: Build & Dependencies stage
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache gcc musl-dev libffi-dev

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Minimal Runtime stage
FROM python:3.11-alpine

WORKDIR /app

# Create a non-root group and user (Principle of Least Privilege)
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser

# Copy installed python dependencies from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY app.py .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER 1001

# Expose internal application port
EXPOSE 5000

# Health check to test container status
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:5000/health || exit 1

# Execute application
CMD ["python", "app.py"]
