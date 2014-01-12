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
RUN apt-get -yq update

# SHIMS
## Hack for initctl
## See: https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl
#RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# ruby -> See http://brightbox.com/docs/ruby/ubuntu
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get install -y -q python-software-properties
RUN apt-get install  -y -q ruby1.9.3
RUN apt-get install -y -q  rubygems ruby-switch


# Install gollum
RUN apt-get install -y -q libicu-dev
RUN gem install gollum --no-rdoc --no-ri

RUN mkdir /srv/gollum

EXPOSE 4040
EXPOSE 4567

ENTRYPOINT ["/usr/local/bin/gollum"]
CMD  ["--port 4040", "--live-preview", "--allow-uploads"]


