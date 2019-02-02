FROM rustlang/rust:nightly as builder

RUN apt-get update
RUN apt-get -y install upx
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /tsuki
COPY . .
RUN ls
RUN cargo build --release --target x86_64-unknown-linux-musl
RUN upx --ultra-brute target/x86_64-unknown-linux-musl/release/tsuki

FROM busybox:musl

COPY --from=builder /tsuki/target/x86_64-unknown-linux-musl/release/tsuki /bin/tsuki
RUN ls
CMD ["tsuki"]