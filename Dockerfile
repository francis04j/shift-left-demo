#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
ARG VERSION=5.0-alpine

FROM mcr.microsoft.com/dotnet/sdk:${VERSION} AS build
WORKDIR /app
COPY . .

WORKDIR /app/DanApi
RUN dotnet restore "DanApi.csproj" -r linux-musl-x64

FROM build AS publish
RUN dotnet publish "DanApi.csproj" -c Release -o /out --no-restore -r linux-musl-x64 -p:PublishReadyToRun=true --self-contained=true -p:PublishTrimmed=True

FROM mcr.microsoft.com/dotnet/runtime-deps:${VERSION}
WORKDIR /app/DanApi
COPY --from=publish /out .
ENTRYPOINT ["./DanApi"]