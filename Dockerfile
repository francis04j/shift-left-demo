#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
ARG VERSION=5.0-alpine

FROM mcr.microsoft.com/dotnet/runtime-deps:${VERSION} AS base
WORKDIR /app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD wget http://localhost:8080/health -q -O - > /dev/null 2>&1

FROM mcr.microsoft.com/dotnet/sdk:${VERSION} AS build
WORKDIR /code

COPY ["DanApi/DanApi.csproj", "DanApi/DanApi.csproj"]
COPY ["test/DanApi.UnitTests/DanApi.UnitTests.csproj", "test/DanApi.UnitTests/DanApi.UnitTests.csproj"]

RUN dotnet restore "DanApi/DanApi.csproj" -r linux-musl-x64
RUN dotnet restore "test/DanApi.UnitTests/DanApi.UnitTests.csproj" -r linux-musl-x64

COPY . .
# Build - ALT (dont do this but let dotnet test build)
RUN dotnet build "DanApi/DanApi.csproj" -c Release --runtime linux-musl-x64 --no-restore
RUN dotnet build "test/DanApi.UnitTests/DanApi.UnitTests.csproj" -c Release --runtime linux-musl-x64 --no-restore

FROM build AS unit-test
WORKDIR /code/test/DanApi.UnitTests
ENTRYPOINT dotnet test -c Release --runtime linux-musl-x64 \
    --no-restore \
    --no-build \
    --logger "trx;LogFileName=test_results_unit_test.trx" \
    -p:CollectCoverage=true \
    -p:CoverletOutput="TestResults/coverage.info" \
    -p:CoverletOuputFormat=\"lcov,opencover\"

FROM build AS publish
RUN dotnet publish "DanApi/DanApi.csproj" -c Release -o /app/out --no-restore -r linux-musl-x64 -p:PublishReadyToRun=true --self-contained=true -p:PublishTrimmed=True

FROM base AS final
WORKDIR /app

RUN addgroup -g 1000 dotnet && adduser -u 1000 -G dotnet -s /bin/sh -D dotnet
COPY --chown=dotnet:dotnet --from=publish /app/out .
USER dotnet
ENV ASPNETCORE_URLS=http://*:8080

ENTRYPOINT ["./DanApi"]