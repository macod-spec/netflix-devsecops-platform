FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade setuptools wheel

COPY . .

RUN addgroup --gid 10001 appgroup && \
    adduser --uid 10001 --ingroup appgroup --disabled-password --gecos "" appuser && \
    chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]