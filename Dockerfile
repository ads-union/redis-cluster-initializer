FROM redis:7.2.2-alpine
COPY --chmod=777 ./startup.sh /usr/local/bin/startup.sh
CMD [ "startup.sh" ]
