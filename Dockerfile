FROM python:3.7.3

RUN apt-get update && \
    apt-get install -y git wget curl sudo lsb-release apt-transport-https ca-certificates


# Node install
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    DISTRO="$(lsb_release -s -c)" && \
    echo "deb https://deb.nodesource.com/node_10.x $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/node_10.x $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    node -v && \
    npm -v


# Chrome install
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatspi2.0-0 libgtk-3-0 libnspr4 libnss3 xdg-utils && \
    dpkg -i google-chrome-stable_current_amd64.deb; exit 0 && \
    apt-get install -f && \
    google-chrome --version


RUN git clone https://github.com/ASGdev/crocoite.git && \
    cd crocoite && \
    pip install .

ADD start.sh /

VOLUME /root/crocoite
VOLUME /tmp

RUN chmod +x /start.sh

RUN git clone https://github.com/ASGdev/crocoite-runner-stack.git && \
    cd crocoite-runner-stack && \
    npm i

EXPOSE 3009

ENTRYPOINT ["/start.sh"]
