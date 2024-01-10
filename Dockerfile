FROM ubuntu:rolling

ARG TEXLIVE_VERSION=2023
ARG PANDOC_VERSION=3.1.8

ENV PATH=/usr/local/texlive/bin/x86_64-linux:$PATH

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

COPY ./texlive.profile /tmp/
COPY ./debian-equivs.txt /tmp/

# set up packages
RUN apt-get update -qq &&\
    apt-get install --no-install-recommends -y \
    ca-certificates \
    equivs \
    wget \
    perl \
    gnupg \
    libfontconfig1 \
    unzip \
    fontconfig \
    && \
    \
    wget -O /tmp/install-tl-unx.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    wget -O /tmp/pandoc-3.1.8-1-amd64.deb https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-3.1.8-1-amd64.deb && \
    mkdir /tmp/install-tl && \
    tar -xzf /tmp/install-tl-unx.tar.gz -C /tmp/install-tl --strip-components=1 && \
    perl /tmp/install-tl/install-tl --profile /tmp/texlive.profile --no-interaction && \
    \
    # Install equivalent packages
    cd /tmp && \
    equivs-control texlive-local && \
    equivs-build debian-equivs.txt && \
    dpkg -i texlive-local*.deb && \
    dpkg -i pandoc-3.1.8-1-amd64.deb && \
    apt-get install -f && \
    # Install CTEX packages
    mkdir /tmp/ctex && \
    wget -O /tmp/ctex/ctex.tds.zip https://mirrors.ctan.org/install/language/chinese/ctex.tds.zip && \
    cd /tmp/ctex && unzip ctex.tds.zip && \
    cp -r ./tex/* /usr/local/texlive/texmf-dist/tex/ && \
    # Install xeCJK packages
    mkdir /tmp/xecjk && \
    wget -O /tmp/xecjk/xecjk.tds.zip https://mirrors.ctan.org/install/macros/xetex/latex/xecjk.tds.zip && \
    cd /tmp/xecjk && unzip xecjk.tds.zip && \
    cp -r ./tex/* /usr/local/texlive/texmf-dist/tex/ && \
    # Install zhnumber packages
    mkdir /tmp/zhnumber && \
    wget -O /tmp/zhnumber/zhnumber.tds.zip https://mirrors.ctan.org/install/macros/latex/contrib/zhnumber.tds.zip && \
    cd /tmp/zhnumber && unzip zhnumber.tds.zip && \
    cp -r ./tex/* /usr/local/texlive/texmf-dist/tex/ && \
    texhash && \
    \
    # Clean up
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* 

# TODO
# COPY fonts/ /usr/share/fonts/
# RUN fc-cache -fv && fc-list

# Expose /home as workin dir
WORKDIR /home
VOLUME ["/home"]
