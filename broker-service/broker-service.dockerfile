# When this is run, it should build the code
# on one docker image then create a much smaller
# docker image and copy over the executable.

# Base go image.
FROM golang:1.19-alpine as builder

RUN mkdir /app

COPY . /app

# Set working directory.
WORKDIR /app

# Not using any C libraries so specify the 
# appropriate env variable for that.
# Then build the go code.
RUN CGO_ENABLED=0 go build -o brokerApp ./cmd/api

# Ensure the app is executed.
RUN chmod +x /app/brokerApp

# Build a tiny docker image.
FROM alpine:latest

RUN mkdir /app

# Copy over the executable.
COPY --from=builder /app/brokerApp /app

# Run the app.
CMD [ "/app/brokerApp" ]