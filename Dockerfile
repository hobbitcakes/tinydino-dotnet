# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /source

# Copy project file and restore as distinct layers
COPY --link TinyDino/*.csproj .
RUN dotnet restore -a amd64 

# Copy source code and publish app
COPY --link TinyDino/. .
RUN dotnet publish -a amd64  --no-restore -o /app


# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
EXPOSE 8080
WORKDIR /app
COPY --link --from=build /app .
USER $APP_UID
ENTRYPOINT ["./TinyDino"]