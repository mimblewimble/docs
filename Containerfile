FROM alpine:3.13.3

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/bin

WORKDIR /app

COPY [ "requirements.txt", "./"]

RUN apk --update upgrade \
    && apk --no-cache --no-progress add python3-dev py-pip build-base \
    && rm -rf /var/cache/apk/* \
    && pip install --user -r requirements.txt

CMD [ "mkdocs", "serve" ]
