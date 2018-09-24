#
# image name: nodepki-webclient:7.0
#

FROM node:7

RUN cd /opt && git clone https://github.com/aditosoftware/nodepki-webclient.git && cd /opt/nodepki-webclient && npm install

COPY start.sh /

RUN chmod +x /start.sh

VOLUME ["/opt/nodepki-webclient/data"]

CMD ["bash", "/start.sh"]

