FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip

RUN adduser --disabled-password py-demo

USER py-demo
WORKDIR /home/py-demo

COPY --chown=py-demo:py-demo requirements.txt requirements.txt

ENV PATH=/home/py-demo/.local/bin:$PATH
RUN pip install --user -r requirements.txt

COPY --chown=py-demo:py-demo *py ./


CMD [ "python", "main.py" ]
