FROM dmp1ce/hakyll:latest
RUN mkdir /src
WORKDIR /src
ADD . /src
ENV LANG zh_CN.UTF-8
RUN cabal install --only-dependencies
RUN ghc --make ./site.hs