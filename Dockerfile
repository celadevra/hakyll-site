FROM dmp1ce/hakyll:latest
RUN mkdir /src
WORKDIR /src
ADD . /src
RUN cabal install --only-dependencies
RUN ghc --make ./site.hs