# Building the binary of the App
FROM golang:1.19 AS build

WORKDIR /go/src/tasky

# Copy all files from the current directory to tasky in the container
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky


FROM alpine:3.17.0 as release

# Set the working directory to app
WORKDIR /app

COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]

# Run the Go application
# CMD ["go", "run", "main.go"]
