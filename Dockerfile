FROM python:3.7-alpine

WORKDIR /app

RUN apk update && apk upgrade
RUN apk add --no-cache make g++ bash git openssh postgresql-dev curl
RUN apk add --no-cache jpeg-dev zlib-dev
RUN apk add --no-cache gcc libc-dev fortify-headers linux-headers libxslt-dev

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ADD ./requirements.txt /app

RUN pip install --no-cache -r requirements.txt

COPY ./ /app

EXPOSE 80

# ENTRYPOINT [ "python3", "app.py" ]
ENTRYPOINT [ "gunicorn", "-w 4",  "-b", "0.0.0.0:80", "wsgi:app" ]
