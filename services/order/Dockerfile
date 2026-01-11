FROM golang:1.23-alpine AS builder

WORKDIR /app

# Only copy go.mod — go.sum is optional and not needed here
COPY go.mod ./

# This works perfectly even without go.sum
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o /app/order-service ./main.go

FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=builder /app/order-service .
USER 65534
EXPOSE 8080
CMD ["/app/order-service"]