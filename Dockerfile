# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:latest AS build
WORKDIR /source

# Copy project file and restore as distinct layers
COPY TinyDino/*.csproj .
RUN dotnet restore -a amd64 

# Copy source code and publish app
COPY TinyDino/. .
RUN dotnet publish -a amd64 -o /app


# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
EXPOSE 8080
WORKDIR /app
COPY --from=build /app .
USER $APP_UID
ENTRYPOINT ["./TinyDino"]