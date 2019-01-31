FROM rustlang/rust:nightly

RUN apt-get update
RUN apt-get -y install upx
WORKDIR /tsuki
COPY Cargo.toml .
RUN mkdir src \
    && echo "// dummy file" > src/lib.rs \
    && cargo build
COPY . .
RUN cargo build
RUN ls -lah target/debug/
RUN upx --ultra-brute target/*/tsuki
RUN ls -lah target/debug/
CMD ["./target/debug/tsuki"]
