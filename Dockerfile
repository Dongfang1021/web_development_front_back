# Basic image
FROM ubuntu-ssh
# image author
MAINTAINER Dongfang dfhu2019@gmail.com
# install pip3
RUN apt-get install python3-pip -y
# add files
ADD Django-2.1.2.tar.gz /data/softs/
WORKDIR /data/softs/Django-2.1.2
RUN python3 setup.py install

# create project
WORKDIR /data/server
RUN django-admin startproject itcast
# create app
WORKDIR /data/server/itcast
RUN python3 manage.py startapp test1
RUN sed -i "/staticfiles/a\    'test1'," itcast/settings.py
# config
COPY views.py /data/server/itcast/test1/
RUN sed -i '/t p/a\from test1.views import *' itcast/urls.py
RUN sed -i "/\]/i\    path('hello/', hello)," itcast/urls.py
# start project 
RUN sed -i "s#S = \[\]#S = \['*'\]#" itcast/settings.py
# port
EXPOSE 8000
# run project
ENTRYPOINT ["python3","manage.py","runserver","0.0.0.0:8000"]
