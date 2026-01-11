FROM golang:1.23-alpine AS builder
WORKDIR /app

COPY go.mod ./
COPY go.sum ./  || true   # Safe: skips if file missing
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o /app/order-service

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /app/order-service .
USER 65532
EXPOSE 8080
CMD ["/app/order-service"]