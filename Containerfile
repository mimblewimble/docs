FROM alpine:3.13.3

RUN apk --update upgrade \
    && apk --no-cache --no-progress add python3-dev py-pip build-base \
    && rm -rf /var/cache/apk/*

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin

WORKDIR /app

COPY [ "requirements.txt", "./"]

RUN pip install --user -r requirements.txt

CMD [ "mkdocs", "serve" ]
