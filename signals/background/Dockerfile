FROM iojs:onbuild

COPY ./program.js ./program.js
COPY ./program.sh ./program.sh
COPY ./package.json ./package.json

RUN	chmod +x ./program.sh

EXPOSE 3000

ENTRYPOINT ["./program.sh"]
