ARG PYTHON_VERSION=3.8

# --- Build stage ---
FROM python:${PYTHON_VERSION} AS base
WORKDIR /app

COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

# --- Run stage ---
FROM python:${PYTHON_VERSION}-slim

WORKDIR /app
ENV PYTHONUNBUFFERED=1

# 🧩 Встановлюємо потрібні пакети (наприклад для backports.zoneinfo)
RUN apt-get update && apt-get install -y gcc libffi-dev && rm -rf /var/lib/apt/lists/*

COPY --from=base /app .

# ❗️ Виконуємо міграції після того як Django вже встановлено
RUN python manage.py migrate

EXPOSE 8080
CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]