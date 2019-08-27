FROM python:3 AS runner
MAINTAINER marmotcai "marmotcai@163.com"

ARG APP_GITURL="NULL"

ENV WORK_DIR=/root
WORKDIR ${WORK_DIR}

ENV APP_DIR=${WORK_DIR}/app
RUN mkdir -p ${APP_DIR}

RUN if [ "${APP_GITURL}" != "NULL" ] ; then echo ${APP_GITURL} ;  git clone ${APP_GITURL} ${APP_DIR} ; fi

COPY requirements.txt ${APP_DIR}/requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r ${APP_DIR}/requirements.txt

########################################################

FROM runner AS ssh

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

EXPOSE 22
EXPOSE 80

CMD ["/usr/sbin/sshd", "-D"]

# ENV APP_PATH ${WORK_DIR}/app
# ENV PATH $PATH:$APP_PATH

# COPY . .
# CMD [ "python3", "./training.py", "-h" ]

