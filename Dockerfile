FROM mariadb:10.4.8

COPY entrypoint.sh /entrypoint.sh
COPY sql/ sql/
ENTRYPOINT [ "/entrypoint.sh" ]

