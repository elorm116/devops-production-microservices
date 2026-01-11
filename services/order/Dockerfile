# Builder stage - use newer Go to match your local 1.24.5
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy only go.mod (go.sum optional)
COPY go.mod ./

# Download dependencies - now works with go 1.24.5 syntax
RUN go mod download

# Copy source and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" \
    -o /app/order-service ./main.go

# Final stage
FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=builder /app/order-service .
USER 65534:65534
EXPOSE 8080
CMD ["/app/order-service"]