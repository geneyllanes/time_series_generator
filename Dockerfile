# Use the official Dart base image
FROM google/dart

# Set the working directory
WORKDIR /app

# Copy the code into the container
COPY ./lib/src/server.dart /app

# Get dependencies
RUN dart pub get

# Build the Dart code
RUN dart compile exe bin/server.dart -o /app/server

# Set the command to run when the container starts
CMD ["/app/server"]
