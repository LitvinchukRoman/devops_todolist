ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} AS base

WORKDIR /app

COPY . .

FROM python:${PYTHON_VERSION}-slim

WORKDIR /app
ENV PYTHONUNBUFFERED=1

COPY --from=base /app .

RUN apt-get update && \
    apt-get install -y gcc libffi-dev && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8080

CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8080"]