# set the base image
FROM debian:stable-slim

# author
#MAINTAINER Tobias Scharlewsky

LABEL maintainer="dev@scharlewsky.de"
LABEL build_date="2025-01-10"

# update sources list
RUN apt-get clean
RUN apt-get update
RUN apt-get dist-upgrade -y

# install basic apps, one per line for better caching
RUN apt-get install -y cron
RUN apt-get install -y locales
 
# Set the locale
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG de_DE.UTF-8  
ENV LANGUAGE de_DE:de  
ENV LC_ALL de_DE.UTF-8  

# install container apps
RUN apt-get install -y offlineimap 

# cleanup
RUN apt-get -qy autoremove


#VOLUME root:./root/
LABEL name="offlineimap"

WORKDIR /root
RUN mkdir .offlineimap

COPY crontab /var/spool/cron/crontabs/root
#COPY imapfilter /root/.imapfilter 
RUN crontab /var/spool/cron/crontabs/root
RUN service cron start
CMD ["cron", "-f"]
