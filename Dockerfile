FROM tarantegui/ubuntu:trusty

# >>> Work in Progress <<<

ENV MAILARCHIVA_URL https://www.mailarchiva.com/download?id=535
ENV MAILARCHIVA_INSTALL_DIR /opt
ENV MAILARCHIVA_HEAP_SIZE 1024m

ENV MAILARCHIVA_DATA_PATH /opt/mailarchiva-data

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      expect \
      wget \
    && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN wget -q -O - $MAILARCHIVA_URL | tar xzf - -C $MAILARCHIVA_INSTALL_DIR
RUN mv $MAILARCHIVA_INSTALL_DIR/mailarchiva* $MAILARCHIVA_INSTALL_DIR/mailarchiva

ADD expect-install $MAILARCHIVA_INSTALL_DIR/mailarchiva/expect-install
RUN cd $MAILARCHIVA_INSTALL_DIR/mailarchiva && expect expect-install

RUN mkdir /etc/service/mailarchiva
RUN exec /etc/init.d/mailarchiva start >>/var/log/mailarchiva.log 2>&1

EXPOSE 8090
