# Use base golang image from Docker Hub
FROM golang:1.17-alpine AS build
WORKDIR /app


RUN apk --no-cache add ca-certificates

# Install dependencies in go.mod and go.sum
COPY go.mod go.sum ./
RUN go mod download

# Copy rest of the application source code
COPY . ./

ENV CGO_ENABLED=0
RUN go build -mod=readonly -v -o ./app

# Now create separate deployment image
FROM gcr.io/distroless/base

WORKDIR /
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /app/app /app
USER nonroot:nonroot

CMD ["/app"]
