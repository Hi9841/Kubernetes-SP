FROM python:3.10-slim
# stable python version

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on
# environment vars for pyhton (performance)

WORKDIR /app
# work dir

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*
# system dependencies can be seprated (packed together to reduce image layers)

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn

COPY . .


EXPOSE 8000

CMD ["python", "statuspage/manage.py", "runserver", "0.0.0.0:8000"]