FROM alpine:latest
RUN apk add --no-cache curl jq bash
COPY ddns-desec.sh /ddns-desec.sh
RUN chmod +x /ddns-desec.sh
RUN mkdir /data 
CMD ["/bin/bash", "/ddns-desec.sh"]
