FROM ubuntu:16.04
MAINTAINER PeerPlays Blockchain Standards Association

RUN \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y python3 python3-dev python3-pip libmysqlclient-dev libssl-dev git && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create app directory
RUN mkdir /app
ADD requirements.txt /app

# Install app requirements
RUN pip3 install -r /app/requirements.txt
RUN pip3 install peerplays --upgrade
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN peerplays set node ws://ec2-35-182-42-231.ca-central-1.compute.amazonaws.com:8090
RUN peerplays createwallet --password supersecret
RUN echo supersecret | peerplays addkey 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
RUN peerplays set default_account nathan

# Install app
ADD . /app

# Make settings persistent
VOLUME ["/app"]

# rpc service:
EXPOSE 5050

# default execute entry
WORKDIR /app
CMD echo supersecret | python3 -u /app/qaapi.py
