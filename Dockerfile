# Stage 1: Build the Go application
FROM golang:1.24.2-alpine AS builder

# Install necessary packages for Go to build the application
RUN apk add --no-cache git

# Set environment variables
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Create a working directory
WORKDIR /app

# Cache Go modules. Copy only the go.mod and go.sum files initially
COPY go.mod ./

# Download dependencies, this will be cached if go.mod and go.sum don't change
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the application (replace `main.go` with the entry point if different)
RUN go build -o app .

# Stage 2: Create a minimal image for running the Go application
FROM alpine:latest

# Set up necessary environment variable
ENV GIN_MODE=release

# Set a working directory in the final container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/app /app/app

# Run the Go application
CMD ["./app"]