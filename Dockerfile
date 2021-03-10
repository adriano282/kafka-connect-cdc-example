FROM microsoft/mssql-server-linux:2017-latest

RUN mkdir -p /usr/config
WORKDIR /usr/config

COPY msserver-setup-files/ /usr/config

RUN chmod +x /usr/config/entrypoint.sh

RUN chmod +x /usr/config/configure-db.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["tail -f /dev/null"]

HEALTHCHECK --interval=15s CMD /opt/mssql -U sa -P $MSSQL_SA_PASSWORD -Q "select 1" && grep -q "MSSQL CONFIG COMPLETE" ./config.log
