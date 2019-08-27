FROM python:3 AS base
MAINTAINER marmotcai "marmotcai@163.com"

#######################################################

RUN sed -i '$a\alias ll=\"ls -alF\"' ~/.bashrc
RUN sed -i '$a\alias la=\"ls -A\"' ~/.bashrc
RUN sed -i '$a\alias l=\"ls -CF\"' ~/.bashrc

RUN apt-get update && \
    apt-get install -y wget vim openssh-server && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:112233" | chpasswd && \
    mkdir /var/run/sshd

#######################################################

ENV WORK_DIR=/root
WORKDIR ${WORK_DIR}

COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

#######################################################

EXPOSE 22
EXPOSE 80

CMD ["/usr/sbin/sshd", "-D"]

#######################################################

FROM base AS runner

ARG APP_GITURL="NULL"

ENV APP_DIR=${WORK_DIR}/app
RUN mkdir -p ${APP_DIR}

RUN if [ "${APP_GITURL}" != "NULL" ] ; then echo ${APP_GITURL} ;  git clone ${APP_GITURL} ${APP_DIR} ; fi

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r ${APP_DIR}/requirements.txt

########################################################



