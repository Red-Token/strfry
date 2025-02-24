FROM ubuntu:noble AS build
ENV TZ=Europe/London
WORKDIR /build
RUN apt update && apt install -y --no-install-recommends git g++ make pkg-config libtool ca-certificates \
    libssl-dev zlib1g-dev liblmdb-dev libflatbuffers-dev \
    libsecp256k1-dev libzstd-dev

COPY . .
RUN git submodule update --init
RUN make setup-golpe
RUN make clean
RUN make -j4

FROM ubuntu:noble AS runner
WORKDIR /app

RUN apt update && apt install -y --no-install-recommends \
    liblmdb-dev libflatbuffers-dev libsecp256k1-dev libb2-1 libzstd-dev &&
    rm -rf /var/lib/apt/lists/*

COPY --from=build /build/strfry strfry

ENTRYPOINT ["/app/strfry"]
CMD ["relay"]
