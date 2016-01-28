FROM dmp1ce/hakyll:latest
RUN mkdir /src
RUN mkdir /src/_site
WORKDIR /src
ADD . /src
RUN apt-get update
RUN apt-get install locales
RUN echo 'zh_CN.UTF-8 UTF-8' > /etc/locale.gen
RUN dpkg-reconfigure -f noninteractive locales
ENV LANG zh_CN.UTF-8
RUN cabal install --only-dependencies
RUN ghc --make ./site.hs