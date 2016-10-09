FROM ubuntu:14.04

RUN apt-get update

RUN apt-get install -y \
    autoconf automake autopoint bash bison bzip2

RUN apt-get install -y \
    scons flex gettext make sed unzip wget p7zip-full cmake

RUN apt-get install -y \
    libtool patch perl git xz-utils

RUN apt-get install -y g++

RUN apt-get install -y \
    gperf intltool libffi-dev libgdk-pixbuf2.0-dev \
    libltdl-dev libssl-dev libxml-parser-perl \
    openssl pkg-config python ruby gawk xsltproc \
    libxml2-utils lib32gcc1

RUN apt-get clean

ADD ./ /mxe/
RUN cd /mxe/ && make download-gcc
RUN cd /mxe/ && make download-sqlite download-gtkmm3 download-lua download-sodium download-curl download-adwaita-icon-theme download-boost
RUN cd /mxe/ && make binutils
RUN cd /mxe/ && make gcc
RUN cd /mxe/ && make sqlite gtkmm3 lua sodium curl adwaita-icon-theme boost

