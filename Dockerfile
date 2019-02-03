FROM rustlang/rust:nightly as builder

RUN apt-get update
RUN apt-get -y install upx musl-tools
RUN rustup target add x86_64-unknown-linux-musl
WORKDIR /tsuki
COPY . .
RUN cargo build --release --target x86_64-unknown-linux-musl

RUN ls -lah target/x86_64-unknown-linux-musl/release/tsuki
RUN strip target/x86_64-unknown-linux-musl/release/tsuki
RUN upx --ultra-brute target/x86_64-unknown-linux-musl/release/tsuki
RUN ls -lah target/x86_64-unknown-linux-musl/release/tsuki

FROM busybox:musl

COPY --from=builder /tsuki/target/x86_64-unknown-linux-musl/release/tsuki /bin/tsuki  
CMD ["tsuki"]
