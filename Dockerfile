FROM haskell:latest
RUN cabal update
RUN mkdir /src
WORKDIR /src
ADD . /src
RUN cabal install --only-dependencies
RUN ghc --make ./site.hs
RUN ./site build
RUN ./site watch