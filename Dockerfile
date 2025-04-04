# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia o arquivo de solução e restaura dependências
COPY js.learn.api.sln ./
COPY js.learn.api/js.learn.api.csproj ./js.learn.api/
COPY js.learn.Core/js.learn.Core.csproj ./js.learn.Core/
COPY js.learn.Data/js.learn.Data.csproj ./js.learn.Data/
COPY js.learn.Service/js.learn.Service.csproj ./js.learn.Service/
RUN dotnet restore

# Copia o restante do código
COPY . ./
WORKDIR /app/js.learn.api
RUN dotnet publish -c Release -o /app/publish

# Etapa final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "js.learn.api.dll"]

