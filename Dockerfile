FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ./*.csproj ./

RUN dotnet restore
COPY . .
WORKDIR /src/
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
# COPY --from=rpm57080.live.dynatrace.com/linux/oneagent-codemodules:dotnet / /
# ENV LD_PRELOAD /opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so
ENV ASPNETCORE_URLS http://+;
WORKDIR /app
EXPOSE 80
COPY --from=build /app .
# RUN curl https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem --create-dirs -o /app/Resources/Certificates/rds-ca-2019-root.pem
ENTRYPOINT ["dotnet", "apiInDocker.dll"]