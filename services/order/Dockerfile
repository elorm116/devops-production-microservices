# Builder stage - use Go 1.23 (compatible with your go 1.24.5 file)
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy go.mod (go.sum is optional)
COPY go.mod ./

# Download dependencies - this will now succeed
RUN go mod download

# Copy source code and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" \
    -o /app/order-service ./main.go

# Final minimal image
FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=builder /app/order-service .
USER 65534:65534
EXPOSE 8080
CMD ["/app/order-service"]