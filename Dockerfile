FROM rust:slim as builder
WORKDIR /app
RUN rustup default nightly
RUN rustup target add x86_64-unknown-linux-musl --toolchain=nightly

WORKDIR /app/gcpizza
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --target x86_64-unknown-linux-musl --release


FROM scratch as runtime
COPY --from=builder /app/gcpizza/target/x86_64-unknown-linux-musl/release/gcpizza .
COPY Rocket.toml .
USER 1000
EXPOSE 8080
CMD ["./gcpizza"]
