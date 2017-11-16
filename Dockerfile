FROM zoobab/lede-17.01.0-rc2-r3131-42f3c1f-x86-64
RUN opkg update
RUN opkg install olsrd
RUN mkdir /etc/olsrd
COPY olsrd.conf /etc/olsrd/olsrd.conf
ENTRYPOINT ["olsrd","-nofork"]
