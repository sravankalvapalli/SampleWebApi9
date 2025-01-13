# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy all project and solution files
COPY src/ ./src/

# Restore dependencies for all projects
WORKDIR /app/src/WebApi
RUN dotnet restore

# Build and publish the Web API project
RUN dotnet publish -c Release -o /app/out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copy the build output from the previous stage
COPY --from=build /app/out ./

# Expose the port the application listens on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "WebApi.dll", "--urls", "http://0.0.0.0:80"]
