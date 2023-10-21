FROM python:3 as stage1

ARG USER_ID
ARG GROUP_ID

WORKDIR /app

COPY . /app

RUN set -x \
    && pip install platformio

RUN PLATFORMIO_CORE_DIR=/app pio run

RUN chown -R $USER_ID:$GROUP_ID /app

RUN chmod -R 777 /app