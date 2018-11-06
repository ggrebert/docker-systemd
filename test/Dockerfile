FROM alpine:latest

ADD test /app
ADD keys/ansible.pem /root/.ssh/id_rsa

RUN apk add --update openssh-client && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod +x /app/test.sh

CMD /app/test.sh

