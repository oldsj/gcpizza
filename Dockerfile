FROM rust:slim as builder
WORKDIR /app
RUN rustup default nightly
RUN rustup target add x86_64-unknown-linux-musl --toolchain=nightly

RUN USER=root cargo new gcpizza
WORKDIR /app/gcpizza
COPY Cargo.toml Cargo.lock ./
RUN cargo build --target x86_64-unknown-linux-musl --release

COPY src ./src
RUN cargo install --target x86_64-unknown-linux-musl --path .

FROM scratch as runtime
COPY --from=builder /usr/local/cargo/bin/gcpizza .
COPY Rocket.toml .
USER 1000
EXPOSE 8080
CMD ["./gcpizza"]
