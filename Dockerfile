FROM rust:1.75-alpine3.19 as builder

WORKDIR /app
COPY ./ /app

RUN apk add --no-cache musl-dev git cmake make g++
RUN cargo build --release --bin stat_server
RUN strip /app/target/release/stat_server

FROM debian:bookworm-slim as production
LABEL maintainer="doge.py@gmail.com" \
    description="A simple server monitoring tool"

COPY --from=builder /app/config.toml /app/config.toml
COPY --from=builder /app/target/release/stat_server /app/stat_server
COPY --from=builder /app/start.sh /app/start.sh
RUN apt update && \
    apt install -y curl && \
    chmod +x /app/start.sh

WORKDIR /app
EXPOSE 8080 9394

ENTRYPOINT [ "/app/start.sh" ]
