FROM stackbrew/ubuntu:raring
MAINTAINER github.com/jottr 

## Speed and Space
# see https://gist.github.com/jpetazzo/6127116
# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

# REPOS
RUN apt-get -y update && date
RUN apt-get install -y -q software-properties-common
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get -y update

# SHIMS
## Hack for initctl
## See: https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl
#RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

## MYSQL
RUN apt-get install -y -q mysql-server mysql-client 
### Additions to MYSQL
RUN apt-get install -y -q php5-mysql

#RUN /bin/rm -rf /var/lib/mysql/*

ADD initialize_and_start_mysql /usr/sbin/initialize_and_start_mysql
ADD listen_on_all_addresses.cnf /etc/mysql/conf.d/listen_on_all_addresses.cnf

EXPOSE 3306
CMD [ "/usr/sbin/initialize_and_start_mysql" ]
